import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/prestador.dart';
import '../../services/usuario_repository.dart';
import '../../widgets/app_header.dart';
import '../../widgets/categoria_button.dart';
import '../../widgets/prestador_card.dart';
import '../categoria/prestadores_categoria_screen.dart';
import '../prestador/perfil_prestador_screen.dart';

/// Tela inicial do BRTrampo (visão do Cliente): header, grid de
/// categorias e seções verticais com carrosséis horizontais de
/// prestadores por categoria, lidos em tempo real do Realtime Database.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<_Categoria> _categorias = <_Categoria>[
    _Categoria('Eletricista', Icons.electrical_services),
    _Categoria('Carpinteiro', Icons.handyman),
    _Categoria('Mecânico', Icons.car_repair),
    _Categoria('Pintor', Icons.format_paint),
    _Categoria('Piscineiro', Icons.pool),
    _Categoria('Encanador', Icons.plumbing),
    _Categoria('Marceneiro', Icons.chair_alt),
    _Categoria('Diarista', Icons.cleaning_services),
  ];

  static const List<String> _categoriasDestaque = <String>[
    'Eletricista',
    'Marceneiro',
    'Pintor',
  ];

  /// Acha o ícone de uma categoria pelo nome (usado nos títulos das
  /// seções de destaque).
  static IconData _iconePara(String label) {
    return _categorias
        .firstWhere(
          (_Categoria c) => c.label == label,
          orElse: () => const _Categoria('', Icons.handyman),
        )
        .icon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: StreamBuilder<List<Prestador>>(
          stream: UsuarioRepository().observarPrestadores(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Prestador>> snapshot) {
            final List<Prestador> prestadores =
                snapshot.data ?? const <Prestador>[];

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              children: <Widget>[
                _CategoriasGrid(categorias: _categorias),
                const SizedBox(height: 24),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(color: AppColors.brand),
                    ),
                  )
                else if (prestadores.isEmpty)
                  const _EmptyState()
                else
                  for (final String cat in _categoriasDestaque) ...<Widget>[
                    _SecaoPrestadores(
                      titulo: cat,
                      icone: _iconePara(cat),
                      prestadores: prestadores
                          .where((Prestador p) =>
                              p.prestadorInfo.categoria == cat)
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: <Widget>[
          Icon(Icons.people_outline, size: 56, color: AppColors.textMuted),
          SizedBox(height: 12),
          Text(
            'Nenhum prestador cadastrado ainda.\nVolte em breve!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _CategoriasGrid extends StatelessWidget {
  const _CategoriasGrid({required this.categorias});

  final List<_Categoria> categorias;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: <Widget>[
        for (final _Categoria c in categorias)
          CategoriaButton(
            icon: c.icon,
            label: c.label,
            onTap: () => _abrirCategoria(context, c),
          ),
      ],
    );
  }

  static void _abrirCategoria(BuildContext context, _Categoria c) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PrestadoresCategoriaScreen(
          categoria: c.label,
          icone: c.icon,
        ),
      ),
    );
  }
}

class _SecaoPrestadores extends StatelessWidget {
  const _SecaoPrestadores({
    required this.titulo,
    required this.icone,
    required this.prestadores,
  });

  final String titulo;
  final IconData icone;
  final List<Prestador> prestadores;

  void _verTodos(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PrestadoresCategoriaScreen(
          categoria: titulo,
          icone: icone,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (prestadores.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.dark,
                ),
              ),
              TextButton(
                onPressed: () => _verTodos(context),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  minimumSize: const Size(0, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Ver todos',
                      style: TextStyle(
                        color: AppColors.brand,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.brand,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: prestadores.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (BuildContext context, int i) {
              final Prestador p = prestadores[i];
              return PrestadorCard(
                prestador: p,
                distanciaKm: 1.2 + i * 0.4,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PerfilPrestadorScreen(prestador: p),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Categoria {
  const _Categoria(this.label, this.icon);
  final String label;
  final IconData icon;
}
