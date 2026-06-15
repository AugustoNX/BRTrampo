import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../models/endereco.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_scaffold.dart';
import '../../widgets/primary_button.dart';

/// Etapa 2 do cadastro de **Cliente**: dados de endereço (CEP, Cidade,
/// Rua, Número).
///
/// O endereço é privado e usado apenas para cálculo de distância na UI.
class CadastroClienteEnderecoScreen extends StatefulWidget {
  const CadastroClienteEnderecoScreen({
    super.key,
    required this.nome,
    required this.email,
    required this.senha,
  });

  final String nome;
  final String email;
  final String senha;

  @override
  State<CadastroClienteEnderecoScreen> createState() =>
      _CadastroClienteEnderecoScreenState();
}

class _CadastroClienteEnderecoScreenState
    extends State<CadastroClienteEnderecoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cepCtrl = TextEditingController();
  final TextEditingController _cidadeCtrl = TextEditingController();
  final TextEditingController _ruaCtrl = TextEditingController();
  final TextEditingController _numeroCtrl = TextEditingController();

  bool _loading = false;
  String? _erro;

  @override
  void dispose() {
    _cepCtrl.dispose();
    _cidadeCtrl.dispose();
    _ruaCtrl.dispose();
    _numeroCtrl.dispose();
    super.dispose();
  }

  Future<void> _finalizarCadastro() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _erro = null;
    });

    try {
      await context.read<AuthController>().cadastrarCliente(
            nome: widget.nome,
            email: widget.email,
            senha: widget.senha,
            telefone: '',
            endereco: Endereco(
              cep: _cepCtrl.text.trim(),
              cidade: _cidadeCtrl.text.trim(),
              rua: _ruaCtrl.text.trim(),
              numero: _numeroCtrl.text.trim(),
            ),
          );
      // O AuthWrapper detectará a mudança de status e levará à Home.
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
      appBarTitle: 'criar conta - Usuário',
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
                  'Crie sua conta',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 24),
                AppTextField(
                  hint: 'CEP',
                  controller: _cepCtrl,
                  keyboardType: TextInputType.number,
                  validator: (String? v) =>
                      (v == null || v.trim().length < 8)
                          ? 'CEP inválido'
                          : null,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  hint: 'Cidade',
                  controller: _cidadeCtrl,
                  validator: (String? v) => (v == null || v.trim().isEmpty)
                      ? 'Informe a cidade'
                      : null,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  hint: 'Rua',
                  controller: _ruaCtrl,
                  validator: (String? v) => (v == null || v.trim().isEmpty)
                      ? 'Informe a rua'
                      : null,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  hint: 'Número',
                  controller: _numeroCtrl,
                  keyboardType: TextInputType.number,
                  validator: (String? v) => (v == null || v.trim().isEmpty)
                      ? 'Informe o número'
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
