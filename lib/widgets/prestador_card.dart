import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/prestador.dart';

/// Card branco arredondado que apresenta um prestador de forma compacta.
///
/// Reutilizado em: carrosséis horizontais da Home, grid vertical da
/// Pesquisa e qualquer outra listagem de profissionais.
///
/// Recebe um [Prestador] e a [distanciaKm] (calculada externamente para
/// preservar a privacidade do endereço do cliente).
class PrestadorCard extends StatelessWidget {
  const PrestadorCard({
    super.key,
    required this.prestador,
    this.distanciaKm,
    this.onTap,
    this.width = 150,
  });

  final Prestador prestador;
  final double? distanciaKm;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          width: width,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _ProfileImage(url: prestador.prestadorInfo.urlFotoPerfil),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      prestador.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.dark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (prestador.prestadorInfo.notaMedia > 0)
                    _RatingPill(rating: prestador.prestadorInfo.notaMedia),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      prestador.prestadorInfo.categoria,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (distanciaKm != null)
                    Text(
                      _formatKm(distanciaKm!),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatKm(double km) {
    final String value = km.toStringAsFixed(1).replaceAll('.', ',');
    return '$value KM';
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Container(
        color: AppColors.border,
        alignment: Alignment.center,
        child: const Icon(Icons.person, size: 48, color: AppColors.textMuted),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => Container(color: AppColors.border),
      errorWidget: (_, _, _) => Container(
        color: AppColors.border,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image, color: AppColors.textMuted),
      ),
    );
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          rating.toStringAsFixed(1).replaceAll('.', ','),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.dark,
          ),
        ),
        const SizedBox(width: 2),
        const Icon(Icons.star_rounded, size: 14, color: AppColors.brand),
      ],
    );
  }
}
