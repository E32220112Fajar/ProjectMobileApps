import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Tambahkan logika atau delay jika diperlukan sebelum berpindah ke halaman login
    _navigateToLoginScreen();
  }

  void _navigateToLoginScreen() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedContainer(
          duration: Duration(seconds: 3),
          curve: Curves.easeInOut,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white, // Warna latar belakang splash screen
          child: Image.asset(
            'assets/image1.png',
            height: 150,
            width: 150,
          ),
        ),
      ),
    );
  }
}
