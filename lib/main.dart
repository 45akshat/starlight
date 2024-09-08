import 'package:flutter/material.dart';
import 'package:starlight/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Starlight',
      theme: ThemeData(
        fontFamily: 'Poppins', // Set default font to Poppins
        useMaterial3: true,
      ),
      home: LoginPage(), // Set LoginPage as the home page
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}
