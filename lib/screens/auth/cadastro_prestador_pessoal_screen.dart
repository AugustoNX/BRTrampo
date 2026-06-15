import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_scaffold.dart';
import '../../widgets/primary_button.dart';
import 'cadastro_prestador_servicos_screen.dart';

/// Etapa 1 do cadastro de **Prestador**: nome, telefone, cidade e e-mail.
class CadastroPrestadorPessoalScreen extends StatefulWidget {
  const CadastroPrestadorPessoalScreen({super.key});

  @override
  State<CadastroPrestadorPessoalScreen> createState() =>
      _CadastroPrestadorPessoalScreenState();
}

class _CadastroPrestadorPessoalScreenState
    extends State<CadastroPrestadorPessoalScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeCtrl = TextEditingController();
  final TextEditingController _telefoneCtrl = TextEditingController();
  final TextEditingController _cidadeCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _senhaCtrl = TextEditingController();

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _telefoneCtrl.dispose();
    _cidadeCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  void _onProximo() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CadastroPrestadorServicosScreen(
          nome: _nomeCtrl.text.trim(),
          telefone: _telefoneCtrl.text.trim(),
          cidade: _cidadeCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          senha: _senhaCtrl.text,
        ),
      ),
    );
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
                  'Fale sobre você',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 24),
                AppTextField(
                  hint: 'Nome',
                  controller: _nomeCtrl,
                  validator: (String? v) => (v == null || v.trim().isEmpty)
                      ? 'Informe seu nome'
                      : null,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  hint: 'Telefone',
                  controller: _telefoneCtrl,
                  keyboardType: TextInputType.phone,
                  validator: (String? v) =>
                      (v == null || v.trim().length < 8)
                          ? 'Telefone inválido'
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
                  hint: 'Email',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Informe seu e-mail';
                    }
                    if (!v.contains('@')) return 'E-mail inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AppTextField(
                  hint: 'Senha',
                  icon: Icons.lock_outline,
                  controller: _senhaCtrl,
                  obscureText: true,
                  validator: (String? v) => (v == null || v.length < 6)
                      ? 'Mínimo de 6 caracteres'
                      : null,
                ),
                const SizedBox(height: 22),
                PrimaryButton(label: 'Próximo', onPressed: _onProximo),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
