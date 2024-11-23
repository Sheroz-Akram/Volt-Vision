import 'package:app/components/button.dart';
import 'package:app/pages/account/login.dart';
import 'package:app/pages/dashboard/home.dart';
import 'package:app/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  @override
  State<WelcomePage> createState() {
    return _WelcomePage();
  }
}

class _WelcomePage extends State<WelcomePage> {
  void checkLoginStatus() async {
    Storage storage = Storage();
    String? token = await storage.loadToken();
    bool isNotificationAllowed = await storage.loadAllowNotification() ?? true;
    if (isNotificationAllowed) {
      Workmanager().registerPeriodicTask(
        "1", // Unique task ID
        "showRandomTip", // Task name
        frequency: const Duration(minutes: 15), // Frequency
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );
    } else {
      Workmanager().cancelByUniqueName("1");
    }
    if (token != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

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
                ),
                Button(
                  buttonText: "Get Started",
                  onButtonClick: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
