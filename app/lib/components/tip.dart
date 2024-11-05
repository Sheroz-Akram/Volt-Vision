import 'package:flutter/material.dart';

class Tip extends StatelessWidget {
  const Tip(
      {super.key,
      required this.title,
      required this.description,
      required this.tipImage,
      required this.tipNo,
      required this.totalTips});
  final String title;
  final String description;
  final String tipImage;
  final int tipNo;
  final int totalTips;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            tipImage,
            width: MediaQuery.of(context).size.width * 0.20,
          ),
          const SizedBox(
            width: 10.0,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: const Color(0xFF9EA2A5)),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text("Tip $tipNo of $totalTips",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: const Color(0xFF586A7D))),
                const SizedBox(
                  height: 10.0,
                ),
                Text(description,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: const Color(0xFF667A8F)))
              ],
            ),
          )
        ],
      ),
    );
  }
}
