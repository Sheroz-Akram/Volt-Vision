import 'package:app/components/iconRow.dart';
import 'package:flutter/material.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _DashBoardPage();
  }
}

class _DashBoardPage extends State<DashBoardPage> {
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
          IconRow(
            icon: Icons.camera_alt_outlined,
            title: "Scan Meter",
            onClick: () {},
          ),
          IconRow(
              icon: Icons.history_rounded,
              title: "View History",
              onClick: () {}),
          IconRow(
              icon: Icons.settings_outlined, title: "Settings", onClick: () {}),
          IconRow(
              icon: Icons.help_outline_outlined, title: "Help", onClick: () {}),
        ],
      ),
    );
  }
}
