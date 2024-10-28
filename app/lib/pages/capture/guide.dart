import 'package:app/components/button.dart';
import 'package:app/pages/capture/scan.dart';
import 'package:flutter/material.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _GuidePage();
  }
}

class _GuidePage extends State<GuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Align meter to frame",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Image.asset("assets/images/sampleMeter.png")),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "How to take a good photo",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Make sure the photo is in focus",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: const Color(0xFFA7ADB1)),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  "The whole dial must be visible",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: const Color(0xFFA7ADB1)),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Hold your phone steady",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: const Color(0xFFA7ADB1)),
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Button(
            buttonText: "Scan",
            onButtonClick: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const ScanPage()));
            }),
      ),
    );
  }
}
