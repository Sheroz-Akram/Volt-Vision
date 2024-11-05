import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ElectricityData {
  ElectricityData(this.month, this.units);
  final DateTime month;
  final double units;
}

class LineChart extends StatelessWidget {
  final List<ElectricityData> chartData;
  const LineChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      borderWidth: 5,
      primaryXAxis: DateTimeAxis(
          labelStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          dateFormat: DateFormat.MMM(),
          majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: const NumericAxis(
        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        majorGridLines: MajorGridLines(width: 0),
        axisLine: AxisLine(color: Colors.blueGrey, width: 2),
      ),
      series: <CartesianSeries>[
        LineSeries<ElectricityData, DateTime>(
          dataSource: chartData,
          xValueMapper: (ElectricityData data, _) => data.month,
          yValueMapper: (ElectricityData data, _) => data.units,
          width: 4,
          color: Colors.white,
        )
      ],
    );
  }
}
