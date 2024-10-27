import 'package:app/components/actionRow.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsPage();
  }
}

class _SettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const ActionRow(title: "Profile"),
          Text(
            "Notifications",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const ActionRow(
            title: "Push Notifications",
          ),
          Text(
            "About",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const ActionRow(
            title: "Privacy Policy",
          ),
          const ActionRow(
            title: "Terms of Service",
          ),
          const ActionRow(
            title: "Help Center",
          )
        ],
      ),
    );
  }
}
