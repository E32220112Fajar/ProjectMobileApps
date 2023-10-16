import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _handleLogout(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100,
        title: Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 1)),
            Image.asset(
              "assets/image1.png",
              width: 135,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Color(0xFF4CAF50),
            ),
            onPressed: () {
              _handleLogout(context);
            },
          ),
        ],
        leading: IconButton(
          padding: EdgeInsets.only(right: 55),
          icon: Icon(
            Icons.menu,
            color: Color(0xFF4CAF50),
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF4CAF50),
                image: DecorationImage(
                  image: AssetImage(
                    'assets/bg_4.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              subtitle: Text('Deskripsi Home'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              subtitle: Text('Deskripsi Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/bg_6.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(5.0),
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 16.0,
                children: <Widget>[
                  buildSensorCard('Sensor Suhu', Icons.wb_sunny, '24°C'),
                  buildSensorCard('Sensor Kelembapan', Icons.opacity, '70%'),
                  buildGraphCard(),
                  buildControlButton('Aktifkan Otomatis'),
                  buildControlButton('Aktifkan Manual'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSensorCard(String title, IconData icon, String value) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 60,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGraphCard() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.show_chart,
              size: 60,
            ),
            SizedBox(height: 10),
            Text(
              'Grafik Sensor',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildControlButton(String title) {
    return ElevatedButton(
      onPressed: () {
        // Tambahkan logika kontrol di sini
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xff4CAF50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(12.0),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
