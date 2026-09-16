import 'package:flutter/material.dart';

class AppColors {
  // ═══════════════════════════════════════════
  // MAIN THEME COLORS
  // ═══════════════════════════════════════════
  static const Color primaryPink = Color(0xFFE82A78);
  static const Color primaryPurple = Color(0xFF6B2A8A);
  static const Color darkBackground = Color(0xFF1B0B2E);

  // ═══════════════════════════════════════════
  // TEXT COLORS
  // ═══════════════════════════════════════════
  static const Color textWhite = Colors.white;
  static const Color textDark = Color(0xFF1F1F1F);
  static const Color textGrey = Color(0xFF777777);

  // ═══════════════════════════════════════════
  // INPUTS & CARDS
  // ═══════════════════════════════════════════
  static const Color inputFill = Color(0xFFF8F8FA);
  static const Color inputBorder = Color(0xFFE5E5EA);

  // ═══════════════════════════════════════════
  // STATUS COLORS
  // ═══════════════════════════════════════════
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF4CAF50);

  // ═══════════════════════════════════════════
  // BUTTON GRADIENT
  // ═══════════════════════════════════════════
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPink, primaryPurple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ═══════════════════════════════════════════
  // ADAPTIVE THEME HELPERS (Part 10)
  // Dark mode ke liye context-based colors
  // ═══════════════════════════════════════════

  /// Check if current theme is dark
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// Scaffold / Screen background
  static Color scaffoldBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF0D0D0D) : Colors.white;

  /// Card / Container background
  static Color cardBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF1C1C1E) : Colors.white;

  /// Input fields, icon circles, subtle fills
  static Color inputBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF2C2C2E) : inputFill;

  /// Primary text (headings, titles, names)
  static Color textPrimary(BuildContext context) =>
      isDark(context) ? Colors.white : textDark;

  /// Secondary text (subtitles, labels, hints)
  static Color textSecondary(BuildContext context) =>
      isDark(context) ? const Color(0xFFAAAAAA) : textGrey;

  /// Dividers & borders
  static Color divider(BuildContext context) =>
      isDark(context) ? const Color(0xFF2C2C2E) : inputBorder;

  /// Back button / icon circle background
  static Color iconCircleBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF2C2C2E) : inputFill;

  /// Bottom sheet / dialog background
  static Color sheetBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF1C1C1E) : Colors.white;

  /// Shimmer / placeholder base
  static Color shimmerBase(BuildContext context) =>
      isDark(context) ? const Color(0xFF2C2C2E) : const Color(0xFFE0E0E0);

  /// Shimmer highlight
  static Color shimmerHighlight(BuildContext context) =>
      isDark(context) ? const Color(0xFF3A3A3C) : const Color(0xFFF5F5F5);
}
