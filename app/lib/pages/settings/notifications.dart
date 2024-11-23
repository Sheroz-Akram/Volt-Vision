import 'package:app/utils/storage.dart';
import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});
  @override
  State<StatefulWidget> createState() {
    return _NotificationSettings();
  }
}

class _NotificationSettings extends State<NotificationSettings> {
  bool isNotificationAllowed = false;
  Storage storage = Storage();

  void loadSettings() async {
    bool isAllowed = await storage.loadAllowNotification() ?? true;
    setState(() {
      isNotificationAllowed = isAllowed;
    });
  }

  void updateSettings(bool value) async {
    await storage.storeAllowNotification(value);
    setState(() {
      isNotificationAllowed = value;
    });
  }

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Push Notifications"),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Allow Notification"),
                Switch(
                  value: isNotificationAllowed,
                  activeTrackColor: Colors.blue,
                  onChanged: (bool value) {
                    updateSettings(value);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
