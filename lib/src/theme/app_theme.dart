import 'package:flutter/material.dart';

class AppTheme {
  get theme => ThemeData(
        primaryColor: Colors.blueAccent,
        primaryIconTheme: IconThemeData(
          color: Colors.white,
        ),
        primaryTextTheme: TextTheme(
            headline6:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Colors.blueAccent[600],
          ),
        ),
      );
}
