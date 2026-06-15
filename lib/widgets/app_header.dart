import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// AppBar padrão das telas principais do BRTrampo.
///
/// Composto por: menu lateral (hambúrguer) à esquerda, logo central com
/// um martelo laranja seguido do nome **BRTrampo** e espaço simétrico
/// à direita para manter o título centralizado.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.dark),
        onPressed: onMenuTap ?? () => Scaffold.maybeOf(context)?.openDrawer(),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.brand.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.handyman_rounded,
              color: AppColors.brand,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'BR',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.brand,
              fontSize: 18,
            ),
          ),
          const Text(
            'Trampo',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.dark,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: const <Widget>[SizedBox(width: 48)],
    );
  }
}
