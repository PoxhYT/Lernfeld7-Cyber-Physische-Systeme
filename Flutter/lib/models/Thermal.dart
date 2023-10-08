import 'package:cloud_firestore/cloud_firestore.dart';

class Thermal {
  final double temperature;
  final double humidity;
  final DateTime timestamp;

  Thermal(this.temperature, this.humidity, this.timestamp);
}
