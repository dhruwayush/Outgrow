import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF65A37E); // Softer, more muted green
  static const Color primarySoft = Color(0xFFEEF7F2); // Very light green tint
  
  // Backgrounds
  static const Color backgroundLight = Color(0xFFFDFCF8); // Warm paper-like off-white
  
  static const Color backgroundDark = Color(0xFF16201A);
  
  // Text
  static const Color textMain = Color(0xFF2C3E34); // Softer black/green
  static const Color textMuted = Color(0xFF6B8C7A);
  
  // Cards
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1F2E26);
  
  static const Color warmBeige = Color(0xFFF4F1EA);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,

        surface: AppColors.cardLight,
        onSurface: AppColors.textMain,
        primary: AppColors.primary,
        onPrimary: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: _textTheme,
      fontFamily: GoogleFonts.manrope().fontFamily,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,

        surface: AppColors.cardDark,
        onSurface: Colors.white,
        primary: AppColors.primary,
        onPrimary: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: _textTheme,
      fontFamily: GoogleFonts.manrope().fontFamily,
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.merriweather(
        fontSize: 34,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        // color: AppColors.textMain, // Let theme handle color?
      ),
      displayMedium: GoogleFonts.merriweather(
        fontSize: 28,
        fontWeight: FontWeight.normal,
      ),
      headlineSmall: GoogleFonts.merriweather(
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: GoogleFonts.patrickHand( // For "handwritten" feel usually
        fontSize: 18,
      ),
    );
  }
}
