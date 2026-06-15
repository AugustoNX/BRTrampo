import 'prestador_info.dart';
import 'usuario.dart';

/// Modelo do usuário **Prestador**: profissional autônomo que oferece
/// serviços na plataforma BRTrampo.
class Prestador extends Usuario {
  const Prestador({
    required super.uid,
    required super.nome,
    required super.email,
    required this.telefone,
    required this.cidadeBase,
    required this.regiaoAtendimento,
    required this.prestadorInfo,
  }) : super(tipoUsuario: TipoUsuario.prestador);

  factory Prestador.fromMap(Map<String, dynamic> map) {
    return Prestador(
      uid: map['uid'] as String? ?? '',
      nome: map['nome'] as String? ?? '',
      email: map['email'] as String? ?? '',
      telefone: map['telefone'] as String? ?? '',
      cidadeBase: map['cidade_base'] as String? ?? '',
      regiaoAtendimento: map['regiao_atendimento'] as String? ?? '',
      prestadorInfo: PrestadorInfo.fromMap(
        Map<String, dynamic>.from(
          map['prestador_info'] as Map<dynamic, dynamic>? ??
              <dynamic, dynamic>{},
        ),
      ),
    );
  }

  /// WhatsApp do profissional, usado para redirecionamento direto.
  final String telefone;

  /// Cidade onde reside / atua como base.
  final String cidadeBase;

  /// Regiões/bairros cobertos pelo profissional.
  final String regiaoAtendimento;

  /// Portfólio, reputação e dados profissionais.
  final PrestadorInfo prestadorInfo;

  @override
  Map<String, dynamic> toMap() => <String, dynamic>{
        ...super.toMap(),
        'telefone': telefone,
        'cidade_base': cidadeBase,
        'regiao_atendimento': regiaoAtendimento,
        'prestador_info': prestadorInfo.toMap(),
      };

  Prestador copyWith({
    String? uid,
    String? nome,
    String? email,
    String? telefone,
    String? cidadeBase,
    String? regiaoAtendimento,
    PrestadorInfo? prestadorInfo,
  }) {
    return Prestador(
      uid: uid ?? this.uid,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      cidadeBase: cidadeBase ?? this.cidadeBase,
      regiaoAtendimento: regiaoAtendimento ?? this.regiaoAtendimento,
      prestadorInfo: prestadorInfo ?? this.prestadorInfo,
    );
  }
}
