import 'package:flutter/material.dart';

class AppTheme {
  static const Color bg = Color(0xFF071E26);
  static const Color surface = Color(0xFF0E2D38);
  static const Color accent = Color(0xFF22D3A6);
  static const Color cta = Color(0xFF35F2B5);

  static ThemeData darkTeal() {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: accent,
        secondary: cta,
      ),
      cardTheme: CardTheme(
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cta,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
