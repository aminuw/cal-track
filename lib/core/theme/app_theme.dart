import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs "Dark Gym"
  static const Color background = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF1E1E1E);
  
  // Accents
  static const Color neonOrange = Color(0xFFFF4500); 
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color proteinColor = Color(0xFF00E5FF); // Cyan pour les prots
  static const Color carbsColor = neonOrange;
  static const Color fatColor = Color(0xFFFFD700); // Or pour les lipides

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: neonOrange,
      // fontFamily: 'Inter', // Si tu as ajouté la police dans pubspec.yaml
      colorScheme: const ColorScheme.dark(
        primary: neonOrange,
        secondary: neonGreen,
        surface: surfaceColor,
        background: background,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
    );
  }
}
