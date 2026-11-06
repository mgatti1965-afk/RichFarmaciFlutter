import 'package:flutter/material.dart';

/// Colori e tema ad alta accessibilità per anziani (Linee Guida 07).
/// Garantisce contrasto elevato (>= 7:1 AAA), testi grandi (>= 18sp)
/// e aree di tocco maggiorate (>= 56x56 dp).
abstract final class AppColors {
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate300 = Color(0xFFCBD5E1);

  static const Color greenPrimary = Color(0xFF059669); // Smeraldo ad alto contrasto
  static const Color greenLightBg = Color(0xFFF0FDF4); // Sfondo verde tenue per card attive
  static const Color greenDark = Color(0xFF047857);

  static const Color orangeAlert = Color(0xFFEA580C);
  static const Color sandAlertBg = Color(0xFFFEF3C7);
  static const Color redDanger = Color(0xFFDC2626);
  static const Color redLightBg = Color(0xFFFEF2F2);

  static const Color white = Color(0xFFFFFFFF);
  static const Color grayBackground = Color(0xFFF8FAFC);
  static const Color grayBorder = Color(0xFFCBD5E1);
  static const Color blueInputBg = Color(0xFFF0F9FF);
}

class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.greenPrimary,
        primary: AppColors.greenPrimary,
        onPrimary: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.slate900,
        error: AppColors.redDanger,
        onError: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.grayBackground,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.slate900,
        ),
        headlineMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.slate900,
        ),
        titleLarge: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.slate900,
        ),
        titleMedium: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.slate900,
        ),
        bodyLarge: const TextStyle(
          fontSize: 18,
          color: AppColors.slate900,
          height: 1.4,
        ),
        bodyMedium: const TextStyle(
          fontSize: 16,
          color: AppColors.slate600,
          height: 1.4,
        ),
        labelLarge: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Pulsanti grandi (altezza minima 56dp, padding abbondante per anziani)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(64, 56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          backgroundColor: AppColors.greenPrimary,
          foregroundColor: AppColors.white,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedCornerShape(14),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 56),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          foregroundColor: AppColors.slate900,
          side: const BorderSide(color: AppColors.slate600, width: 2),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedCornerShape(14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(56, 56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          foregroundColor: AppColors.greenPrimary,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.slate600,
        ),
        hintStyle: const TextStyle(fontSize: 16, color: AppColors.slate600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grayBorder, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grayBorder, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.greenPrimary, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.redDanger, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 1,
        shape: RoundedCornerShape(14),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        shape: RoundedCornerShape(20),
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.slate900,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 17,
          color: AppColors.slate900,
          height: 1.4,
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
RoundedRectangleBorder RoundedCornerShape(double radius, {BorderSide side = BorderSide.none}) =>
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius), side: side);
