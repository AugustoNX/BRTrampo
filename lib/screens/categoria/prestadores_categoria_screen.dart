import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/prestador.dart';
import '../../services/usuario_repository.dart';
import '../../widgets/prestador_card.dart';
import '../prestador/perfil_prestador_screen.dart';

/// Listagem em grid de todos os prestadores de uma **categoria
/// específica** (ex: "Eletricista").
///
/// Aberta a partir dos ícones da Home. Lê em tempo real do
/// [UsuarioRepository] e filtra por `prestador_info.categoria`.
/// Inclui um campo de busca local para refinar entre os prestadores
/// da categoria sem fazer outra query.
class PrestadoresCategoriaScreen extends StatefulWidget {
  const PrestadoresCategoriaScreen({
    super.key,
    required this.categoria,
    required this.icone,
  });

  /// Nome da categoria, exatamente como gravado em
  /// `/prestadores/{uid}/prestador_info/categoria` (ex: "Eletricista").
  final String categoria;

  /// Ícone usado no header da tela.
  final IconData icone;

  @override
  State<PrestadoresCategoriaScreen> createState() =>
      _PrestadoresCategoriaScreenState();
}

class _PrestadoresCategoriaScreenState
    extends State<PrestadoresCategoriaScreen> {
  final UsuarioRepository _repo = UsuarioRepository();
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Prestador> _filtrar(List<Prestador> todos) {
    final List<Prestador> daCategoria = todos
        .where((Prestador p) => p.prestadorInfo.categoria == widget.categoria)
        .toList();
    if (_query.trim().isEmpty) return daCategoria;
    final String q = _query.toLowerCase();
    return daCategoria
        .where((Prestador p) =>
            p.nome.toLowerCase().contains(q) ||
            p.cidadeBase.toLowerCase().contains(q) ||
            p.regiaoAtendimento.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.dark,
        elevation: 0,
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
              child: Icon(widget.icone, size: 18, color: AppColors.brand),
            ),
            const SizedBox(width: 10),
            Text(
              widget.categoria,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.dark,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _SearchField(
                controller: _searchCtrl,
                hint: 'Buscar em ${widget.categoria.toLowerCase()}...',
                onChanged: (String v) => setState(() => _query = v),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<Prestador>>(
                  stream: _repo.observarPrestadores(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Prestador>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.brand,
                        ),
                      );
                    }
                    final List<Prestador> resultados =
                        _filtrar(snapshot.data ?? const <Prestador>[]);
                    if (resultados.isEmpty) {
                      return _EmptyState(
                        categoria: widget.categoria,
                        hasQuery: _query.trim().isNotEmpty,
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: resultados.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.78,
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

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: AppColors.white),
      cursorColor: AppColors.brand,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, color: AppColors.white),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.categoria, required this.hasQuery});

  final String categoria;
  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.search_off,
              size: 56,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              hasQuery
                  ? 'Nenhum resultado para essa busca\nem $categoria.'
                  : 'Nenhum $categoria cadastrado ainda.\nVolte em breve!',
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
