import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/auth_wrapper.dart';

/// Widget raiz do BRTrampo.
class BRTrampoApp extends StatelessWidget {
  const BRTrampoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthController>(
      create: (_) => AuthController(),
      child: MaterialApp(
        title: 'BRTrampo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const AuthWrapper(),
      ),
    );
  }
}
