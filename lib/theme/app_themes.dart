// lib/theme/app_themes.dart
import 'package:flutter/material.dart';

class AppThemes {
  // Farben für Light Mode
  static final Color lightBackground = Colors.grey[100]!;
  static final Color lightSurface = Colors.white;
  static final Color lightText = Colors.black87;
  static final Color lightScoreBackground = Colors.grey[200]!;

  // Farben für Dark Mode
  static final Color darkBackground = Color(0xFF121212);
  static final Color darkSurface = Color(0xFF1E1E1E);
  static final Color darkText = Colors.white;
  static final Color darkScoreBackground = Color(0xFF2C2C2C);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: lightSurface,
      filled: true,
    ),
    cardTheme: CardTheme(
      color: lightSurface,
      shadowColor: Colors.black26,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: lightText),
      bodyMedium: TextStyle(color: lightText),
    ),
    extensions: [
      BilliardsThemeExtension(
        scoreBackgroundColor: lightScoreBackground,
        playerCardColor: lightSurface,
      ),
    ],
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: darkText,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: darkSurface,
      filled: true,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
    ),
    cardTheme: CardTheme(
      color: darkSurface,
      shadowColor: Colors.black54,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: darkText),
      bodyMedium: TextStyle(color: Colors.grey[300]!),
    ),
    extensions: [
      BilliardsThemeExtension(
        scoreBackgroundColor: darkScoreBackground,
        playerCardColor: darkSurface,
      ),
    ],
  );
}

// Erweiterung für billiard-spezifische Theme-Werte
class BilliardsThemeExtension extends ThemeExtension<BilliardsThemeExtension> {
  final Color scoreBackgroundColor;
  final Color playerCardColor;

  BilliardsThemeExtension({
    required this.scoreBackgroundColor,
    required this.playerCardColor,
  });

  @override
  ThemeExtension<BilliardsThemeExtension> copyWith({
    Color? scoreBackgroundColor,
    Color? playerCardColor,
  }) {
    return BilliardsThemeExtension(
      scoreBackgroundColor: scoreBackgroundColor ?? this.scoreBackgroundColor,
      playerCardColor: playerCardColor ?? this.playerCardColor,
    );
  }

  @override
  ThemeExtension<BilliardsThemeExtension> lerp(
    ThemeExtension<BilliardsThemeExtension>? other,
    double t,
  ) {
    if (other is! BilliardsThemeExtension) {
      return this;
    }
    return BilliardsThemeExtension(
      scoreBackgroundColor: Color.lerp(
        scoreBackgroundColor,
        other.scoreBackgroundColor,
        t,
      )!,
      playerCardColor: Color.lerp(
        playerCardColor,
        other.playerCardColor,
        t,
      )!,
    );
  }
}
