/// Endereço residencial completo do cliente.
///
/// **Importante (privacidade):** o endereço do cliente é privado e deve
/// permanecer acessível apenas ao próprio usuário e a operações de
/// cálculo de distância. Nunca deve ser exposto a terceiros na UI.
class Endereco {
  const Endereco({
    required this.cep,
    required this.cidade,
    required this.rua,
    required this.numero,
  });

  factory Endereco.fromMap(Map<String, dynamic> map) {
    return Endereco(
      cep: map['cep'] as String? ?? '',
      cidade: map['cidade'] as String? ?? '',
      rua: map['rua'] as String? ?? '',
      numero: map['numero'] as String? ?? '',
    );
  }

  final String cep;
  final String cidade;
  final String rua;
  final String numero;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'cep': cep,
        'cidade': cidade,
        'rua': rua,
        'numero': numero,
      };

  Endereco copyWith({
    String? cep,
    String? cidade,
    String? rua,
    String? numero,
  }) {
    return Endereco(
      cep: cep ?? this.cep,
      cidade: cidade ?? this.cidade,
      rua: rua ?? this.rua,
      numero: numero ?? this.numero,
    );
  }
}
