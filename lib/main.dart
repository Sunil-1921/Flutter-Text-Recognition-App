import 'package:flutter/material.dart';
import 'package:recogapp/src/pages/HomePage.dart';
import 'package:recogapp/src/theme/app_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final AppTheme app = AppTheme();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: app.theme,
      title: 'Material App',
      initialRoute: 'home',
      routes: {'home': (BuildContext context) => HomePage()},
    );
  }
}
