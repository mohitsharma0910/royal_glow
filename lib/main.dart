import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'services/database_service.dart';
import 'providers/app_provider.dart';
import 'providers/service_provider.dart';
import 'providers/booking_provider.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()..loadData()),
        ChangeNotifierProvider(create: (_) => BookingProvider()..loadBookings()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Royal Glow Salon & Spa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4A843),
          secondary: Color(0xFFE8C35A),
          surface: Color(0xFF2A1406),
          onPrimary: Colors.black,
          onSurface: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF160700),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF0E0300),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.playfairDisplay(
            color: const Color(0xFFD4A843),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
          iconTheme: const IconThemeData(color: Color(0xFFD4A843)),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF2A1406),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4A843),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2A1406),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD4A843), width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: const Color(0xFFD4A843).withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFD4A843)),
          ),
          labelStyle: const TextStyle(color: Color(0xFFD4A843)),
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF0E0300),
          selectedItemColor: Color(0xFFD4A843),
          unselectedItemColor: Colors.white30,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF2A1406),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF2A1406),
          contentTextStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: const Color(0xFFD4A843)),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF2A1406),
          selectedColor: const Color(0xFFD4A843),
          labelStyle: const TextStyle(color: Colors.white),
          side: BorderSide(color: const Color(0xFFD4A843).withOpacity(0.4)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}