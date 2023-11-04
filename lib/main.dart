import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login_screen.dart'; // Import file login_screen.dart
import 'menu_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  var messagingSenderId;
  var firebaseApp = await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyAYx5QY9K2wnnHAfhUGoNEHEKjDXpGlEFQ",
        appId: "255221761620",
        messagingSenderId: messagingSenderId,
        projectId: "farmsmartmobile"),
  );
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
