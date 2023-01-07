import 'package:flutter/material.dart';

class Themes {
  static final darkTheme = ThemeData(
    dividerColor: Colors.white,
    fontFamily: 'Baloo',
    brightness: Brightness.dark,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.black.withOpacity(0.5),
        ),
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.grey[500]),
    ),
  );

  static final lightTheme = ThemeData(
    primaryColor: Colors.blue.shade300,
    dividerColor: Colors.black,
    fontFamily: 'Baloo',
    brightness: Brightness.light,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.grey.shade500,
        ),
      ),
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.grey[700]),
    ),
    scaffoldBackgroundColor: Colors.white.withOpacity(0.8),
  );
}

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;

  ThemeChanger(this._themeData);

  getTheme() => _themeData;

  enableDarkMode(bool isDark) {
    _themeData = isDark ? Themes.lightTheme : Themes.darkTheme;

    _themeData = ThemeData(
        primaryColor: !isDark ? Colors.black : Colors.blue.shade300,
        dividerColor: !isDark ? Colors.white : Colors.black,
        fontFamily: 'Baloo',
        brightness: !isDark ? Brightness.dark : Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              !isDark ? Colors.black.withOpacity(0.5) : Colors.grey.shade500,
            ),
          ),
        ),
        textTheme: TextTheme(
          bodyText1:
              TextStyle(color: !isDark ? Colors.grey[500] : Colors.grey[700]),
        ),
        appBarTheme: AppBarTheme(
            backgroundColor: !isDark ? Colors.grey[900] : Colors.grey[700]));
    notifyListeners();
  }
}
