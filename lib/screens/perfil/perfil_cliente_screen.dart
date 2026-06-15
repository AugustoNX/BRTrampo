import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../models/cliente.dart';
import '../../widgets/app_header.dart';

/// Tela de perfil do **Cliente**: mostra seus dados pessoais e endereço
/// (privado), além do botão de logout.
class PerfilClienteScreen extends StatelessWidget {
  const PerfilClienteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Cliente? cliente = context.watch<AuthController>().cliente;
    if (cliente == null) {
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
            const _AvatarCabecalho(),
            const SizedBox(height: 16),
            Center(
              child: Text(
                cliente.nome,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.dark,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                cliente.email,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const _SectionTitle('Endereço (privado)'),
            _InfoRow(label: 'CEP', value: cliente.endereco.cep),
            _InfoRow(label: 'Cidade', value: cliente.endereco.cidade),
            _InfoRow(label: 'Rua', value: cliente.endereco.rua),
            _InfoRow(label: 'Número', value: cliente.endereco.numero),
            const SizedBox(height: 24),
            const _LogoutButton(),
          ],
        ),
      ),
    );
  }
}

class _AvatarCabecalho extends StatelessWidget {
  const _AvatarCabecalho();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: AppColors.brand.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person, size: 56, color: AppColors.brand),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.dark,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.dark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
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
    );
  }
}
