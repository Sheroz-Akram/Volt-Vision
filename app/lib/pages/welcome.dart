import 'package:app/components/button.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  @override
  State<WelcomePage> createState() {
    return _WelcomePage();
  }
}

class _WelcomePage extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Image.asset("assets/images/welcomeHeader.png"),
          Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text("Take control of your energy use.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge),
                Text(
                  "Get insights into your energy usage and save on your bill.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ],
            ),
          ),
          const Button(
            buttonText: "Get Started",
          )
        ],
      )),
    );
  }
}
