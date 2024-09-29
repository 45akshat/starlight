import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'HomePage.dart';
import 'services/database.dart';


class PinEntryScreen extends StatefulWidget {
  @override
  _PinEntryScreenState createState() => _PinEntryScreenState();
}


class _PinEntryScreenState extends State<PinEntryScreen> {
  String phonenumber = '9022559233';
  String pinstore = '0';
  final DatabaseService _databaseService =
  DatabaseService();

  Future<void> funcc() async{
    final data =  await _databaseService.findDocumentByPhoneNum(
        'users', phonenumber);
    print(data?['phoneNum']);
    pinstore = data?['pin'];
  }



  @override
  void initState() {
    // final data =  _databaseService.findDocumentByPhoneNum(
    //     'users', phonenumber);
    //  print('#############${data[0]['phoneNum']}');
    funcc();

    super.initState();
  }
  TextEditingController _pinController = TextEditingController();

  void _submitPin() {
    String pin = _pinController.text;
    if (_pinController.text == pinstore) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => homepage()),
      );
    } else {
      // Show error message or handle incomplete PIN
      print('Please enter a correct 4-digit PIN');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  'Set Your PIN',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for dark theme
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Enter a 4-digit PIN to secure your account',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400], // Lighter grey for readability
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),

                // PIN input field
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
                      letterSpacing: 10.0, // Spacing between digits
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Text color for input
                    ),
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      counterText: "", // Remove the counter below the input
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors
                            .grey), // Underline color
                      ),
                      hintText: "••••", // Placeholder for the PIN
                      hintStyle: TextStyle(color: Colors.grey), // Hint color
                    ),
                  ),
                ),
                SizedBox(height: 40),

                // Continue button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.blue, // Button color
                  ),
                  onPressed: () {
                    // Action for submitting the PIN
                    _submitPin();
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(fontSize: 16,
                        color: Colors.white), // Text color for button
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