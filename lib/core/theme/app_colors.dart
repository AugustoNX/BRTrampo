import 'package:flutter/material.dart';

/// Paleta de cores oficial do BRTrampo.
///
/// Mantém os tokens de cor centralizados, facilitando manutenção e
/// garantindo aderência ao design system definido no protótipo.
abstract final class AppColors {
  /// Cinza escuro usado em botões, inputs, navbar e fundos secundários.
  static const Color dark = Color(0xFF1F1F1F);

  /// Variação levemente mais clara do [dark] para superfícies elevadas.
  static const Color darkSoft = Color(0xFF2A2A2A);

  /// Laranja de identidade visual (brand, ícones de destaque, estrelas).
  static const Color brand = Color(0xFFF97316);

  /// Branco puro usado em cards e telas de cadastro.
  static const Color white = Color(0xFFFFFFFF);

  /// Branco com 70% de opacidade — placeholders sobre fundo escuro.
  static const Color white70 = Color(0xB3FFFFFF);

  /// Cinza claro de fundo geral das telas.
  static const Color background = Color(0xFFF5F5F5);

  /// Cinza neutro para bordas e divisórias suaves.
  static const Color border = Color(0xFFE5E5E5);

  /// Cinza médio para textos secundários.
  static const Color textMuted = Color(0xFF6B7280);

  /// Vermelho de erro/alerta.
  static const Color danger = Color(0xFFDC2626);
}
