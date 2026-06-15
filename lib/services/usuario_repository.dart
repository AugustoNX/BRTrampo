import 'package:firebase_database/firebase_database.dart';

import '../models/cliente.dart';
import '../models/prestador.dart';
import '../models/usuario.dart';

/// Acesso ao Realtime Database para persistir e ler `Cliente` e
/// `Prestador`.
///
/// **Modelo de dados no RTDB:**
///
/// ```
/// /usuarios/{uid}              ← dados completos (privado, só o dono lê/escreve)
///    ├─ uid, nome, email, tipo_usuario, created_at
///    ├─ [se cliente]   telefone, endereco/{cep, cidade, rua, numero}
///    └─ [se prestador] telefone, cidade_base, regiao_atendimento, prestador_info/{...}
///
/// /prestadores/{uid}           ← projeção pública (qualquer usuário auth pode ler)
///    └─ nome, cidade_base, regiao_atendimento, telefone, prestador_info/{...}
/// ```
///
/// **Regras de segurança recomendadas (configurar no Firebase Console):**
/// ```json
/// {
///   "rules": {
///     "usuarios": {
///       "$uid": {
///         ".read":  "$uid === auth.uid",
///         ".write": "$uid === auth.uid"
///       }
///     },
///     "prestadores": {
///       ".read": "auth != null",
///       "$uid": {
///         ".write": "$uid === auth.uid"
///       }
///     }
///   }
/// }
/// ```
class UsuarioRepository {
  UsuarioRepository({FirebaseDatabase? database})
      : _db = database ?? FirebaseDatabase.instance;

  final FirebaseDatabase _db;

  DatabaseReference get _usuariosRef => _db.ref('usuarios');
  DatabaseReference get _prestadoresRef => _db.ref('prestadores');

  /// Cria/atualiza o registro completo do cliente em `/usuarios/{uid}`.
  Future<void> salvarCliente(Cliente cliente) async {
    await _usuariosRef.child(cliente.uid).set(<String, dynamic>{
      ...cliente.toMap(),
      'created_at': ServerValue.timestamp,
    });
  }

  /// Cria/atualiza o registro completo do prestador em `/usuarios/{uid}`
  /// **e** a projeção pública em `/prestadores/{uid}`, em uma única
  /// operação multi-path (atômica do lado do servidor).
  Future<void> salvarPrestador(Prestador prestador) async {
    await _db.ref().update(<String, dynamic>{
      'usuarios/${prestador.uid}': <String, dynamic>{
        ...prestador.toMap(),
        'created_at': ServerValue.timestamp,
      },
      'prestadores/${prestador.uid}': _projecaoPublica(prestador),
    });
  }

  /// Atualiza o prestador existente sem sobrescrever `created_at`.
  ///
  /// Funciona como o [salvarPrestador], mas preserva o timestamp de
  /// criação original — usado pela tela de Configurações quando o
  /// prestador edita seus dados.
  Future<void> atualizarPrestador(Prestador prestador) async {
    await _db.ref().update(<String, dynamic>{
      'usuarios/${prestador.uid}': <String, dynamic>{
        ...prestador.toMap(),
        'updated_at': ServerValue.timestamp,
      },
      'prestadores/${prestador.uid}': _projecaoPublica(prestador),
    });
  }

  /// Subconjunto dos dados do prestador exposto publicamente em
  /// `/prestadores/{uid}` — sem `email`, sem `created_at`.
  Map<String, dynamic> _projecaoPublica(Prestador p) => <String, dynamic>{
        'nome': p.nome,
        'telefone': p.telefone,
        'cidade_base': p.cidadeBase,
        'regiao_atendimento': p.regiaoAtendimento,
        'prestador_info': p.prestadorInfo.toMap(),
      };

  /// Lê o usuário (Cliente ou Prestador) em `/usuarios/{uid}`.
  ///
  /// Retorna `null` se o nó não existir. Decide a subclasse pelo campo
  /// `tipo_usuario`.
  Future<Usuario?> carregarUsuario(String uid) async {
    final DataSnapshot snap = await _usuariosRef.child(uid).get();
    if (!snap.exists || snap.value == null) return null;

    final Map<String, dynamic> map = _coerceMap(snap.value);
    final TipoUsuario tipo =
        TipoUsuario.fromValue(map['tipo_usuario'] as String? ?? '');

    return switch (tipo) {
      TipoUsuario.cliente => Cliente.fromMap(map),
      TipoUsuario.prestador => Prestador.fromMap(map),
    };
  }

  /// Stream do próprio registro, útil para reagir a alterações em
  /// tempo real (ex.: nova avaliação muda a `nota_media`).
  Stream<Usuario?> observarUsuario(String uid) {
    return _usuariosRef.child(uid).onValue.map((DatabaseEvent event) {
      final DataSnapshot snap = event.snapshot;
      if (!snap.exists || snap.value == null) return null;
      final Map<String, dynamic> map = _coerceMap(snap.value);
      final TipoUsuario tipo =
          TipoUsuario.fromValue(map['tipo_usuario'] as String? ?? '');
      return switch (tipo) {
        TipoUsuario.cliente => Cliente.fromMap(map),
        TipoUsuario.prestador => Prestador.fromMap(map),
      };
    });
  }

  /// Lista todos os prestadores públicos (para Home e Pesquisa do
  /// cliente).
  Future<List<Prestador>> listarPrestadores() async {
    final DataSnapshot snap = await _prestadoresRef.get();
    if (!snap.exists || snap.value == null) return <Prestador>[];

    final Map<String, dynamic> all = _coerceMap(snap.value);
    return all.entries.map((MapEntry<String, dynamic> e) {
      final Map<String, dynamic> data = _coerceMap(e.value);
      // O nó público não tem 'email' nem 'tipo_usuario'; injetamos para
      // permitir a desserialização via Prestador.fromMap.
      data['uid'] = e.key;
      data['email'] = '';
      data['tipo_usuario'] = TipoUsuario.prestador.value;
      return Prestador.fromMap(data);
    }).toList();
  }

  /// Stream em tempo real da lista de prestadores públicos.
  Stream<List<Prestador>> observarPrestadores() {
    return _prestadoresRef.onValue.map((DatabaseEvent event) {
      final DataSnapshot snap = event.snapshot;
      if (!snap.exists || snap.value == null) return <Prestador>[];
      final Map<String, dynamic> all = _coerceMap(snap.value);
      return all.entries.map((MapEntry<String, dynamic> e) {
        final Map<String, dynamic> data = _coerceMap(e.value);
        data['uid'] = e.key;
        data['email'] = '';
        data['tipo_usuario'] = TipoUsuario.prestador.value;
        return Prestador.fromMap(data);
      }).toList();
    });
  }

  /// O RTDB retorna `Map<Object?, Object?>` (não `Map<String, dynamic>`),
  /// e às vezes `Map<dynamic, dynamic>`. Este helper converte
  /// recursivamente para `Map<String, dynamic>`.
  Map<String, dynamic> _coerceMap(Object? value) {
    if (value is Map) {
      return value.map<String, dynamic>(
        (Object? k, Object? v) => MapEntry<String, dynamic>(
          k.toString(),
          v is Map ? _coerceMap(v) : v,
        ),
      );
    }
    return <String, dynamic>{};
  }
}
