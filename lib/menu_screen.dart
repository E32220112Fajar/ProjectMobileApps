import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang seluruh halaman
      body: Column(
        children: <Widget>[
          SizedBox(
            width: 285, // Sesuaikan ukuran sesuai kebutuhan
            height: 65, // Sesuaikan ukuran sesuai kebutuhan
            child: Align(
              alignment: Alignment.centerLeft, // Atur posisi gambar
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 115.0), // Geser sebelah kiri sejauh 30 pixel
                child: Image.asset(
                  'assets/image1.png',
                  fit: BoxFit.contain, // Memastikan gambar menyesuaikan ukuran
                  width: double.infinity, // Lebar gambar mengisi seluruh layar
                  height:
                      double.infinity, // Tinggi gambar mengisi seluruh layar
                  // Ganti dengan path logo Anda
                ),
              ),
            ),
          ),
          // Tambahkan elemen atau widget lain di sini
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 48, 184, 53), // Warna latar belakang App Bar
        child: Container(
          height: 50.0, // Tinggi App Bar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  // Tambahkan logika untuk tombol Home di sini
                },
                color: Colors.white,
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  // Tambahkan logika untuk tombol Settings di sini
                },
                color: Colors.white,
              ),
              IconButton(
                icon: Icon(Icons.monitor),
                onPressed: () {
                  // Tambahkan logika untuk tombol Settings di sini
                },
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
