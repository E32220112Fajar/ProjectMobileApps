import 'package:flutter/material.dart';
import 'registrasi_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _navigateToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  void _handleLogin(BuildContext context) {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username == 'admin' && password == '123') {
      print('Login berhasil');
      Navigator.pushNamed(context, '/menu');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outline_outlined,
                color: Colors.white,
              ),
              SizedBox(width: 8.0),
              Text(
                'Username atau password salah. Silahkan coba lagi',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          elevation: 6.0,
          behavior: SnackBarBehavior.fixed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_5.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/image1.png',
                        height: 100,
                      ),
                      SizedBox(height: 24.0),
                      TextFormField(
                        controller: usernameController,
                        style:
                            TextStyle(color: Colors.black87), // Ubah warna teks
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xFF4CAF50), // Ubah warna ikon
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        style:
                            TextStyle(color: Colors.black87), // Ubah warna teks
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF4CAF50), // Ubah warna ikon
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () {
                          _handleLogin(context); // Panggil fungsi _handleLogin
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF4CAF50), // Ubah warna tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(12.0),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Ubah warna teks
                          ),
                        ),
                      ),
                      //SizedBox(height: 12.0),
                      //TextButton(
                      //onPressed: () {
                      // Implementasi logika lupa sandi di sini
                      //},
                      //child: Text(
                      //'Lupa Sandi?',
                      //style: TextStyle(
                      //color: Color(0xFF4CAF50)), // Ubah warna teks
                      //),
                      //),
                      //SizedBox(height: 12.0),
                      //TextButton(
                      //onPressed: () {
                      //_navigateToRegister(context);
                      //},
                      //child: Text(
                      //'Daftar Sekarang',
                      //style: TextStyle(
                      //color: Color(0xFF4CAF50),
                      //fontWeight: FontWeight.bold,
                      //),
                      //),
                      //),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
