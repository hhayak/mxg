import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  primarySwatch: Colors.teal,
  accentColor: Colors.teal,
  fontFamily: 'Roboto',
  inputDecorationTheme: inputDecorationTheme,
  buttonColor: Colors.teal,
  elevatedButtonTheme: elevatedButtonTheme,
  outlinedButtonTheme: outlinedButtonTheme,
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black87,
  primarySwatch: Colors.teal,
  accentColor: Colors.teal,
  fontFamily: 'Roboto',
  inputDecorationTheme: inputDecorationTheme,
  buttonColor: Colors.teal,
  elevatedButtonTheme: elevatedButtonTheme,
  outlinedButtonTheme: outlinedButtonTheme,
);

final inputDecorationTheme = InputDecorationTheme(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
  isDense: true,
);

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    minimumSize: Size(100, 40),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  ),
);

final outlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    minimumSize: Size(100, 40),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  ),
);
