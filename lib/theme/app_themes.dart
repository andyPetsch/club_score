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
        selectedItemBackground: Colors.blue.withOpacity(0.2),
        selectedItemBorder: Colors.blue,
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
        selectedItemBackground: Colors.blue.withOpacity(0.2),
        selectedItemBorder: Colors.blue,
      ),
    ],
  );
}

// Erweiterung für billiard-spezifische Theme-Werte
class BilliardsThemeExtension extends ThemeExtension<BilliardsThemeExtension> {
  final Color scoreBackgroundColor;
  final Color playerCardColor;
  final Color selectedItemBackground;
  final Color selectedItemBorder;

  BilliardsThemeExtension({
    required this.scoreBackgroundColor,
    required this.playerCardColor,
    required this.selectedItemBackground,
    required this.selectedItemBorder,
  });

  @override
  ThemeExtension<BilliardsThemeExtension> copyWith({
    Color? scoreBackgroundColor,
    Color? playerCardColor,
    Color? selectedItemBackground,
    Color? selectedItemBorder,
  }) {
    return BilliardsThemeExtension(
      scoreBackgroundColor: scoreBackgroundColor ?? this.scoreBackgroundColor,
      playerCardColor: playerCardColor ?? this.playerCardColor,
      selectedItemBackground:
          selectedItemBackground ?? this.selectedItemBackground,
      selectedItemBorder: selectedItemBorder ?? this.selectedItemBorder,
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
      selectedItemBackground: Color.lerp(
        selectedItemBackground,
        other.selectedItemBackground,
        t,
      )!,
      selectedItemBorder: Color.lerp(
        selectedItemBorder,
        other.selectedItemBorder,
        t,
      )!,
    );
  }
}
