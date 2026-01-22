import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  //static const _seed = Colors.blueAccent;
  static const _seed = Color(0xFF00F0FF);
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.orbitronTextTheme(
        ThemeData.light().textTheme,
      ), //GoogleFonts.orbitron, GoogleFonts.sourceCodePro
      colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.light),
    );
    return base.copyWith(
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: base.colorScheme.surfaceContainerHighest,
        indicatorColor: base.colorScheme.secondaryContainer,
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.orbitronTextTheme(
        ThemeData.dark().textTheme,
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark),
    );
    return base.copyWith(
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: base.colorScheme.surfaceContainerHighest,
        indicatorColor: base.colorScheme.secondaryContainer,
      ),
    );
  }

  // High contrast
  static ThemeData highContrastLight() {
    // 1. Skapa schemat först
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
      contrastLevel: 1.0, // Ökar kontrasten (Standard är 0.0). Kräver Flutter 3.22+
    );

    // 2. Använd vanliga ThemeData-konstruktorn
    final base = ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.orbitronTextTheme(
        ThemeData.light().textTheme,
      ),
      colorScheme: scheme,
    );

    return base.copyWith(
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: base.colorScheme.surfaceContainerHighest,
        indicatorColor: base.colorScheme.secondaryContainer,
      ),
    );
  }

  static ThemeData highContrastDark() {
    // 1. Skapa schemat först
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
      contrastLevel: 1.0, // Ökar kontrasten för accessibility
    );

    // 2. Använd vanliga ThemeData-konstruktorn
    final base = ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.orbitronTextTheme(
        ThemeData.dark().textTheme,
      ),
      colorScheme: scheme,
    );

    return base.copyWith(
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: base.colorScheme.surfaceContainerHighest,
        indicatorColor: base.colorScheme.secondaryContainer,
      ),
    );
  }
}