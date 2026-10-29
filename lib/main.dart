import 'package:ever_salon/Customer%20Panel/provider/my%20booking/my_booking_provider.dart';
import 'package:ever_salon/Customer%20Panel/provider/profile/language_provider.dart';
import 'package:ever_salon/Customer%20Panel/provider/profile/theme_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/auth/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MyBookingsProvider()..fetchBookings(),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EverSalon',
      themeMode: themeProvider.themeMode,
      locale: Locale(langProvider.selectedCode),
      supportedLocales: const [
        Locale('en'),
        Locale('ur'),
        Locale('ar'),
        Locale('hi'),
        Locale('bn'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ─── LIGHT THEME ───
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFE82A78),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFE82A78),
          secondary: Color(0xFF6B2A8A),
          surface: Colors.white,
          onSurface: Color(0xFF1F1F1F),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1F1F1F),
          elevation: 0,
        ),
        dividerColor: const Color(0xFFE5E5EA),
      ),

      // ─── DARK THEME ───
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        primaryColor: const Color(0xFFE82A78),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE82A78),
          secondary: Color(0xFF6B2A8A),
          surface: Color(0xFF1C1C1E),
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D0D0D),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        dividerColor: const Color(0xFF2C2C2E),
      ),

      home: const SplashScreen(),
    );
  }
}
