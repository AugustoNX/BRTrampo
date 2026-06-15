import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../core/theme/app_colors.dart';
import 'home/home_screen.dart';
import 'perfil/perfil_cliente_screen.dart';
import 'pesquisa/pesquisa_screen.dart';
import 'prestador/configuracoes_prestador_screen.dart';
import 'prestador/dashboard_prestador_screen.dart';

/// Shell principal do app.
///
/// Renderiza um conjunto **diferente de abas** conforme o tipo de
/// usuário autenticado:
///
/// - **Cliente**: Home (busca prestadores) • Pesquisa • Meu Perfil
/// - **Prestador**: Meu Perfil Público • (placeholder) Solicitações •
///   Configurações
///
/// A navbar é renderizada como overlay flutuante via [Stack] para
/// respeitar a barra de gestos do Android (edge-to-edge).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final AuthController auth = context.watch<AuthController>();
    final List<_TabConfig> tabs = _buildTabsFor(auth);

    // Garante que o índice não estoure caso o número de tabs mude.
    if (_currentIndex >= tabs.length) _currentIndex = 0;

    final double bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: <Widget>[
          IndexedStack(
            index: _currentIndex,
            children: <Widget>[for (final _TabConfig t in tabs) t.screen],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: bottomInset > 0 ? bottomInset : 16,
            child: _FloatingNavBar(
              items: tabs,
              currentIndex: _currentIndex,
              onTap: (int i) => setState(() => _currentIndex = i),
            ),
          ),
        ],
      ),
    );
  }

  /// Define as abas baseado no tipo de usuário.
  ///
  /// Esta é a única função do shell que conhece a diferença entre
  /// cliente e prestador — toda a navegação posterior é uniforme.
  List<_TabConfig> _buildTabsFor(AuthController auth) {
    if (auth.isPrestador) {
      return const <_TabConfig>[
        _TabConfig(
          icon: Icons.person_outline,
          iconActive: Icons.person,
          screen: DashboardPrestadorScreen(),
        ),
        _TabConfig(
          icon: Icons.assignment_outlined,
          iconActive: Icons.assignment,
          screen: _PlaceholderScreen(
            title: 'Solicitações',
            subtitle: 'Lista de clientes que solicitaram\nseu serviço',
          ),
        ),
        _TabConfig(
          icon: Icons.settings_outlined,
          iconActive: Icons.settings,
          screen: ConfiguracoesPrestadorScreen(),
        ),
      ];
    }

    // Padrão: Cliente.
    return const <_TabConfig>[
      _TabConfig(
        icon: Icons.home_outlined,
        iconActive: Icons.home,
        screen: HomeScreen(),
      ),
      _TabConfig(
        icon: Icons.search,
        iconActive: Icons.search,
        screen: PesquisaScreen(),
      ),
      _TabConfig(
        icon: Icons.person_outline,
        iconActive: Icons.person,
        screen: PerfilClienteScreen(),
      ),
    ];
  }
}

class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<_TabConfig> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(40),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          for (int i = 0; i < items.length; i++)
            _NavButton(
              icon: i == currentIndex ? items[i].iconActive : items[i].icon,
              selected: i == currentIndex,
              onTap: () => onTap(i),
            ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Icon(
            icon,
            size: 26,
            color: selected ? AppColors.brand : AppColors.white,
          ),
        ),
      ),
    );
  }
}

class _TabConfig {
  const _TabConfig({
    required this.icon,
    required this.iconActive,
    required this.screen,
  });

  final IconData icon;
  final IconData iconActive;
  final Widget screen;
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
