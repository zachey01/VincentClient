import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const VincentApp());
}

class VincentApp extends StatelessWidget {
  const VincentApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFD7B46A),
      brightness: Brightness.dark,
      surface: const Color(0xFF1A140F),
      primary: const Color(0xFFD7B46A),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vincent Client',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,

        scaffoldBackgroundColor: const Color(0xFF120E0A),
        fontFamily: null,
      ),
      home: const HomePage(),
    );
  }
}
