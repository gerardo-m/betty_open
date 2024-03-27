import 'package:flutter/material.dart';

class BettyTheme {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF5E44D3),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE5DEFF),
    onPrimaryContainer: Color(0xFF1A0063),
    secondary: Color(0xFFA800A9),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFD7F5),
    onSecondaryContainer: Color(0xFF380038),
    tertiary: Color(0xFF6750A4),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFE9DDFF),
    onTertiaryContainer: Color(0xFF23005C),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFF6FEFF),
    onBackground: Color(0xFF001F24),
    surface: Color(0xFFE1E5E5),
    onSurface: Color(0xFF001F24),
    surfaceVariant: Color(0xFFE5E0EC),
    onSurfaceVariant: Color(0xFF48454E),
    outline: Color(0xFF79757F),
    onInverseSurface: Color(0xFFD0F8FF),
    inverseSurface: Color(0xFF00363D),
    inversePrimary: Color(0xFFC9BFFF),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF5E44D3),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFC9BFFF),
    onPrimary: Color(0xFF2E009C),
    primaryContainer: Color(0xFF4526BB),
    onPrimaryContainer: Color(0xFFE5DEFF),
    secondary: Color(0xFFFFAAF4),
    onSecondary: Color(0xFF5B005B),
    secondaryContainer: Color(0xFF810081),
    onSecondaryContainer: Color(0xFFFFD7F5),
    tertiary: Color(0xFFD0BCFF),
    onTertiary: Color(0xFF381E72),
    tertiaryContainer: Color(0xFF4F378A),
    onTertiaryContainer: Color(0xFFE9DDFF),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF001F24),
    onBackground: Color(0xFF97F0FF),
    surface: Color(0xFF001F24),
    onSurface: Color(0xFF97F0FF),
    surfaceVariant: Color(0xFF48454E),
    onSurfaceVariant: Color(0xFFC9C5D0),
    outline: Color(0xFF938F99),
    onInverseSurface: Color(0xFF001F24),
    inverseSurface: Color(0xFF97F0FF),
    inversePrimary: Color(0xFF5E44D3),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFC9BFFF),
  );
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: lightColorScheme,
      cardTheme: CardTheme(
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        color: lightColorScheme.tertiaryContainer,
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: MaterialStateProperty.all(lightColorScheme.secondaryContainer),
        headingTextStyle: TextStyle(
          color: lightColorScheme.onSecondaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: darkColorScheme,
    );
  }
}
