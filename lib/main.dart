import 'package:flutter/material.dart';
import 'package:starlight/FrontScreen.dart';
import 'package:starlight/HomePage.dart';
import 'package:starlight/PinScreen.dart';
import 'package:starlight/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:starlight/set_pin.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
