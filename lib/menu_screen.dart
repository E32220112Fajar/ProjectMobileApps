import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

class SuhuDisplay extends StatefulWidget {
  const SuhuDisplay({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SuhuDisplay> createState() => _SuhuDisplayState();
}

class _SuhuDisplayState extends State<SuhuDisplay> {
  late DatabaseReference _dbref;
  String databasejson = '';
  var newAge;

  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance.ref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildText('Age is $databasejson'),
            buildText('New Age is: $newAge'),
            StreamBuilder(
              stream: _dbref.onValue,
              builder: (context, AsyncSnapshot snap) {
                if (snap.hasData &&
                    !snap.hasError &&
                    snap.data.snapshot.value != null) {
                  Map data = snap.data.snapshot.value;
                  List item = [];
                  data.forEach(
                      (index, data) => item.add({"key": index, ...data}));
                  return Expanded(
                    child: ListView.builder(
                      itemCount: item.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text("Customer: ${item[index]['key']}"),
                          subtitle:
                              Text('Age: ${item[index]['age'].toString()}'),
                          isThreeLine: true,
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text("No data"));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Text buildText(String s) {
    return Text(
      s,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void ageChange() {
    _dbref
        .child('customer1')
        .child('age')
        .onValue
        .listen((DatabaseEvent event) {
      Object? data = event.snapshot.value;
      print('weight data: $data');
      setState(() {
        newAge = data;
      });
    });
  }
}

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool isLightOn = false;

  void toggleLight() {
    setState(() {
      isLightOn = !isLightOn;
    });
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
                '9°C',
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
