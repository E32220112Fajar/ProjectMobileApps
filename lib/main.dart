import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login_screen.dart'; // Import file login_screen.dart
import 'menu_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/menu': (context) =>
            MenuScreen(), // Tambahkan route untuk halaman menu
      },
    );
  }
}
