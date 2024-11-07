import 'package:app/components/electricityUsage.dart';
import 'package:app/components/energyTips.dart';
import 'package:app/components/iconRow.dart';
import 'package:app/pages/capture/guide.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key, required this.onClick});
  final Function(int) onClick;
  @override
  State<StatefulWidget> createState() {
    return _DashBoardPage();
  }
}

class _DashBoardPage extends State<DashBoardPage> {
  ElectricityUsage electricityUsage = const ElectricityUsage();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "You're using 1.2x more electricity than last week",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          electricityUsage,
          IconRow(
            icon: Icons.camera_alt_outlined,
            title: "Scan Meter",
            onClick: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const GuidePage()));
              setState(() {
                electricityUsage = const ElectricityUsage();
              });
            },
          ),
          IconRow(
            icon: Icons.attach_money,
            title: "Pay Now",
            onClick: () async {
              await LaunchApp.openApp(
                androidPackageName: 'pk.com.telenor.phoenix',
              );
            },
          ),
          IconRow(
              icon: Icons.history_rounded,
              title: "View History",
              onClick: () {
                widget.onClick(2);
              }),
          IconRow(
              icon: Icons.settings_outlined,
              title: "Settings",
              onClick: () {
                widget.onClick(3);
              }),
          IconRow(
              icon: Icons.help_outline_outlined, title: "Help", onClick: () {}),
          const EnergyTips()
        ],
      ),
    );
  }
}
