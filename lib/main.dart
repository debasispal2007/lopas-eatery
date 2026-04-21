import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'pages/cover_page.dart';
import 'pages/menu_page.dart';
import 'pages/checkout_page.dart';
import 'pages/admin_page.dart';
import 'pages/my_orders_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const LopasEateryApp(),
    ),
  );
}

class LopasEateryApp extends StatelessWidget {
  const LopasEateryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Lopa's Eatery",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB22222), // Terracotta
          primary: const Color(0xFF8F000D),
          secondary: const Color(0xFF715C00), // Mustard
          surface: const Color(0xFFFEFCCF), // Warm Cream
          surfaceContainer: const Color(0xFFF2F0C4),
          surfaceContainerLow: const Color(0xFFF8F6C9),
          outlineVariant: const Color(0xFFE2BEBA),
        ),
        scaffoldBackgroundColor: const Color(0xFFFEFCCF),
        textTheme: GoogleFonts.manropeTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.notoSerif(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D1D03),
          ),
          headlineMedium: GoogleFonts.notoSerif(
            textStyle: Theme.of(context).textTheme.headlineMedium,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D1D03),
          ),
          titleMedium: GoogleFonts.notoSerif(
            textStyle: Theme.of(context).textTheme.titleMedium,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D1D03),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB22222),
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.manrope(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CoverPage(),
        '/menu': (context) => const MenuPage(),
        '/checkout': (context) => const CheckoutPage(),
        '/admin': (context) => const AdminPage(),
        '/orders': (context) => const MyOrdersPage(),
      },
    );
  }
}
