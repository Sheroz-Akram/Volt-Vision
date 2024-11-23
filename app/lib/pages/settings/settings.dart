import 'package:app/classes/user.dart';
import 'package:app/components/actionRow.dart';
import 'package:app/pages/account/profile.dart';
import 'package:app/pages/reading/about.dart';
import 'package:app/pages/reading/help.dart';
import 'package:app/pages/reading/privacy.dart';
import 'package:app/pages/reading/terms.dart';
import 'package:app/pages/settings/notifications.dart';
import 'package:app/pages/welcome.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsPage();
  }
}

class _SettingsPage extends State<SettingsPage> {
  final User user = User();
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
          ActionRow(
            title: "Profile",
            onClick: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
          ),
          ActionRow(
            title: "Logout",
            onClick: () async {
              user.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const WelcomePage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          Text(
            "Notifications",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          ActionRow(
            title: "Push Notifications",
            onClick: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationSettings()));
            },
          ),
          Text(
            "About",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          ActionRow(
            title: "Privacy Policy",
            onClick: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrivacyPolicy()));
            },
          ),
          ActionRow(
            title: "Terms of Service",
            onClick: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TermsService()));
            },
          ),
          ActionRow(
            title: "About Us",
            onClick: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const About()));
            },
          ),
          ActionRow(
            title: "Help Center",
            onClick: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Help()));
            },
          )
        ],
      ),
    );
  }
}
