import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
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
    _trackballBehavior = TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y'));

    _streamController = StreamController<List<ChartSampleData>>();
    Timer.periodic(Duration(seconds: 2), (timer) {
      addData(); // Adding new data to the chart
      _streamController.add(chartData); // Adding updated data to the stream
    });

    super.initState();
  }

  void addData() {
    DateTime now = DateTime.now();
    double yValue = _random.nextDouble() * 50; // Generating random value between 0 and 50
    chartData.add(ChartSampleData(x: now, yValue: yValue));
  }

  @override
  void dispose() {
    _streamController.close(); // Closing the stream when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChartSampleData>>(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return _buildDefaultDateTimeAxisChart(_trackballBehavior, snapshot.data!);
      },
    );
  }

  SfCartesianChart _buildDefaultDateTimeAxisChart(
      _trackballBehavior, List<ChartSampleData> data) {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: 'Real-time Data'),
        primaryXAxis: DateTimeAxis(majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 50, // Adjusted as per the new yValue range
          interval: 5,
          labelFormat: r'${value}',
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
        trackballBehavior: _trackballBehavior);
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
