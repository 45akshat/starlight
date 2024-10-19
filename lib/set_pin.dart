import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'HomePage.dart';
import 'kidsParentsOptionScreen.dart';
import 'main.dart';
import 'services/database.dart';
import 'login.dart';

class SetPinScreen extends StatefulWidget {
  @override
  _SetPinScreenState createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final DatabaseService _databaseService = DatabaseService();
  TextEditingController _pinController = TextEditingController();

  Future<void> funcc() async {
    try {
      final data = await _databaseService.findDocumentByPhoneNum('users', phoneNumber);
      if (data != null) {
        DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc(data[phoneNumber]);
        await docRef.update({'pin': _pinController.text});

        print('PIN updated successfully');
      } else {
        print('No document found with the given phone number');
      }
    } catch (e) {
      print("Error updating PIN: $e");
    }
  }


  void getStoredPhoneNumber() async {
    phoneNumber = await secureStorage.read(key: 'phone_number')??'';
  }


  @override
  void initState() {
    getStoredPhoneNumber();

    super.initState();
  }

  void _submitPin() {
    if (_pinController.text.length == 4) {
      funcc();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>KidsParentsOption()),
      );
    } else {
      print('Please enter a valid 4-digit PIN');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Set Your PIN',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Enter a 4-digit PIN to secure your account',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Container(
                  width: 200,
                  child: TextField(
                    controller: _pinController,
                    autofocus: true,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    style: TextStyle(
                      fontSize: 24,
                      letterSpacing: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      counterText: "",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintText: "••••",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: _submitPin, // Call _submitPin on button press
                  child: Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
