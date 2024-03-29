import 'package:flutter/material.dart';

class Styles {
  static const MaterialColor _primaryColor = Colors.deepPurple;
  static ThemeData getThemeData(bool isDarkTheme) {
    return isDarkTheme ? darkTheme : lightTheme;
  }

  static ThemeData lightTheme = ThemeData(
    primarySwatch: _primaryColor,
    primaryColor: _primaryColor,
    primaryTextTheme: TextTheme(
        headline6: TextStyle(
      color: _primaryColor,
    )),
    colorScheme: ColorScheme.light(
      primary: _primaryColor,
      secondary: _primaryColor,
      tertiary: Colors.grey[700],
      primaryContainer: Color.fromARGB(255, 226, 226, 226),
    ),
    primaryIconTheme: IconThemeData(color: _primaryColor),
    scaffoldBackgroundColor: Colors.grey[50],
    canvasColor: Colors.white,
    unselectedWidgetColor: Colors.grey[600],
    cardColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.grey[500]),
      hintStyle: TextStyle(color: Colors.grey[500]),
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
      bodyText2: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[800]),
      headline3: TextStyle(
          color: Colors.grey[900],
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8),
      headline4: TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
      headline5: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600),
      headline6: TextStyle(color: Colors.grey[700], fontSize: 14),
      subtitle1: TextStyle(color: Colors.grey[700]),
      subtitle2:
          TextStyle(color: Colors.grey[600], fontWeight: FontWeight.normal),
      overline:
          TextStyle(fontSize: 12.0, color: Colors.grey[600], letterSpacing: 1),
      caption: TextStyle(fontSize: 12, color: Colors.grey[600]),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      iconTheme: IconThemeData(color: _primaryColor),
      titleTextStyle: TextStyle(
        color: _primaryColor,
        fontSize: 18,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.grey[700]),
  );

  static ThemeData darkTheme = ThemeData(
    primarySwatch: _primaryColor,
    primaryColor: _primaryColor,
    colorScheme: ColorScheme.dark(
      secondary: _primaryColor,
      tertiary: Colors.grey[600],
      primaryContainer: Color.fromARGB(255, 48, 48, 48),
    ),
    primaryTextTheme: TextTheme(
        headline6: TextStyle(
      color: _primaryColor,
    )),
    dialogBackgroundColor: Colors.grey[900],
    primaryIconTheme: IconThemeData(color: _primaryColor),
    scaffoldBackgroundColor: Color(0xFF151515),
    cardColor: Colors.black,
    canvasColor: Colors.black,
    secondaryHeaderColor: Colors.grey[300],
    unselectedWidgetColor: Colors.grey[300],
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.grey[500]),
      hintStyle: TextStyle(color: Colors.grey[500]),
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      bodyText2: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[400]),
      headline3: TextStyle(
          color: Colors.grey[200],
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8),
      headline4: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      headline5: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600),
      headline6: TextStyle(color: Colors.grey[300], fontSize: 14),
      subtitle1: TextStyle(color: Colors.grey[300]),
      subtitle2:
          TextStyle(color: Colors.grey[350], fontWeight: FontWeight.normal),
      overline:
          TextStyle(fontSize: 12.0, color: Colors.grey[500], letterSpacing: 1),
      caption: TextStyle(fontSize: 12, color: Colors.grey[400]),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      iconTheme: IconThemeData(color: _primaryColor),
      titleTextStyle: TextStyle(
        color: _primaryColor,
        fontSize: 18,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.grey[300]),
  );
}
