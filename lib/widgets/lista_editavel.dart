import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Lista editável de itens com botão "+" para adicionar e "x" para
/// remover.
///
/// Cada item é exibido como um cartão com [itemTitle], [itemSubtitle]
/// opcional e ação de remoção. O botão "+" abre um diálogo (provido
/// pelo chamador via [onAddPressed]) que decide o que será adicionado.
///
/// Usado na tela de Configurações do prestador para gerenciar serviços
/// oferecidos e certificados.
class ListaEditavel<T> extends StatelessWidget {
  const ListaEditavel({
    super.key,
    required this.titulo,
    required this.itens,
    required this.itemTitle,
    required this.onAddPressed,
    required this.onRemove,
    this.itemSubtitle,
    this.onEdit,
    this.emptyHint,
    this.addLabel = 'Adicionar',
  });

  final String titulo;
  final List<T> itens;
  final String Function(T) itemTitle;
  final String Function(T)? itemSubtitle;
  final VoidCallback onAddPressed;
  final void Function(int index) onRemove;
  final void Function(int index)? onEdit;
  final String? emptyHint;
  final String addLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.dark,
              ),
            ),
            TextButton.icon(
              onPressed: onAddPressed,
              icon: const Icon(Icons.add, size: 18, color: AppColors.brand),
              label: Text(
                addLabel,
                style: const TextStyle(
                  color: AppColors.brand,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (itens.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              emptyHint ?? 'Nenhum item adicionado ainda.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
          )
        else
          ...List<Widget>.generate(itens.length, (int i) {
            final T item = itens[i];
            final String? sub = itemSubtitle?.call(item);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                title: Text(
                  itemTitle(item),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark,
                  ),
                ),
                subtitle: sub == null || sub.isEmpty
                    ? null
                    : Text(
                        sub,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (onEdit != null)
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                        onPressed: () => onEdit!(i),
                      ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.danger,
                        size: 20,
                      ),
                      onPressed: () => onRemove(i),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
