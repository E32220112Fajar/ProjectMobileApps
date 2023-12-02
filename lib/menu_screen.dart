import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

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

class TemperatureMonitor extends StatelessWidget {
  final dynamic value;
  final IconData icon;
  final String label;

  TemperatureMonitor({
    required this.value,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    Color boxColor = Colors.green;

    if (label == 'Suhu') {
      if (value is double) {
        boxColor = _getBoxColor(value);
      }
    }

    return Container(
      width: 150,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
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
            color: boxColor,
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 5),
          Text(
            '$value${label == 'Suhu' ? '°C' : ''}',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Color _getBoxColor(double temperature) {
    if (temperature >= 30.0) {
      return Colors.red;
    } else if (temperature >= 15.0 && temperature < 30.0) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }
}

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final DatabaseReference _kelembapanReference =
      FirebaseDatabase().reference().child('farmsmart').child('kelembapan');

  final DatabaseReference _suhuReference =
      FirebaseDatabase().reference().child('farmsmart').child('suhu');

  final DatabaseReference _lampuReference =
      FirebaseDatabase().reference().child('farmsmart').child('lampu');

  final DatabaseReference _kipasReference =
      FirebaseDatabase().reference().child('farmsmart').child('kipas');

  late DatabaseReference _dbref;
  bool isButtonPressedLED = false;

  String _lembapValue = "";
  String _suhuValue = "";
  String _lampuValue = "OFF";
  String _kipasValue = "OFF";

  late StreamController<String> _kelembapanStreamController;
  late StreamController<String> _suhuStreamController;
  late StreamController<String> _lampuStreamController;
  late StreamController<String> _kipasStreamController;

  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance.ref();
    _kelembapanStreamController = StreamController<String>();
    _suhuStreamController = StreamController<String>();
    _lampuStreamController = StreamController<String>();
    _kipasStreamController = StreamController<String>();
    _setupKelembapanStream();
    _setupSuhuStream();
    _setupLampuStream();
    _setupKipasStream();
  }

  void _setupKelembapanStream() {
    _kelembapanReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        _lembapValue = event.snapshot.value.toString();
        _kelembapanStreamController.add(_lembapValue);
      }
    });
  }

  void _setupSuhuStream() {
    _suhuReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        _suhuValue = event.snapshot.value.toString();
        _suhuStreamController.add(_suhuValue);

        double suhu = double.parse(_suhuValue);

        if (suhu > 30.0) {
          _kipasReference.set("ON");
        } else {
          _kipasReference.set("OFF");
        }

        if (suhu < 15.0) {
          _lampuReference.set("ON");
        } else {
          _lampuReference.set("OFF");
        }
      }
    });
  }

  void _setupLampuStream() {
    _lampuReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        _lampuValue = event.snapshot.value.toString();
        _lampuStreamController.add(_lampuValue);
      }
    });
  }

  void _setupKipasStream() {
    _kipasReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        _kipasValue = event.snapshot.value.toString();
        _kipasStreamController.add(_kipasValue);
      }
    });
  }

  double _getSwitchValue(String device) {
    switch (device) {
      case 'Lampu':
      case 'Kipas':
        return _getSwitchStatus(device) == 'ON' ? 1.0 : 0.0;
      default:
        return 0.0;
    }
  }

  String _getSwitchStatus(String device) {
    switch (device) {
      case 'Lampu':
        return _lampuValue;
      case 'Kipas':
        return _kipasValue;
      default:
        return 'OFF';
    }
  }

  void ledOn() async {
    await _dbref.child('farmsmart').update({'LED': 'ON'});
  }

  void ledOff() async {
    await _dbref.child('farmsmart').update({'LED': 'OFF'});
  }

  void pressedButtonLED() {
    setState(() {
      isButtonPressedLED = !isButtonPressedLED;
      if (isButtonPressedLED) {
        ledOn();
      } else {
        ledOff();
      }
    });
  }

  void logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 33, 150, 243), Colors.green],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        left: 0,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(150),
              bottomRight: Radius.circular(150),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    User? user = snapshot.data;
                    if (user != null) {
                      return Text(
                        'Selamat datang, ${user.displayName}!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      );
                    }
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
      StreamBuilder<String>(
        stream: _kelembapanStreamController.stream,
        builder:
            (BuildContext context, AsyncSnapshot<String> kelembapanSnapshot) {
          if (kelembapanSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (kelembapanSnapshot.hasError) {
            return Center(
              child: Text('Error: ${kelembapanSnapshot.error}'),
            );
          } else {
            return StreamBuilder<String>(
              stream: _suhuStreamController.stream,
              builder:
                  (BuildContext context, AsyncSnapshot<String> suhuSnapshot) {
                if (suhuSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (suhuSnapshot.hasError) {
                  return Center(
                    child: Text('Error: ${suhuSnapshot.error}'),
                  );
                } else {
                  return StreamBuilder<String>(
                    stream: _lampuStreamController.stream,
                    builder: (BuildContext context,
                        AsyncSnapshot<String> lampuSnapshot) {
                      if (lampuSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (lampuSnapshot.hasError) {
                        return Center(
                          child: Text('Error: ${lampuSnapshot.error}'),
                        );
                      } else {
                        return StreamBuilder<String>(
                          stream: _kipasStreamController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<String> kipasSnapshot) {
                            if (kipasSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (kipasSnapshot.hasError) {
                              return Center(
                                child: Text('Error: ${kipasSnapshot.error}'),
                              );
                            } else {
                              return ListView(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 10),
                                      child: Image.asset(
                                        'assets/image1.png',
                                        fit: BoxFit.contain,
                                        width: 180,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          TemperatureMonitor(
                                            icon: Icons.thermostat_outlined,
                                            label: 'Suhu',
                                            value: double.parse(
                                                suhuSnapshot.data ?? '0'),
                                          ),
                                          TemperatureMonitor(
                                            icon: Icons.opacity,
                                            label: 'Kelembapan',
                                            value: double.parse(
                                                kelembapanSnapshot.data ?? '0'),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          TemperatureMonitor(
                                            icon: Icons.lightbulb_outline,
                                            label: 'Lampu',
                                            value: _lampuValue,
                                          ),
                                          TemperatureMonitor(
                                            icon: Icons.air,
                                            label: 'Kipas',
                                            value: _kipasValue,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: pressedButtonLED,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      height: 180,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        border: Border.all(
                                          color: isButtonPressedLED
                                              ? Colors.grey.shade100
                                              : Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: isButtonPressedLED
                                            ? [
                                                const BoxShadow(
                                                    color: Color.fromARGB(
                                                        255, 255, 252, 48),
                                                    offset: Offset(1, 1),
                                                    blurRadius: 1,
                                                    spreadRadius: 1)
                                              ]
                                            : [
                                                const BoxShadow(
                                                    color: Color.fromARGB(
                                                        255, 68, 68, 68),
                                                    offset: Offset(3, 3),
                                                    blurRadius: 5,
                                                    spreadRadius: 1)
                                              ],
                                      ),
                                      child: Image.asset(
                                        isButtonPressedLED
                                            ? "assets/istockphoto-1279683132-170667a.jpg"
                                            : "assets/istockphoto-1172727463-612x612.jpg",
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      logOut();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 10,
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        vertical: 2,
                                      ),
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      shadowColor: const Color.fromARGB(
                                          255, 142, 142, 142),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.logout_sharp,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        );
                      }
                    },
                  );
                }
              },
            );
          }
        },
      ),
    ]));
  }
}
