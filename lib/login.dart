//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:math';
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   bool isOtpFieldVisible = false; // Controls the visibility of the OTP input field
//   String? generatedOtp; // Store generated OTP to verify later
//
//   Future<bool> sendOtp(String phoneNumber, String otp) async {
//     const String apiUrl1 = 'https://www.fast2sms.com/dev/bulkV2?authorization=1XT6J9q2yWorcfD8xBdei7e7X2DYaO36DzRm4QSKoQ9PTZI5EIdBX33NENHd&route=otp&variables_values=';
//     const String apiUrl2 = '&flash=0&numbers=';
//     final Uri url = Uri.parse('$apiUrl1$otp$apiUrl2$phoneNumber');
//
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         if (responseData['status'] == 'success') {
//           print('OTP sent successfully!');
//           return true;
//         } else {
//           print('Failed to send OTP');
//           return true;
//         }
//       } else {
//         print('Failed with status code: ${response.statusCode}');
//         return true;
//       }
//     } catch (e) {
//       print('Error sending OTP: $e');
//       return true;
//     }
//   }
//
//   String generateOtp() {
//     var random = Random();
//     int otp = 1000 + random.nextInt(9000); // Ensures a 4-digit number
//     return otp.toString();
//   }
//
//   void _sendOtpToUser(String phoneNumber) async {
//     String otp = generateOtp();
//     bool otpSent = await sendOtp(phoneNumber, otp);
//
//     if (otpSent) {
//       setState(() {
//         isOtpFieldVisible = true; // Show OTP field
//         generatedOtp = otp; // Save generated OTP to verify later
//       });
//       print('OTP sent successfully to $phoneNumber');
//     } else {
//       // Handle the error scenario
//       print('Failed to send OTP');
//     }
//   }
//
//   void _verifyOtp() {
//     if (otpController.text == generatedOtp) {
//       // OTP verification successful
//       print('OTP verified successfully!');
//       // Navigate to the next screen or perform further actions
//     } else {
//       // OTP verification failed
//       print('Invalid OTP entered!');
//       // Show error or prompt user to try again
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 80),
//                 Center(
//                   child: Image.asset(
//                     'assets/img/hello.png',
//                     height: 300,
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       isOtpFieldVisible ? 'Enter OTP' : 'Login',
//                       style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     if (!isOtpFieldVisible)
//                       Text(
//                         'Enter your phone number and you will receive an OTP to get started!',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     if (isOtpFieldVisible)
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               'A 4-digit code has been sent to \n +91 ${phoneController.text}',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 isOtpFieldVisible = false;
//                                 phoneController.clear();
//                               });
//                             },
//                             child: Icon(Icons.edit,
//                                 color: const Color.fromARGB(255, 5, 90, 237)),
//                           ),
//                         ],
//                       ),
//                     SizedBox(height: 30),
//                     if (!isOtpFieldVisible) _buildPhoneNumberField(),
//                     SizedBox(height: 5),
//                     if (isOtpFieldVisible) _buildOTPField(),
//                   ],
//                 ),
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
//       style: TextStyle(fontSize: 14),
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
//         LengthLimitingTextInputFormatter(4),
//         FilteringTextInputFormatter.digitsOnly,
//       ],
//       style: TextStyle(fontSize: 14),
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
//         } else if (value.length != 4) {
//           return 'OTP must be exactly 4 digits';
//         }
//         return null;
//       },
//     );
//   }
//
//   Widget _buildActionButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () {
//           if (_formKey.currentState!.validate()) {
//             if (!isOtpFieldVisible) {
//               String phoneNumber = phoneController.text;
//               _sendOtpToUser(phoneNumber);
//             } else {
//               _verifyOtp();
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
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }


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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starlight/services/database.dart';
import 'package:starlight/set_pin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import 'PinScreen.dart';

late String phoneNumber;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();

  bool isOtpFieldVisible = false;
  String? pinstore;
  late String generatedotp ;
  late String fetcheddocid;
  late String token;

// Create an instance of FlutterSecureStorage
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<void> storePhoneNumber(String phoneNumber) async {
    await secureStorage.write(key: 'phone_number', value: phoneNumber);
    print('Phone number stored securely');
  }

  Future<String?> getStoredPhoneNumber() async {
    return await secureStorage.read(key: 'phone_number');
  }


// Store JWT Token securely
  Future<void> storeJwtToken(String token) async {
    await secureStorage.write(key: 'jwt_token', value: token);
    print('storejwttoken working#############');
  }


// Delete the JWT Token (used for logout)
  Future<void> deleteJwtToken() async {
    await secureStorage.delete(key: 'jwt_token');
  }


  Future<String> getOrCreateUserDoc(String phoneNumber) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Step 1: Check if the document exists based on the phone number
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('phoneNum', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Step 2: If found, return the document ID
      String docId = querySnapshot.docs.first.id;
      print('Document already exists with ID: $docId');
      return docId;
    } else {
      // Step 3: If not found, create a new document with the given fields
      Map<String, dynamic> userData = {
        'isCreated': '25-09-2024', // Replace with actual date if needed
        'isPremium': false,
        'phoneNum': phoneNumber,
        'pin': '0000',
        'subscription_id': 'awb01',
      };

      DocumentReference newDocRef = await firestore.collection('users').add(userData);

      print('Created new document with ID: ${newDocRef.id}');
      print('user doc creation working#############');
      return newDocRef.id;
    }
  }


  Future<String?> fetchJwtToken(String phoneno, String userId) async {
    final String url =
        'https://wfvwo33p6fherajz5hdlsmo6ca0kswib.lambda-url.ap-south-1.on.aws/?action=generate&email=$phoneno&user_id=$userId&token=1';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Assuming the JWT token is returned in the response body
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Assuming the token is stored in a key named 'token' in the response
        if (responseData.containsKey('token')) {
          print('jwt token fetching working#############');
          return responseData['token'];

        } else {
          print('Token not found in the response.');
          return null;
        }
      } else {
        print('Failed to generate JWT token. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching JWT token: $e');
      return null;
    }
  }







  Future<bool> sendOtp(String phoneNumber,String otp) async {

    const String apiUrl1 =
        'https://www.fast2sms.com/dev/bulkV2?authorization=1XT6J9q2yWorcfD8xBdei7e7X2DYaO36DzRm4QSKoQ9PTZI5EIdBX33NENHd&route=otp&variables_values=';
    const String apiUrl2 = '&flash=0&numbers=';

    final Uri url = Uri.parse(
        '$apiUrl1$otp$apiUrl2$phoneNumber');

    try {

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          print('OTP sent successfully!');
          return true;
        } else {
          print('Failed to send OTP');
          return false;
        }
      } else {
        print('Failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    }
  }


  String generateOtp() {
    var random = Random();
    int otp = 1000 + random.nextInt(9000);
    return otp.toString();
  }


  void _sendOtpToUser(String phno,String otp) async {

    bool otpSent = await sendOtp(phno,otp);

    if (otpSent) {
      print('OTP sent successfully to $phno');
    } else {
      print('Failed to send OTP');
    }
  }


  Future<void> _verifyOtp() async {
    if (otpController.text == generatedotp) {

     phoneNumber = phoneController.text;
      await storePhoneNumber(phoneNumber);


      fetcheddocid = await getOrCreateUserDoc(phoneController.text);
      token  = (await fetchJwtToken(phoneController.text, fetcheddocid))!;
     await storeJwtToken(token);

      print('OTP verified successfully!');
    } else {

      print('Invalid OTP entered!');

    }
  }


  Future<void> fetchAndNavigate() async {
    final data = await _databaseService.findDocumentByPhoneNum(
        'users', phoneController.text);
    pinstore = data?['pin'];

    if (pinstore == '0000') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SetPinScreen()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PinEntryScreen()));
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
                            child: Icon(Icons.edit,
                                color: const Color.fromARGB(255, 5, 90, 237)),
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
        LengthLimitingTextInputFormatter(4),
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
        } else if (value.length != 4) {
          return 'OTP must be exactly 4 digits';
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

              String otp = generateOtp();
              generatedotp = otp;
              print('Your OTP is: $otp');

              String phoneno = phoneController.text;
              print(phoneno);
              _sendOtpToUser(phoneno, otp);


              setState(() {
                isOtpFieldVisible = true;
              });
            } else {

              _verifyOtp();
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













