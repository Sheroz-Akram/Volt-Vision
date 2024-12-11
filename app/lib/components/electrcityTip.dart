import 'package:flutter/material.dart';

class ElectrcityTip extends StatelessWidget {
  const ElectrcityTip(
      {super.key,
      required this.title,
      required this.description,
      required this.tipImage,
      required this.savings});
  final String title;
  final String description;
  final String tipImage;
  final String savings;
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
            width: MediaQuery.of(context).size.width * 0.55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: const Color(0xFF9EA2A5),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(description,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: const Color(0xFF667A8F), fontSize: 12)),
                const SizedBox(
                  height: 5.0,
                ),
                Text(savings,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: const Color(0xFF667A8F),
                        fontSize: 12,
                        fontWeight: FontWeight.w800))
              ],
            ),
          )
        ],
      ),
    );
  }
}
