import 'package:flutter/material.dart';

/// Central theme for MONDAY. Adjust the seed color to restyle the whole app.
class AppTheme {
  AppTheme._();

  static const Color upvoteColor = Color(0xFFFF6B35);
  static const Color downvoteColor = Color(0xFF5B7FDE);
  static const Color forgePointColor = Color(0xFFE8A33D);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E2E3A)),
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2E2E3A),
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
    );
  }
}
