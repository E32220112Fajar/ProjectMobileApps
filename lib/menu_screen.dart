import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
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
  late mqtt.MqttServerClient client;
  bool isLightOn = false;

  void toggleLight() {
    setState(() {
      isLightOn = !isLightOn;
    });
  }

  void connect() async {
    client = mqtt.MqttServerClient(
        '192.168.187.37', '1883'); // Ganti dengan alamat broker MQTT Anda

    client.port = 1883; // Port default MQTT

    client.logging(on: true); // Aktifkan logging untuk debug

    try {
      await client.connect('liztric',
          '123'); // Ganti dengan username dan password broker MQTT Anda
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus?.state == mqtt.MqttConnectionState.connected) {
      print('Connected to broker');
      client.subscribe('android_suhu', mqtt.MqttQos.atMostOnce);
      client.subscribe('android_kelembapan', mqtt.MqttQos.atMostOnce);

      client.updates?.listen((List<mqtt.MqttReceivedMessage> c) {
        final mqtt.MqttPublishMessage message = c[0].payload;
        final String payload = mqtt.MqttPublishPayload.bytesToStringAsString(
            message.payload.message);

        if (c[0].topic == 'suhu_topic') {
          print('Suhu: $payload');
          // Tambahkan logika untuk menangani data suhu di sini
        } else if (c[0].topic == 'kelembapan_topic') {
          print('Kelembapan: $payload');
          // Tambahkan logika untuk menangani data kelembapan di sini
        }
      });
    } else {
      print('Connection failed');
      client.disconnect();
    }
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  void dispose() {
    if (client != null) {
      client.disconnect();
    }
    super.dispose();
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
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
                '28°C',
              ),
              _buildSensorContainer(
                Icons.opacity,
                'Kelembapan',
                '70%',
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
                    isLightOn ? Icons.lightbulb : Icons.lightbulb_outline,
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
      ),
    );
  }
}
