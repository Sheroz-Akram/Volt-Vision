import 'package:app/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
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
            labelMedium: GoogleFonts.spaceGrotesk(
                color: const Color(0xFF94ADC7), fontSize: 15)),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}
