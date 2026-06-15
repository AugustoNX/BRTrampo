/// Tipos de usuário suportados pelo BRTrampo.
enum TipoUsuario {
  cliente('cliente'),
  prestador('prestador');

  const TipoUsuario(this.value);

  /// Valor textual usado para serialização no Firestore.
  final String value;

  static TipoUsuario fromValue(String value) {
    return TipoUsuario.values.firstWhere(
      (TipoUsuario t) => t.value == value,
      orElse: () => TipoUsuario.cliente,
    );
  }
}

/// Classe base abstrata para qualquer usuário autenticado na plataforma.
///
/// Centraliza os campos comuns ([uid], [nome], [email], [tipoUsuario])
/// herdados por `Cliente` e `Prestador`.
abstract class Usuario {
  const Usuario({
    required this.uid,
    required this.nome,
    required this.email,
    required this.tipoUsuario,
  });

  final String uid;
  final String nome;
  final String email;
  final TipoUsuario tipoUsuario;

  /// Serializa os campos comuns. Subclasses devem chamar este método
  /// e mesclar com seus próprios campos específicos.
  Map<String, dynamic> toMap() => <String, dynamic>{
        'uid': uid,
        'nome': nome,
        'email': email,
        'tipo_usuario': tipoUsuario.value,
      };
}
