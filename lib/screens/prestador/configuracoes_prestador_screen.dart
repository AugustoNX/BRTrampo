import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../models/prestador.dart';
import '../../models/servico_oferecido.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/lista_editavel.dart';
import '../../widgets/primary_button.dart';

/// Tela de **Configurações do Prestador**.
///
/// Permite editar:
/// - Dados pessoais (nome, telefone, cidade, região de atendimento)
/// - Sobre seu trabalho (categoria, descrição, tempo de experiência)
/// - Lista de serviços oferecidos (criáveis livremente)
/// - Lista de certificados
///
/// Email/senha **não** são editáveis aqui — mudá-los requer um fluxo
/// dedicado de re-autenticação no Firebase Auth.
class ConfiguracoesPrestadorScreen extends StatefulWidget {
  const ConfiguracoesPrestadorScreen({super.key});

  @override
  State<ConfiguracoesPrestadorScreen> createState() =>
      _ConfiguracoesPrestadorScreenState();
}

class _ConfiguracoesPrestadorScreenState
    extends State<ConfiguracoesPrestadorScreen> {
  static const List<String> _categorias = <String>[
    'Eletricista',
    'Carpinteiro',
    'Mecânico',
    'Pintor',
    'Piscineiro',
    'Encanador',
    'Marceneiro',
    'Diarista',
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeCtrl;
  late final TextEditingController _telefoneCtrl;
  late final TextEditingController _cidadeCtrl;
  late final TextEditingController _regiaoCtrl;
  late final TextEditingController _descricaoCtrl;
  late final TextEditingController _tempoCtrl;

  late String _categoria;
  late List<ServicoOferecido> _servicos;
  late List<String> _certificados;

  bool _initialized = false;
  bool _salvando = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final Prestador? p = context.read<AuthController>().prestador;
    if (p == null) return;

    _nomeCtrl = TextEditingController(text: p.nome);
    _telefoneCtrl = TextEditingController(text: p.telefone);
    _cidadeCtrl = TextEditingController(text: p.cidadeBase);
    _regiaoCtrl = TextEditingController(text: p.regiaoAtendimento);
    _descricaoCtrl = TextEditingController(text: p.prestadorInfo.descricao);
    _tempoCtrl = TextEditingController(text: p.prestadorInfo.tempoExperiencia);

    _categoria = _categorias.contains(p.prestadorInfo.categoria)
        ? p.prestadorInfo.categoria
        : _categorias.first;
    _servicos = List<ServicoOferecido>.from(p.prestadorInfo.servicos);
    _certificados = List<String>.from(p.prestadorInfo.certificados);
    _initialized = true;
  }

  @override
  void dispose() {
    if (_initialized) {
      _nomeCtrl.dispose();
      _telefoneCtrl.dispose();
      _cidadeCtrl.dispose();
      _regiaoCtrl.dispose();
      _descricaoCtrl.dispose();
      _tempoCtrl.dispose();
    }
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    final AuthController auth = context.read<AuthController>();
    final Prestador? atual = auth.prestador;
    if (atual == null) return;

    setState(() => _salvando = true);
    try {
      final Prestador atualizado = atual.copyWith(
        nome: _nomeCtrl.text.trim(),
        telefone: _telefoneCtrl.text.trim(),
        cidadeBase: _cidadeCtrl.text.trim(),
        regiaoAtendimento: _regiaoCtrl.text.trim(),
        prestadorInfo: atual.prestadorInfo.copyWith(
          categoria: _categoria,
          descricao: _descricaoCtrl.text.trim(),
          tempoExperiencia: _tempoCtrl.text.trim(),
          servicos: _servicos,
          certificados: _certificados,
        ),
      );
      await auth.atualizarPrestador(atualizado);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alterações salvas com sucesso!'),
          backgroundColor: AppColors.brand,
        ),
      );
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  // ----- diálogos -----
  //
  // Os formulários dos diálogos vivem em [_ServicoDialog] e
  // [_CertificadoDialog] (StatefulWidgets) para que os
  // TextEditingController sejam descartados no `dispose()` natural do
  // widget — e não no `whenComplete` do Future, que dispara enquanto a
  // animação de saída do Dialog ainda referencia os TextField (causando
  // o erro "dependents.isEmpty is not true").

  Future<void> _adicionarServico() async {
    final ServicoOferecido? novo = await showDialog<ServicoOferecido>(
      context: context,
      builder: (_) => const _ServicoDialog(),
    );
    if (novo != null && mounted) setState(() => _servicos.add(novo));
  }

  Future<void> _editarServicoExistente(int i) async {
    final ServicoOferecido? editado = await showDialog<ServicoOferecido>(
      context: context,
      builder: (_) => _ServicoDialog(inicial: _servicos[i]),
    );
    if (editado != null && mounted) {
      setState(() => _servicos[i] = editado);
    }
  }

  Future<void> _adicionarCertificado() async {
    final String? novo = await showDialog<String>(
      context: context,
      builder: (_) => const _CertificadoDialog(),
    );
    if (novo != null && mounted) setState(() => _certificados.add(novo));
  }

  // ----- build -----

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const AppHeader(),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
            children: <Widget>[
              const _PageTitle('Configurações'),
              const SizedBox(height: 16),
              const _SectionHeader(
                icon: Icons.person_outline,
                titulo: 'Dados pessoais',
              ),
              _FormField(
                label: 'Nome completo',
                child: AppTextField(
                  hint: 'Seu nome',
                  controller: _nomeCtrl,
                  validator: (String? v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Informe seu nome'
                          : null,
                ),
              ),
              _FormField(
                label: 'Telefone (WhatsApp)',
                child: AppTextField(
                  hint: 'Ex: 5544999990000',
                  controller: _telefoneCtrl,
                  keyboardType: TextInputType.phone,
                  validator: (String? v) =>
                      (v == null || v.trim().length < 8)
                          ? 'Telefone inválido'
                          : null,
                ),
              ),
              _FormField(
                label: 'Cidade base',
                child: AppTextField(
                  hint: 'Onde você atua',
                  controller: _cidadeCtrl,
                  validator: (String? v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Informe a cidade'
                          : null,
                ),
              ),
              _FormField(
                label: 'Região de atendimento',
                child: AppTextField(
                  hint: 'Bairros e regiões cobertos',
                  controller: _regiaoCtrl,
                  validator: (String? v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Informe a região'
                          : null,
                ),
              ),
              const SizedBox(height: 24),
              const _SectionHeader(
                icon: Icons.work_outline,
                titulo: 'Sobre seu trabalho',
              ),
              _FormField(
                label: 'Categoria principal',
                child: _CategoriaDropdown(
                  categorias: _categorias,
                  value: _categoria,
                  onChanged: (String? v) {
                    if (v != null) setState(() => _categoria = v);
                  },
                ),
              ),
              _FormField(
                label: 'Descrição / biografia',
                child: AppTextField(
                  hint: 'Conte sobre sua experiência e diferenciais',
                  controller: _descricaoCtrl,
                  maxLines: 4,
                  validator: (String? v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Escreva uma breve descrição'
                          : null,
                ),
              ),
              _FormField(
                label: 'Tempo de experiência',
                child: AppTextField(
                  hint: 'Ex: 5 anos de experiência',
                  controller: _tempoCtrl,
                  validator: (String? v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Informe o tempo de experiência'
                          : null,
                ),
              ),
              const SizedBox(height: 24),
              const _SectionHeader(
                icon: Icons.handyman_outlined,
                titulo: 'Serviços oferecidos',
              ),
              const _SectionSubtitle(
                'Liste os serviços específicos que você oferece. '
                'Por exemplo, um eletricista pode oferecer "Instalação '
                'de tomada", "Troca de disjuntor", "Passagem de fios".',
              ),
              const SizedBox(height: 12),
              ListaEditavel<ServicoOferecido>(
                titulo: 'Meus serviços',
                itens: _servicos,
                itemTitle: (ServicoOferecido s) => s.nome,
                itemSubtitle: (ServicoOferecido s) => s.descricao,
                onAddPressed: _adicionarServico,
                onEdit: _editarServicoExistente,
                onRemove: (int i) => setState(() => _servicos.removeAt(i)),
                emptyHint:
                    'Você ainda não cadastrou nenhum serviço.\nClique em "Adicionar".',
                addLabel: 'Novo serviço',
              ),
              const SizedBox(height: 24),
              const _SectionHeader(
                icon: Icons.workspace_premium_outlined,
                titulo: 'Certificados',
              ),
              const _SectionSubtitle(
                'Cursos, qualificações e certificações que comprovem '
                'sua experiência. (Upload de arquivos em breve.)',
              ),
              const SizedBox(height: 12),
              ListaEditavel<String>(
                titulo: 'Meus certificados',
                itens: _certificados,
                itemTitle: (String s) => s,
                onAddPressed: _adicionarCertificado,
                onRemove: (int i) =>
                    setState(() => _certificados.removeAt(i)),
                emptyHint: 'Nenhum certificado cadastrado.',
                addLabel: 'Novo certificado',
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Salvar alterações',
                onPressed: _salvar,
                loading: _salvando,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----- helpers visuais privados -----

class _PageTitle extends StatelessWidget {
  const _PageTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppColors.dark,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.titulo});
  final IconData icon;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.brand.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppColors.brand),
          ),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.dark,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionSubtitle extends StatelessWidget {
  const _SectionSubtitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ),
          child,
        ],
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
  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      dropdownColor: AppColors.dark,
      iconEnabledColor: AppColors.white,
      style: const TextStyle(color: AppColors.white, fontSize: 15),
      decoration: const InputDecoration(hintText: 'Categoria'),
      items: <DropdownMenuItem<String>>[
        for (final String c in categorias)
          DropdownMenuItem<String>(value: c, child: Text(c)),
      ],
      onChanged: onChanged,
    );
  }
}

// ----- Diálogos auxiliares -----

/// Diálogo para criar/editar um [ServicoOferecido].
///
/// Stateful para que os [TextEditingController] sejam descartados no
/// próprio `dispose()` (após a animação de saída do dialog), evitando
/// o erro `dependents.isEmpty is not true`.
class _ServicoDialog extends StatefulWidget {
  const _ServicoDialog({this.inicial});
  final ServicoOferecido? inicial;

  @override
  State<_ServicoDialog> createState() => _ServicoDialogState();
}

class _ServicoDialogState extends State<_ServicoDialog> {
  late final TextEditingController _nomeCtrl =
      TextEditingController(text: widget.inicial?.nome ?? '');
  late final TextEditingController _descCtrl =
      TextEditingController(text: widget.inicial?.descricao ?? '');

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    final String nome = _nomeCtrl.text.trim();
    if (nome.isEmpty) return;
    Navigator.of(context).pop(
      ServicoOferecido(nome: nome, descricao: _descCtrl.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              widget.inicial == null ? 'Novo serviço' : 'Editar serviço',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              hint: 'Nome do serviço (ex: Instalação de tomada)',
              controller: _nomeCtrl,
            ),
            const SizedBox(height: 10),
            AppTextField(
              hint: 'Descrição (opcional)',
              controller: _descCtrl,
              maxLines: 3,
            ),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(label: 'Salvar', onPressed: _salvar),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Diálogo para adicionar um novo certificado (apenas texto por ora).
class _CertificadoDialog extends StatefulWidget {
  const _CertificadoDialog();

  @override
  State<_CertificadoDialog> createState() => _CertificadoDialogState();
}

class _CertificadoDialogState extends State<_CertificadoDialog> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _adicionar() {
    final String t = _ctrl.text.trim();
    if (t.isEmpty) return;
    Navigator.of(context).pop(t);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Novo certificado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Adicione o nome do curso/certificação. Upload de\n'
              'arquivo será adicionado em breve.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            AppTextField(
              hint: 'Ex: NR-10 Básico, Senai 2023',
              controller: _ctrl,
            ),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(
                    label: 'Adicionar',
                    onPressed: _adicionar,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
