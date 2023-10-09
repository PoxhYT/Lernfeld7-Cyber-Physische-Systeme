import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lf_07_cyber_physical_system/models/Thermal.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  TrackballBehavior? _trackballBehavior;
  List<ChartSampleData> chartData = [];
  late StreamController<List<ChartSampleData>> _streamController;
  final _random = Random();

  @override
  void initState() {
    late final FirebaseMessaging _firebaseMessaging;
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      print("FCM Token: $token");
    });

    _trackballBehavior = TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y'));

    _streamController = StreamController<List<ChartSampleData>>();

    super.initState();
  }

  @override
  void dispose() {
    _streamController.close(); // Closing the stream when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            SizedBox(height: 70),
            Text("Temperatur"),
            StreamBuilder<List<ChartSampleData>>(
              stream: getTemperatureData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
      
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
      
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data found'));
                }
      
                return buildTemperatureChart(_trackballBehavior!, snapshot.data!);
              },
            ),
            SizedBox(height: 50),
            Text("Luftfeuchtigkeit"),
            StreamBuilder<List<ChartSampleData>>(
              stream: getHumidityData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
      
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
      
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data found'));
                }
      
                return buildHumidityChart(_trackballBehavior!, snapshot.data!);
              },
            )
          ],
        ),
      );
  }

  SfCartesianChart buildTemperatureChart(
      TrackballBehavior _trackballBehavior, List<ChartSampleData> data) {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
          isVisible: false, // Added to hide the x-axis
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 50,
          interval: 5,
          labelFormat: r'{value} °C',
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
        ),
        series: <LineSeries<ChartSampleData, DateTime>>[
          LineSeries<ChartSampleData, DateTime>(
            dataSource: data,
            xValueMapper: (ChartSampleData data, _) => data.x,
            yValueMapper: (ChartSampleData data, _) => data.yValue,
            color: const Color.fromRGBO(242, 117, 7, 1),
          )
        ],
        trackballBehavior: TrackballBehavior(
          // Enable trackball
          enable: true,
          lineType: TrackballLineType.vertical,
          activationMode: ActivationMode.singleTap,
          tooltipSettings: InteractiveTooltip(format: 'point.x : point.y'),
          builder: (BuildContext context, TrackballDetails trackballDetails) {
            final DateTime date = trackballDetails.point!.x as DateTime;
            final double value = trackballDetails.point!.y as double;
            final String formattedDate =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(date); // Updated
            final String formattedValue = value.toStringAsFixed(2); // Updated
            return Container(
              height: 50,
              width: 200, // Adjusted the width to fit the full date and time
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  '$formattedDate | $formattedValue °C', // Updated
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ));
  }

  SfCartesianChart buildHumidityChart(
      TrackballBehavior _trackballBehavior, List<ChartSampleData> data) {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
          isVisible: false, // Added to hide the x-axis
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 50,
          interval: 5,
          labelFormat: r'{value} %',
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
        ),
        series: <LineSeries<ChartSampleData, DateTime>>[
          LineSeries<ChartSampleData, DateTime>(
            dataSource: data,
            xValueMapper: (ChartSampleData data, _) => data.x,
            yValueMapper: (ChartSampleData data, _) => data.yValue,
            color: const Color.fromRGBO(242, 117, 7, 1),
          )
        ],
        trackballBehavior: TrackballBehavior(
          // Enable trackball
          enable: true,
          lineType: TrackballLineType.vertical,
          activationMode: ActivationMode.singleTap,
          tooltipSettings: InteractiveTooltip(format: 'point.x : point.y'),
          builder: (BuildContext context, TrackballDetails trackballDetails) {
            final DateTime date = trackballDetails.point!.x as DateTime;
            final double value = trackballDetails.point!.y as double;
            final String formattedDate =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(date); // Updated
            final String formattedValue = value.toStringAsFixed(2); // Updated
            return Container(
              height: 50,
              width: 200, // Adjusted the width to fit the full date and time
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  '$formattedDate | $formattedValue %', // Updated
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ));
  }

  Stream<List<ChartSampleData>> getTemperatureData() {
    return FirebaseFirestore.instance
        .collection('thermals')
        .orderBy('timestamp',
            descending:
                false) // This line is added to sort the documents by timestamp
        .snapshots()
        .map((snapshot) {
      List<QueryDocumentSnapshot> sortedDocs = snapshot.docs;

      return sortedDocs.map((document) {
        Timestamp timestamp = document['timestamp'];
        DateTime dateTime = timestamp.toDate();
        print(dateTime);

        return ChartSampleData(
          x: dateTime,
          yValue: document['temperature'].toDouble(),
        );
      }).toList();
    });
  }

  Stream<List<ChartSampleData>> getHumidityData() {
    return FirebaseFirestore.instance
        .collection('thermals')
        .orderBy('timestamp',
            descending:
                false) // This line is added to sort the documents by timestamp
        .snapshots()
        .map((snapshot) {
      List<QueryDocumentSnapshot> sortedDocs = snapshot.docs;

      return sortedDocs.map((document) {
        Timestamp timestamp = document['timestamp'];
        DateTime dateTime = timestamp.toDate();
        print(dateTime);

        return ChartSampleData(
          x: dateTime,
          yValue: document['humidity'].toDouble(),
        );
      }).toList();
    });
  }
}

class ChartSampleData {
  ChartSampleData({
    required this.x,
    required this.yValue,
  });

  final DateTime x;
  final double yValue;
}
