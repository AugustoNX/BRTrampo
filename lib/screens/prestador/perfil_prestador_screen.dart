import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../models/prestador.dart';
import '../../models/servico_oferecido.dart';
import '../../widgets/app_header.dart';
import '../../widgets/primary_button.dart';

/// Tela de perfil público do prestador (portfólio).
///
/// Contém: header de identificação, bio, botões de ação (Contratar e
/// Conversar via WhatsApp) e carrosséis de trabalhos e certificados.
class PerfilPrestadorScreen extends StatelessWidget {
  const PerfilPrestadorScreen({super.key, required this.prestador});

  final Prestador prestador;

  Future<void> _abrirWhatsApp(BuildContext context) async {
    final Uri uri = Uri.parse('https://wa.me/${prestador.telefone}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
          children: <Widget>[
            _Identificacao(prestador: prestador),
            const SizedBox(height: 18),
            Text(
              prestador.prestadorInfo.descricao,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                Expanded(
                  child: PrimaryButton(
                    label: 'Contratar',
                    onPressed: () {
                      // TODO(contratacao): abrir fluxo de contratação.
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    label: 'Conversar',
                    icon: Icons.chat_bubble_outline,
                    onPressed: () => _abrirWhatsApp(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _SecaoServicos(servicos: prestador.prestadorInfo.servicos),
            const SizedBox(height: 24),
            _SecaoCarrossel(
              titulo: 'Trabalhos',
              itens: prestador.prestadorInfo.fotosTrabalhos,
              builder: (String url) => _CardTrabalho(url: url),
              cardWidth: 160,
              cardHeight: 200,
            ),
            const SizedBox(height: 20),
            _SecaoCarrossel(
              titulo: 'Certificados',
              itens: prestador.prestadorInfo.certificados,
              builder: (String nome) => _CardCertificado(nome: nome),
              cardWidth: 130,
              cardHeight: 150,
            ),
          ],
        ),
      ),
    );
  }
}

class _Identificacao extends StatelessWidget {
  const _Identificacao({required this.prestador});

  final Prestador prestador;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      prestador.nome,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.dark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.verified, color: AppColors.brand, size: 18),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: <Widget>[
                  Text(
                    prestador.prestadorInfo.categoria,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const Text(' • ', style: TextStyle(color: AppColors.textMuted)),
                  Text(
                    prestador.cidadeBase,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    prestador.prestadorInfo.notaMedia
                        .toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.dark,
                    ),
                  ),
                  const Icon(Icons.star_rounded,
                      size: 16, color: AppColors.brand),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: SizedBox(
            width: 72,
            height: 72,
            child: prestador.prestadorInfo.urlFotoPerfil.isEmpty
                ? Container(
                    color: AppColors.border,
                    alignment: Alignment.center,
                    child: const Icon(Icons.person,
                        size: 40, color: AppColors.textMuted),
                  )
                : CachedNetworkImage(
                    imageUrl: prestador.prestadorInfo.urlFotoPerfil,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ],
    );
  }
}

class _SecaoCarrossel<T> extends StatelessWidget {
  const _SecaoCarrossel({
    required this.titulo,
    required this.itens,
    required this.builder,
    required this.cardWidth,
    required this.cardHeight,
  });

  final String titulo;
  final List<T> itens;
  final Widget Function(T) builder;
  final double cardWidth;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    if (itens.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 2),
          child: Text(
            titulo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.dark,
            ),
          ),
        ),
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: itens.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, int i) => SizedBox(
              width: cardWidth,
              child: builder(itens[i]),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardTrabalho extends StatelessWidget {
  const _CardTrabalho({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              child: url.isEmpty
                  ? Container(
                      color: AppColors.border,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image,
                          size: 36, color: AppColors.textMuted),
                    )
                  : CachedNetworkImage(imageUrl: url, fit: BoxFit.cover),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 6, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Manutenção de padrão',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.dark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  'Descrição curta do trabalho realizado pelo prestador.',
                  style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardCertificado extends StatelessWidget {
  const _CardCertificado({required this.nome});
  final String nome;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.workspace_premium,
              size: 56, color: AppColors.brand),
          const SizedBox(height: 6),
          Text(
            nome,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.dark,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SecaoServicos extends StatelessWidget {
  const _SecaoServicos({required this.servicos});
  final List<ServicoOferecido> servicos;

  @override
  Widget build(BuildContext context) {
    if (servicos.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(bottom: 12, left: 2),
          child: Text(
            'Serviços oferecidos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.dark,
            ),
          ),
        ),
        for (final ServicoOferecido s in servicos)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(
                  Icons.check_circle,
                  size: 18,
                  color: AppColors.brand,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        s.nome,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.dark,
                        ),
                      ),
                      if (s.descricao.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 2),
                        Text(
                          s.descricao,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
