import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart' as mqtt;

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
  final DatabaseReference _databaseReference =
      FirebaseDatabase().reference().child('farmsmart').child('kelembapan');

  String _lembapValue = "";

  late mqtt.MqttServerClient client;
  bool isLightOn = false;

  void toggleLight() {
    setState(() {
      isLightOn = !isLightOn;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Future<String> fetchData() async {
    try {
      DatabaseEvent eventlembap = await _databaseReference.once();
      if (eventlembap.snapshot.value != null) {
        return eventlembap.snapshot.value.toString();
      }
      return "";
    } catch (e) {
      return "";
    }
  }

  Widget _buildSensorContainer(IconData icon, String label, String value) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 50,
            color: Color(0xFF4CAF50),
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            ); // Menampilkan indikator loading jika sedang menunggu data
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              return ListView(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Image.asset(
                        'assets/image1.png',
                        fit: BoxFit.contain,
                        width: 180,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSensorContainer(
                        Icons.thermostat_outlined,
                        'Suhu',
                        '${snapshot.data}',
                      ),
                      _buildSensorContainer(
                        Icons.opacity,
                        'Kelembapan',
                        '${snapshot.data}',
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: ElevatedButton(
                      onPressed: toggleLight,
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isLightOn
                                ? Icons.lightbulb
                                : Icons.lightbulb_outline,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            isLightOn ? 'Matikan Lampu' : 'Nyalakan Lampu',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text('Data tidak ditemukan'),
              );
            }
          }
        },
      ),
    );
  }
}
