import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../models/prestador.dart';
import '../../widgets/app_header.dart';
import 'perfil_prestador_screen.dart';

/// Dashboard inicial do **Prestador** após login.
///
/// Mostra um cartão de identificação com métricas chave (`nota_media`,
/// `trabalhos_realizados`, categoria) e ações rápidas — incluindo
/// "Ver perfil público" (mesma tela que o cliente vê) e "Sair".
class DashboardPrestadorScreen extends StatelessWidget {
  const DashboardPrestadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Prestador? prestador = context.watch<AuthController>().prestador;
    if (prestador == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const AppHeader(),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
          children: <Widget>[
            _CardIdentificacao(prestador: prestador),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: _MetricCard(
                    icon: Icons.star_rounded,
                    value: prestador.prestadorInfo.notaMedia
                        .toStringAsFixed(1)
                        .replaceAll('.', ','),
                    label: 'Nota média',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.work_outline,
                    value: prestador.prestadorInfo.trabalhosRealizados
                        .toString(),
                    label: 'Trabalhos',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _AcaoItem(
              icon: Icons.visibility_outlined,
              titulo: 'Ver meu perfil público',
              subtitulo: 'Veja como os clientes te encontram',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      PerfilPrestadorScreen(prestador: prestador),
                ),
              ),
            ),
            _AcaoItem(
              icon: Icons.photo_library_outlined,
              titulo: 'Gerenciar trabalhos',
              subtitulo:
                  '${prestador.prestadorInfo.fotosTrabalhos.length} foto(s) no portfólio',
              onTap: () {
                // TODO(portfolio): tela de upload/gerenciamento.
              },
            ),
            _AcaoItem(
              icon: Icons.workspace_premium_outlined,
              titulo: 'Certificados',
              subtitulo:
                  '${prestador.prestadorInfo.certificados.length} certificado(s)',
              onTap: () {
                // TODO(certs): tela de gerenciamento de certificados.
              },
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
                minimumSize: const Size.fromHeight(48),
                side: const BorderSide(color: AppColors.danger),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              onPressed: () => context.read<AuthController>().logout(),
              icon: const Icon(Icons.logout),
              label: const Text(
                'Sair da conta',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardIdentificacao extends StatelessWidget {
  const _CardIdentificacao({required this.prestador});
  final Prestador prestador;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.brand.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 36, color: AppColors.brand),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  prestador.nome,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.dark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${prestador.prestadorInfo.categoria} • ${prestador.cidadeBase}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                  maxLines: 1,
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

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: AppColors.brand, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.dark,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _AcaoItem extends StatelessWidget {
  const _AcaoItem({
    required this.icon,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  final IconData icon;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.brand.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.brand, size: 22),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.dark,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitulo,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
        onTap: onTap,
      ),
    );
  }
}
