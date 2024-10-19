import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:starlight/FrontScreen.dart';
import 'package:starlight/HomePage.dart';
import 'package:starlight/KidsFrontScreen.dart';
import 'package:starlight/PinScreen.dart';
import 'package:starlight/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:starlight/set_pin.dart';
import 'package:starlight/trial.dart';
import 'PinScreen.dart';
import 'package:starlight/upgrade_premium.dart';
import 'AccountSettings.dart';
import 'firebase_options.dart';
import 'kidsParentsOptionScreen.dart';

final FlutterSecureStorage secureStorage = FlutterSecureStorage();

// Function to get the stored JWT token
Future<String?> getJwtToken() async {
  return await secureStorage.read(key: 'jwt_token');
}


void getStoredPhoneNumber() async {
  phoneNumber = (await secureStorage.read(key: 'phone_number'))!;
}

//
// // Function to check login status and navigate accordingly
// Future<void> checkLoginStatus(BuildContext context) async {
//   String? token = await getJwtToken(); // Retrieve token from secure storage
//   print('working till here ^^^^^^^^^^^^^^^^^^^^^^^^^^');
//   if (token != null) {
//     print('token found ^^^^^^^^^^^^^^^^^^^^^^^^^^');
//     // Token exists, navigate to the main screen
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => FirstScreen()));
//   } else {
//     print('token wasa not found^^^^^^^^^^^^^^^^^^^^^^^^^^');
//     // No token, navigate to the login screen
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => LoginPage()));
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    getStoredPhoneNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ...
      home: Builder(
        builder: (context) =>
            FutureBuilder<String?>(
              future: getJwtToken(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Token exists, navigate
                  return PinEntryScreen();
                } else {
                  // No token, show splash screen
                  return LoginPage();
                }
              },
            ),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Starlight',
    theme: ThemeData(
      fontFamily: 'Poppins', // Set default font to Poppins
      useMaterial3: true,
    ),
    home: Scaffold(
      body: Center(
          child: CircularProgressIndicator()), // Optional loading indicator
    ),
  );
}
