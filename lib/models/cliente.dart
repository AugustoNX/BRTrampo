import 'endereco.dart';
import 'usuario.dart';

/// Modelo do usuário **Cliente**: quem contrata serviços na plataforma.
class Cliente extends Usuario {
  const Cliente({
    required super.uid,
    required super.nome,
    required super.email,
    required this.telefone,
    required this.endereco,
  }) : super(tipoUsuario: TipoUsuario.cliente);

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      uid: map['uid'] as String? ?? '',
      nome: map['nome'] as String? ?? '',
      email: map['email'] as String? ?? '',
      telefone: map['telefone'] as String? ?? '',
      endereco: Endereco.fromMap(
        Map<String, dynamic>.from(
          map['endereco'] as Map<dynamic, dynamic>? ?? <dynamic, dynamic>{},
        ),
      ),
    );
  }

  final String telefone;
  final Endereco endereco;

  @override
  Map<String, dynamic> toMap() => <String, dynamic>{
        ...super.toMap(),
        'telefone': telefone,
        'endereco': endereco.toMap(),
      };

  Cliente copyWith({
    String? uid,
    String? nome,
    String? email,
    String? telefone,
    Endereco? endereco,
  }) {
    return Cliente(
      uid: uid ?? this.uid,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      endereco: endereco ?? this.endereco,
    );
  }
}
