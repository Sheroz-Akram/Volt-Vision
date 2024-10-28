import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, required this.percentage});
  final double percentage;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Progress"),
                Text(
                  "${(percentage * 100).floor()}%",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: const Color(0xFF767B7F),
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            LinearPercentIndicator(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              animation: true,
              lineHeight: 10.0,
              barRadius: const Radius.circular(10.0),
              animationDuration: 500,
              percent: percentage,
              animateFromLastPercent: true,
              progressColor: const Color(0xFF187FE5),
              backgroundColor: const Color(0xFF344D65),
            ),
          ],
        ));
  }
}
