import 'package:app/components/graph.dart';
import 'package:flutter/material.dart';

class ElectricityUsage extends StatelessWidget {
  ElectricityUsage({super.key});

  final List<ElectricityData> chartData = [
    ElectricityData(DateTime(2023, 1), 35),
    ElectricityData(DateTime(2023, 2), 10),
    ElectricityData(DateTime(2023, 3), 34),
    ElectricityData(DateTime(2023, 4), 32),
    ElectricityData(DateTime(2023, 5), 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Electricity Consumption",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "1.2x",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Row(
                children: [
                  Text(
                    "Last Month",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: const Color(0xFF5C6B7B),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "+20%",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: const Color(0xFF156F3E),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        LineChart(
          chartData: chartData,
        ),
      ],
    );
  }
}
