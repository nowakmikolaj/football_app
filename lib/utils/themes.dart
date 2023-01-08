import 'package:flutter/material.dart';

class Themes {
  static final darkTheme = ThemeData(
    primaryColor: Colors.black,
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
      bodyText1: TextStyle(color: Colors.grey[500]),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
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
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[700],
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
    ),
  );
}

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;

  ThemeChanger(this._themeData);

  getTheme() => _themeData;

  enableDarkMode(bool isDark) {
    _themeData = isDark ? Themes.lightTheme : Themes.darkTheme;
    notifyListeners();
  }
}
