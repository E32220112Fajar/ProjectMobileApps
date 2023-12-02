import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _changePassword(BuildContext context) async {
    String username = usernameController.text;
    String newPassword = newPasswordController.text;

    try {
      // Menggunakan reference untuk mengupdate password di Firestore
      DocumentReference registerReference =
          _firestore.collection('register').doc(username);
      DocumentReference forgotPasswordReference =
          _firestore.collection('forgotPassword').doc(username);

      // Mengecek apakah password di forgotPassword sudah ada
      DocumentSnapshot forgotPasswordSnapshot =
          await forgotPasswordReference.get();
      if (forgotPasswordSnapshot.exists) {
        // Jika sudah ada, perbarui password di register
        await registerReference.update({
          'password': newPassword,
        });
      } else {
        // Jika belum ada, tambahkan entri baru di koleksi "forgotPassword"
        await forgotPasswordReference.set({
          'username': username,
          'password': newPassword,
        });
      }

      // Menampilkan snackbar jika berhasil mengganti password
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password berhasil diubah'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Kembali ke halaman login setelah berhasil mengganti password
      Navigator.popUntil(context, ModalRoute.withName('/login'));
    } catch (e) {
      print('Error updating password: $e');

      // Menampilkan snackbar jika terjadi kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengganti password. Silakan coba lagi.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
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
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: usernameController,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xFF4CAF50),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: newPasswordController,
                        obscureText: true,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF4CAF50),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () {
                          _changePassword(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF4CAF50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(12.0),
                        ),
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Back to Login',
                          style: TextStyle(
                            color: Color(0xFF4CAF50),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
