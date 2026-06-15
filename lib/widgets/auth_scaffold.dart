import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Scaffold padrão das telas do fluxo de autenticação (login e
/// cadastros).
///
/// Resolve dois problemas de uma vez:
///
/// 1. **Centraliza** o [child] (geralmente um `Card`) na vertical quando
///    o teclado está fechado.
/// 2. Permite que o conteúdo **role** quando o teclado abre — evitando
///    o erro clássico de `RenderFlex overflowed by N pixels`.
///
/// Usa `LayoutBuilder` + `ConstrainedBox(minHeight: ...)` + `IntrinsicHeight`
/// + `Column(mainAxisAlignment: center)` dentro de um `SingleChildScrollView`,
/// que é o padrão recomendado pelo time do Flutter para esse caso.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.child,
    this.appBarTitle,
  });

  /// Conteúdo principal — normalmente um `Card`.
  final Widget child;

  /// Se fornecido, exibe um [AppBar] escuro com este título.
  final String? appBarTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      // resizeToAvoidBottomInset é true por padrão; explícito p/ clareza.
      resizeToAvoidBottomInset: true,
      appBar: appBarTitle == null
          ? null
          : AppBar(
              backgroundColor: AppColors.dark,
              foregroundColor: AppColors.white,
              elevation: 0,
              title: Text(
                appBarTitle!,
                style: const TextStyle(fontSize: 14),
              ),
            ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[child],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
