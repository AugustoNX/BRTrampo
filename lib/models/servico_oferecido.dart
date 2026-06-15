/// Um serviço específico oferecido por um prestador dentro de sua
/// categoria.
///
/// Exemplo (categoria = "Eletricista"):
/// - `ServicoOferecido(nome: 'Instalação de tomada', descricao: '...')`
/// - `ServicoOferecido(nome: 'Troca de disjuntor', descricao: '...')`
///
/// Mantém apenas [nome] e [descricao] na versão atual. Campos como
/// `preco` ou `tempoEstimado` podem ser adicionados sem quebrar a
/// serialização (basta adicionar novos campos no [toMap]/[fromMap]).
class ServicoOferecido {
  const ServicoOferecido({
    required this.nome,
    this.descricao = '',
  });

  factory ServicoOferecido.fromMap(Map<String, dynamic> map) {
    return ServicoOferecido(
      nome: map['nome'] as String? ?? '',
      descricao: map['descricao'] as String? ?? '',
    );
  }

  final String nome;
  final String descricao;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'nome': nome,
        'descricao': descricao,
      };

  ServicoOferecido copyWith({String? nome, String? descricao}) {
    return ServicoOferecido(
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
    );
  }
}
