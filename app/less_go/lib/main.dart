import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const SensorPosterApp());
}

class SensorPosterApp extends StatelessWidget {
  const SensorPosterApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SensorPosterPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SensorPosterPage extends StatefulWidget {
  const SensorPosterPage({super.key});
  @override
  State<SensorPosterPage> createState() => _SensorPosterPageState();
}

class _SensorPosterPageState extends State<SensorPosterPage> {
  Map<String, double> accelerometer = {'x': 0, 'y': 0, 'z': 0};
  Map<String, double> gyroscope = {'x': 0, 'y': 0, 'z': 0};
  double? compassHeading;
  Position? currentPosition;

  StreamSubscription<AccelerometerEvent>? _accSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;
  StreamSubscription<CompassEvent>? _compassSub;
  StreamSubscription<Position>? _posSub;

  String endpoint = "";
  final TextEditingController _endpointController = TextEditingController();

  bool sending = false;
  String lastSendResult = 'Never sent';
  Timer? _sendTimer;

  final List<Map<String, dynamic>> _dataBuffer = [];

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await _loadEndpoint();
    await _requestPermissions();
    _startSensorListeners();
    _startSendTimer();
  }

  Future<void> _loadEndpoint() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('endpoint') ?? "";
    setState(() {
      endpoint = saved;
      _endpointController.text = saved;
    });
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.locationWhenInUse,
      Permission.sensors,
    ].request();
  }

  void _startSensorListeners() {
    _accSub = accelerometerEvents.listen((event) {
      accelerometer = {'x': event.x, 'y': event.y, 'z': event.z};
      _addToBuffer();
    });

    _gyroSub = gyroscopeEvents.listen((event) {
      gyroscope = {'x': event.x, 'y': event.y, 'z': event.z};
    });

    _compassSub = FlutterCompass.events?.listen((event) {
      compassHeading = event.heading;
    });

    _posSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((pos) {
      currentPosition = pos;
    });
  }

  void _addToBuffer() {
    final timestamp = DateTime.now().toIso8601String();
    final entry = {
      'timestamp': timestamp,
      'accelerometer': accelerometer,
      'gyroscope': gyroscope,
      'compass': compassHeading ?? 0.0,
      'gps': currentPosition != null
          ? {'lat': currentPosition!.latitude, 'lon': currentPosition!.longitude}
          : null,
    };
    _dataBuffer.add(entry);
  }

  void _startSendTimer() {
    _sendTimer?.cancel();
    // Send every 200ms (5 times per second)
    _sendTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      _postBufferedData();
    });
  }

  Future<void> _postBufferedData() async {
    if (_dataBuffer.isEmpty || endpoint.isEmpty) return;
    final payload = jsonEncode({'data': List.from(_dataBuffer)});
    _dataBuffer.clear();

    try {
      final res = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );
      if (res.statusCode == 200) {
        setState(() => lastSendResult = "Sent ${DateTime.now()}");
      }
    } catch (e) {
      debugPrint('Send error: $e');
    }
  }

  @override
  void dispose() {
    _accSub?.cancel();
    _gyroSub?.cancel();
    _compassSub?.cancel();
    _posSub?.cancel();
    _sendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team McQueen Sensor Streamer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _endpointController,
              decoration: const InputDecoration(labelText: 'Server Endpoint'),
              onSubmitted: (value) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('endpoint', value);
                setState(() => endpoint = value);
              },
            ),
            const SizedBox(height: 20),
            Text('Accelerometer: $accelerometer'),
            Text('Gyroscope: $gyroscope'),
            Text('Compass: ${compassHeading?.toStringAsFixed(2) ?? "N/A"}°'),
            Text('GPS: ${currentPosition != null ? "${currentPosition!.latitude}, ${currentPosition!.longitude}" : "N/A"}'),
            const SizedBox(height: 20),
            Text('Last Send: $lastSendResult'),
          ],
        ),
      ),
    );
  }
}
