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

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool showSensors = false;
  bool showControl = false;
  bool showMonitor = false;

  void toggleSensors() {
    setState(() {
      showSensors = !showSensors;
      showControl = false;
      showMonitor = false;
    });
  }

  void toggleControl() {
    setState(() {
      showSensors = false;
      showControl = !showControl;
      showMonitor = false;
    });
  }

  void toggleMonitor() {
    setState(() {
      showSensors = false;
      showControl = false;
      showMonitor = !showMonitor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(
            width: 220,
            height: 50,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 100.0),
                child: Image.asset(
                  'assets/image1.png',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: toggleSensors,
            child: Text('Tampilkan Monitoring Sensors'),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: toggleControl,
            child: Text('Tampilkan Control Buttons'),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: toggleMonitor,
            child: Text('Tampilkan Monitoring Laporan'),
          ),
          SizedBox(height: 20.0),
          if (showSensors)
            Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                'Monitoring Suhu, Kelembapan, dan Cahaya',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          if (showControl)
            Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                'Control Buttons (Otomatis/Manual)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          if (showMonitor)
            Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                'Monitoring Laporan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 48, 184, 53),
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {},
                color: Colors.white,
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {},
                color: Colors.white,
              ),
              IconButton(
                icon: Icon(Icons.monitor),
                onPressed: () {},
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
