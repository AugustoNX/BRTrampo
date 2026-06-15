import 'servico_oferecido.dart';

/// Informações de portfólio e reputação de um prestador de serviços.
///
/// Encapsula dados de apresentação profissional (categoria, descrição,
/// trabalhos, certificados, serviços oferecidos) e métricas calculadas
/// pela plataforma (`notaMedia` e `trabalhosRealizados`).
class PrestadorInfo {
  const PrestadorInfo({
    required this.categoria,
    required this.descricao,
    required this.tempoExperiencia,
    this.urlFotoPerfil = '',
    this.fotosTrabalhos = const <String>[],
    this.certificados = const <String>[],
    this.servicos = const <ServicoOferecido>[],
    this.notaMedia = 0.0,
    this.trabalhosRealizados = 0,
  });

  factory PrestadorInfo.fromMap(Map<String, dynamic> map) {
    return PrestadorInfo(
      categoria: map['categoria'] as String? ?? '',
      descricao: map['descricao'] as String? ?? '',
      tempoExperiencia: map['tempo_experiencia'] as String? ?? '',
      urlFotoPerfil: map['url_foto_perfil'] as String? ?? '',
      fotosTrabalhos: List<String>.from(
        (map['fotos_trabalhos'] as List<dynamic>? ?? <dynamic>[])
            .map((dynamic e) => e.toString()),
      ),
      certificados: List<String>.from(
        (map['certificados'] as List<dynamic>? ?? <dynamic>[])
            .map((dynamic e) => e.toString()),
      ),
      servicos: ((map['servicos'] as List<dynamic>?) ?? <dynamic>[])
          .map((dynamic e) {
            if (e is Map) {
              return ServicoOferecido.fromMap(
                e.map((Object? k, Object? v) =>
                    MapEntry<String, dynamic>(k.toString(), v)),
              );
            }
            return ServicoOferecido(nome: e.toString());
          })
          .toList(),
      notaMedia: (map['nota_media'] as num? ?? 0).toDouble(),
      trabalhosRealizados: (map['trabalhos_realizados'] as num? ?? 0).toInt(),
    );
  }

  final String categoria;
  final String descricao;
  final String tempoExperiencia;
  final String urlFotoPerfil;
  final List<String> fotosTrabalhos;
  final List<String> certificados;
  final List<ServicoOferecido> servicos;
  final double notaMedia;
  final int trabalhosRealizados;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'categoria': categoria,
        'descricao': descricao,
        'tempo_experiencia': tempoExperiencia,
        'url_foto_perfil': urlFotoPerfil,
        'fotos_trabalhos': fotosTrabalhos,
        'certificados': certificados,
        'servicos': servicos.map((ServicoOferecido s) => s.toMap()).toList(),
        'nota_media': notaMedia,
        'trabalhos_realizados': trabalhosRealizados,
      };

  PrestadorInfo copyWith({
    String? categoria,
    String? descricao,
    String? tempoExperiencia,
    String? urlFotoPerfil,
    List<String>? fotosTrabalhos,
    List<String>? certificados,
    List<ServicoOferecido>? servicos,
    double? notaMedia,
    int? trabalhosRealizados,
  }) {
    return PrestadorInfo(
      categoria: categoria ?? this.categoria,
      descricao: descricao ?? this.descricao,
      tempoExperiencia: tempoExperiencia ?? this.tempoExperiencia,
      urlFotoPerfil: urlFotoPerfil ?? this.urlFotoPerfil,
      fotosTrabalhos: fotosTrabalhos ?? this.fotosTrabalhos,
      certificados: certificados ?? this.certificados,
      servicos: servicos ?? this.servicos,
      notaMedia: notaMedia ?? this.notaMedia,
      trabalhosRealizados: trabalhosRealizados ?? this.trabalhosRealizados,
    );
  }
}
