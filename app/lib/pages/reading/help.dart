import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  const Help({super.key});
  @override
  State<StatefulWidget> createState() {
    return _Help();
  }
}

class _Help extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Help",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                Text.rich(
                    textAlign: TextAlign.justify,
                    TextSpan(
                        style: TextStyle(fontSize: 18),
                        text:
                            "Encountering an issue with the Volt Vision app? Don’t worry—we’re here to help! First, try troubleshooting by ensuring your camera is properly aligned with the meter, the lighting is adequate, and your app is updated to the latest version. If the issue persists, restart the app or your device and try again. For further assistance, feel free to contact us at ",
                        children: [
                          TextSpan(
                              text: "help.voltvision@gmail.com",
                              style: TextStyle(color: Colors.blue)),
                          TextSpan(
                              text:
                                  "with a description of the problem, any error codes or screenshots, and your device details. We’ll get back to you promptly to ensure a smooth experience!")
                        ])),
                SizedBox(
                  height: 20,
                ),
              ]),
        ),
      ),
    );
  }
}
