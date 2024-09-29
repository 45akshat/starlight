// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>(); // Form key for validation
//
//   // Track whether OTP field should be shown
//   bool isOtpFieldVisible = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Form(
//             key: _formKey, // Form widget for validation
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment:
//                   CrossAxisAlignment.start, // Align items to the left
//               children: [
//                 SizedBox(height: 80), // Adjusted space from the top
//                 Center(
//                   child: Image.asset(
//                     'assets/img/hello.png',
//                     height: 300, // Adjusted image height
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                Column(
//   crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
//   children: [
//     Text(
//       isOtpFieldVisible ? 'Enter OTP' : 'Login', // Change text based on OTP visibility
//       style: TextStyle(
//         fontSize: 30, // Adjusted font size
//         fontWeight: FontWeight.bold,
//         color: Colors.black,
//       ),
//     ),
//     SizedBox(height: 10),
//     if (!isOtpFieldVisible)
//       Text(
//         'Enter your phone number and you will receive an OTP to get started!',
//         style: TextStyle(
//           fontSize: 14, // Smaller font size
//           color: Colors.grey[600],
//         ),
//       ),
//     if (isOtpFieldVisible)
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Text(
//               'A 6 digit code has been sent to \n +91 ${phoneController.text}',
//               style: TextStyle(
//                 fontSize: 14, // Slightly smaller font size
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 isOtpFieldVisible = false; // Allow editing the phone number
//                 phoneController.clear(); // Clear the phone number for re-entry
//               });
//             },
//             child: Icon(Icons.edit, color: const Color.fromARGB(255, 5, 90, 237)),
//           ),
//         ],
//       ),
//     SizedBox(height: 30),
//     if (!isOtpFieldVisible) _buildPhoneNumberField(),
//     SizedBox(height: 5),
//     if (isOtpFieldVisible) _buildOTPField(),
//     if (isOtpFieldVisible) SizedBox(height: 5),
//   ],
// ),
//
//                 SizedBox(height: 5),
//                 _buildActionButton(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPhoneNumberField() {
//     return TextFormField(
//       controller: phoneController,
//       keyboardType: TextInputType.phone,
//       style: TextStyle(fontSize: 14), // Slightly smaller font size for input
//       inputFormatters: [
//         LengthLimitingTextInputFormatter(10),
//         FilteringTextInputFormatter.digitsOnly,
//       ],
//       decoration: InputDecoration(
//         prefixText: '+91  ',
//         prefixStyle: TextStyle(color: Colors.black, fontSize: 14),
//         hintText: 'Phone Number',
//         hintStyle: TextStyle(
//           color: Colors.grey[500],
//           fontSize: 14,
//         ),
//         filled: true,
//         fillColor: Colors.grey[100],
//         prefixIcon: Icon(
//           Icons.phone,
//           color: Colors.black,
//           size: 18,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter your phone number';
//         } else if (value.length != 10) {
//           return 'Phone number must be exactly 10 digits';
//         }
//         return null;
//       },
//     );
//   }
//
//   Widget _buildOTPField() {
//     return TextFormField(
//       controller: otpController,
//       keyboardType: TextInputType.number,
//       inputFormatters: [
//         LengthLimitingTextInputFormatter(6),
//         FilteringTextInputFormatter.digitsOnly,
//       ],
//       style: TextStyle(fontSize: 14), // Smaller font size
//       decoration: InputDecoration(
//         hintText: 'OTP',
//         hintStyle: TextStyle(
//           color: Colors.grey[500],
//           fontSize: 14,
//         ),
//         filled: true,
//         fillColor: Colors.grey[100],
//         prefixIcon: Icon(
//           Icons.lock,
//           color: Colors.black,
//           size: 18,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter the OTP';
//         } else if (value.length != 6) {
//           return 'OTP must be exactly 6 digits';
//         }
//         return null;
//       },
//     );
//   }
//
//   Widget _buildActionButton() {
//     return SizedBox(
//       width: double.infinity, // Button takes full width
//       child: ElevatedButton(
//         onPressed: () {
//           if (_formKey.currentState!.validate()) {
//             if (!isOtpFieldVisible) {
//               // Logic to send OTP
//               setState(() {
//                 isOtpFieldVisible = true;
//               });
//             } else {
//               // Logic to verify OTP and proceed to login
//             }
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           foregroundColor: Colors.white,
//           backgroundColor: const Color.fromARGB(255, 5, 90, 237),
//           padding: EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         child: Text(
//           isOtpFieldVisible ? 'Verify OTP' : 'Send OTP',
//           style: TextStyle(
//             fontSize: 14, // Slightly smaller font size for button text
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starlight/services/database.dart';
import 'package:starlight/set_pin.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final DatabaseService _databaseService = DatabaseService();

  bool isOtpFieldVisible = false;
  String? pinstore;

  // Method to fetch the pin based on phone number
  Future<void> fetchAndNavigate() async {
    final data = await _databaseService.findDocumentByPhoneNum('users', phoneController.text);
    pinstore = data?['pin'];

    if (pinstore == '0') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SetPinScreen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PinEntryScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Center(
                  child: Image.asset(
                    'assets/img/hello.png',
                    height: 300,
                  ),
                ),
                SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOtpFieldVisible ? 'Enter OTP' : 'Login',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (!isOtpFieldVisible)
                      Text(
                        'Enter your phone number and you will receive an OTP to get started!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    if (isOtpFieldVisible)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'A 6 digit code has been sent to \n +91 ${phoneController.text}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isOtpFieldVisible = false;
                                phoneController.clear();
                              });
                            },
                            child: Icon(Icons.edit, color: const Color.fromARGB(255, 5, 90, 237)),
                          ),
                        ],
                      ),
                    SizedBox(height: 30),
                    if (!isOtpFieldVisible) _buildPhoneNumberField(),
                    SizedBox(height: 5),
                    if (isOtpFieldVisible) _buildOTPField(),
                  ],
                ),
                SizedBox(height: 5),
                _buildActionButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      style: TextStyle(fontSize: 14),
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        prefixText: '+91  ',
        prefixStyle: TextStyle(color: Colors.black, fontSize: 14),
        hintText: 'Phone Number',
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        prefixIcon: Icon(
          Icons.phone,
          color: Colors.black,
          size: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        } else if (value.length != 10) {
          return 'Phone number must be exactly 10 digits';
        }
        return null;
      },
    );
  }

  Widget _buildOTPField() {
    return TextFormField(
      controller: otpController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: 'OTP',
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.black,
          size: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the OTP';
        } else if (value.length != 6) {
          return 'OTP must be exactly 6 digits';
        }
        return null;
      },
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (!isOtpFieldVisible) {
              // Logic to send OTP
              setState(() {
                isOtpFieldVisible = true;
              });
            } else {
              // Fetch the pin and navigate accordingly
              await fetchAndNavigate();
            }
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 5, 90, 237),
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          isOtpFieldVisible ? 'Verify OTP' : 'Send OTP',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
//
// class SetPinScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Set PIN'),
//       ),
//       body: Center(
//         child: Text('Set your PIN here'),
//       ),
//     );
//   }
// }

class PinEntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter PIN'),
      ),
      body: Center(
        child: Text('Enter your PIN here'),
      ),
    );
  }
}

