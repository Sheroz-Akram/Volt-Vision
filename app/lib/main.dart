import 'dart:math';

import 'package:app/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void backgroundNotificationHandler(NotificationResponse response) {
  if (response.payload != null) {
    OpenFile.open(response.payload);
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Initialize the notification plugin in the background task
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // List of electricity tips
    List<String> electricityTips = [
      "Turn off lights when you leave a room.",
      "Unplug appliances when not in use.",
      "Use energy-efficient light bulbs.",
      "Wash clothes with cold water.",
      "Turn off your computer when not in use.",
    ];

    // Select a random tip
    final random = Random();
    String randomTip = electricityTips[random.nextInt(electricityTips.length)];

    // Show a notification
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'electricity_tips_channel', // channel ID
      'Electricity Tips', // channel name
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Electricity Tip', // Title
      randomTip, // Body
      notificationDetails,
    );

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        OpenFile.open(response.payload);
      }
    },
    onDidReceiveBackgroundNotificationResponse: backgroundNotificationHandler,
  );

  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  runApp(const MyApp());

  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..maskColor = Colors.black.withOpacity(0.5)
    ..dismissOnTap = false;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF121A21),
      statusBarIconBrightness: Brightness.light,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Volt Vision',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF121A21),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFFFFFFFF),
                backgroundColor: const Color(0xFF1A80E5))),
        appBarTheme: AppBarTheme(
            color: const Color(0xFF121A21),
            titleTextStyle: GoogleFonts.spaceGrotesk(
                color: const Color(0xFFBBBEC0),
                fontSize: 18,
                fontWeight: FontWeight.bold),
            iconTheme: const IconThemeData(color: Color(0xFFFFFFFF))),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: const Color(0xFF1A2632),
            unselectedItemColor: const Color(0xFF5D7185),
            unselectedLabelStyle: GoogleFonts.inter(),
            selectedItemColor: const Color(0xFF91979C),
            selectedLabelStyle: GoogleFonts.inter(),
            enableFeedback: false),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF233545),
          hintStyle: const TextStyle(color: Color(0xFF607489)),
          suffixIconColor: const Color(0xFF607489),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        splashColor: Colors.transparent,
        textTheme: TextTheme(
            bodyLarge: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFFFFF),
                fontSize: 24),
            bodyMedium: GoogleFonts.spaceGrotesk(
                color: const Color(0xFFFFFFFF),
                fontSize: 18,
                fontWeight: FontWeight.bold),
            bodySmall: GoogleFonts.spaceGrotesk(
                color: const Color(0xFFFFFFFF), fontSize: 15),
            labelSmall: GoogleFonts.inter(
                color: const Color(0xFF83898D),
                fontSize: 15,
                fontWeight: FontWeight.bold),
            labelMedium: GoogleFonts.spaceGrotesk(
                color: const Color(0xFF94ADC7), fontSize: 15)),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
      builder: EasyLoading.init(),
    );
  }
}
