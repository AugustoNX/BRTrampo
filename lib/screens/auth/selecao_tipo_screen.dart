import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/usuario.dart';
import '../../widgets/auth_scaffold.dart';
import '../../widgets/primary_button.dart';
import 'cadastro_cliente_pessoal_screen.dart';
import 'cadastro_prestador_pessoal_screen.dart';

/// Tela inicial do fluxo de cadastro: o usuário escolhe se irá se
/// cadastrar como **Cliente** ou **Prestador de serviços**.
class SelecaoTipoScreen extends StatelessWidget {
  const SelecaoTipoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Complete seu cadastro',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Precisamos de algumas informações para liberar seu perfil',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'Cliente',
                onPressed: () => _navigate(context, TipoUsuario.cliente),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Prestador de serviços',
                onPressed: () => _navigate(context, TipoUsuario.prestador),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: const Text(
                  'Já tem uma conta? Entrar',
                  style: TextStyle(
                    color: AppColors.brand,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, TipoUsuario tipo) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => switch (tipo) {
          TipoUsuario.cliente => const CadastroClientePessoalScreen(),
          TipoUsuario.prestador => const CadastroPrestadorPessoalScreen(),
        },
      ),
    );
  }
}
