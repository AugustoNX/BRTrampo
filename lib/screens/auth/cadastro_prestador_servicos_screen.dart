import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../models/prestador_info.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_scaffold.dart';
import '../../widgets/primary_button.dart';

/// Etapa 2 do cadastro de **Prestador**: categoria, especificações,
/// tempo de experiência e região de atendimento.
class CadastroPrestadorServicosScreen extends StatefulWidget {
  const CadastroPrestadorServicosScreen({
    super.key,
    required this.nome,
    required this.telefone,
    required this.cidade,
    required this.email,
    required this.senha,
  });

  final String nome;
  final String telefone;
  final String cidade;
  final String email;
  final String senha;

  @override
  State<CadastroPrestadorServicosScreen> createState() =>
      _CadastroPrestadorServicosScreenState();
}

class _CadastroPrestadorServicosScreenState
    extends State<CadastroPrestadorServicosScreen> {
  static const List<String> _categorias = <String>[
    'Eletricista',
    'Carpinteiro',
    'Mecânico',
    'Pintor',
    'Piscineiro',
    'Encanador',
    'Marceneiro',
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _especificacoesCtrl = TextEditingController();
  final TextEditingController _tempoCtrl = TextEditingController();
  final TextEditingController _regiaoCtrl = TextEditingController();

  String? _categoriaSelecionada;
  bool _loading = false;
  String? _erro;

  @override
  void dispose() {
    _especificacoesCtrl.dispose();
    _tempoCtrl.dispose();
    _regiaoCtrl.dispose();
    super.dispose();
  }

  Future<void> _finalizarCadastro() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoriaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma categoria')),
      );
      return;
    }
    setState(() {
      _loading = true;
      _erro = null;
    });

    try {
      await context.read<AuthController>().cadastrarPrestador(
            nome: widget.nome,
            email: widget.email,
            senha: widget.senha,
            telefone: widget.telefone,
            cidadeBase: widget.cidade,
            regiaoAtendimento: _regiaoCtrl.text.trim(),
            info: PrestadorInfo(
              categoria: _categoriaSelecionada!,
              descricao: _especificacoesCtrl.text.trim(),
              tempoExperiencia: _tempoCtrl.text.trim(),
            ),
          );
      if (!mounted) return;
      Navigator.of(context).popUntil((Route<dynamic> r) => r.isFirst);
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _erro = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      appBarTitle: 'Criação de conta',
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 28,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Fale sobre seus serviços',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 24),
                _CategoriaDropdown(
                  categorias: _categorias,
                  value: _categoriaSelecionada,
                  onChanged: (String? v) =>
                      setState(() => _categoriaSelecionada = v),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  hint: 'Especificações do serviço',
                  controller: _especificacoesCtrl,
                  maxLines: 3,
                  validator: (String? v) => (v == null || v.trim().isEmpty)
                      ? 'Descreva seus serviços'
                      : null,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  hint: 'Tempo de experiência',
                  controller: _tempoCtrl,
                  validator: (String? v) => (v == null || v.trim().isEmpty)
                      ? 'Informe seu tempo de experiência'
                      : null,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  hint: 'Região de atendimento',
                  controller: _regiaoCtrl,
                  validator: (String? v) => (v == null || v.trim().isEmpty)
                      ? 'Informe a região atendida'
                      : null,
                ),
                if (_erro != null) ...<Widget>[
                  const SizedBox(height: 12),
                  Text(
                    _erro!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                PrimaryButton(
                  label: 'Concluir',
                  onPressed: _finalizarCadastro,
                  loading: _loading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoriaDropdown extends StatelessWidget {
  const _CategoriaDropdown({
    required this.categorias,
    required this.value,
    required this.onChanged,
  });

  final List<String> categorias;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      dropdownColor: AppColors.dark,
      iconEnabledColor: AppColors.white,
      style: const TextStyle(color: AppColors.white, fontSize: 15),
      decoration: const InputDecoration(hintText: 'Categoria do serviço'),
      items: <DropdownMenuItem<String>>[
        for (final String cat in categorias)
          DropdownMenuItem<String>(value: cat, child: Text(cat)),
      ],
      onChanged: onChanged,
    );
  }
}
