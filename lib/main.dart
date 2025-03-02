// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/game_controller.dart';
import 'screens/game_screen.dart';
import 'theme/theme_provider.dart';
import 'theme/app_themes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameController()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Club Score - Die Scoreboard App für Poolvereine',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: GameScreen(),
          );
        },
      ),
    );
  }
}
