import 'package:app/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        ),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}
