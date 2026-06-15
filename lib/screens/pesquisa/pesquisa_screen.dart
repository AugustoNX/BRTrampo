import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/prestador.dart';
import '../../services/usuario_repository.dart';
import '../../widgets/app_header.dart';
import '../../widgets/prestador_card.dart';
import '../prestador/perfil_prestador_screen.dart';

/// Tela de pesquisa de prestadores (visão do Cliente).
///
/// Barra de busca escura, chips de filtros rápidos e grid vertical
/// reutilizando o [PrestadorCard]. Lê em tempo real do RTDB via
/// [UsuarioRepository].
class PesquisaScreen extends StatefulWidget {
  const PesquisaScreen({super.key});

  @override
  State<PesquisaScreen> createState() => _PesquisaScreenState();
}

class _PesquisaScreenState extends State<PesquisaScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final UsuarioRepository _repo = UsuarioRepository();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Prestador> _filtrar(List<Prestador> todos) {
    if (_query.trim().isEmpty) return todos;
    final String q = _query.toLowerCase();
    return todos.where((Prestador p) {
      return p.nome.toLowerCase().contains(q) ||
          p.prestadorInfo.categoria.toLowerCase().contains(q) ||
          p.cidadeBase.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _SearchBar(
                controller: _searchCtrl,
                onChanged: (String v) => setState(() => _query = v),
              ),
              const SizedBox(height: 12),
              const _FiltrosChips(),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<Prestador>>(
                  stream: _repo.observarPrestadores(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Prestador>> snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.brand,
                        ),
                      );
                    }
                    final List<Prestador> resultados =
                        _filtrar(snapshot.data ?? const <Prestador>[]);
                    if (resultados.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nenhum prestador encontrado.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: resultados.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (BuildContext context, int i) {
                        final Prestador p = resultados[i];
                        return PrestadorCard(
                          prestador: p,
                          distanciaKm: 1.2 + i * 0.3,
                          width: double.infinity,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  PerfilPrestadorScreen(prestador: p),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: AppColors.white),
      cursorColor: AppColors.brand,
      decoration: const InputDecoration(
        hintText: 'Buscar prestadores...',
        suffixIcon: Icon(Icons.search, color: AppColors.white),
      ),
    );
  }
}

class _FiltrosChips extends StatelessWidget {
  const _FiltrosChips();

  static const List<String> _filtros = <String>[
    'Localização',
    'Categoria',
    'Avaliação',
    'Preço',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filtros.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, int i) => _FilterChip(label: _filtros[i]),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // TODO(filter): abrir bottom sheet de filtro avançado.
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down,
                  size: 16, color: AppColors.dark),
            ],
          ),
        ),
      ),
    );
  }
}
