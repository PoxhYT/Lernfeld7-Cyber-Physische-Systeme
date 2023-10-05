import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lf_07_cyber_physical_system/firebase_options.dart';
import 'package:fl_chart/fl_chart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Temperature and Humidity Chart')),
        body: ThermalChart(),
      ),
    );
  }
}

class ThermalData {
  final double temperature;
  final double humidity;
  final Timestamp timestamp;

  ThermalData(this.temperature, this.humidity, this.timestamp);
}

Future<List<ThermalData>> getThermalData() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('thermals').get();
  return snapshot.docs.map((doc) {
    return ThermalData(
      (doc['temperature'] as num).toDouble(),
      (doc['humidity'] as num).toDouble(),
      doc['timestamp'] as Timestamp,
    );
  }).toList();
}

class ThermalChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ThermalData>>(
      future: getThermalData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data found'));
        } else {
          List<ThermalData> data = snapshot.data!;

          List<BarChartGroupData> barGroups = data.map((thermalData) {
            int index = data.indexOf(thermalData);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: thermalData.temperature,
                  color: Colors.red,
                  width: 4,
                ),
                BarChartRodData(
                  toY: thermalData.humidity,
                  color: Colors.blue,
                  width: 4,
                ),
              ],
            );
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
              ),
            ),
          );
        }
      },
    );
  }
}
