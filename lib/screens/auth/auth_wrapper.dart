import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../main_shell.dart';
import 'login_screen.dart';
import 'selecao_tipo_screen.dart';

/// Widget raiz que escolhe a tela a exibir conforme o [AuthStatus].
///
/// - [AuthStatus.carregando] → splash com loader
/// - [AuthStatus.deslogado]  → [LoginScreen]
/// - [AuthStatus.semPerfil]  → reentrada no [SelecaoTipoScreen]
/// - [AuthStatus.autenticado] → [MainShell] (que internamente adapta
///   as abas conforme `Cliente` ou `Prestador`)
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = context.watch<AuthController>();

    return switch (auth.status) {
      AuthStatus.carregando => const _SplashScreen(),
      AuthStatus.deslogado => const LoginScreen(),
      AuthStatus.semPerfil => const SelecaoTipoScreen(),
      AuthStatus.autenticado => const MainShell(),
    };
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.dark,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.brand),
      ),
    );
  }
}
