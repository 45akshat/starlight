import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/login.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountSettingsScreen extends StatefulWidget {


  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  DocumentSnapshot? userData;
  bool isLoading = true;
  bool isEditingPin = false;
  TextEditingController pinController = TextEditingController();
  late String userid;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      // Fetch the document ID (userid) using the phone number asynchronously
      await findDocumentByPhoneNum('users', phoneNumber);

      if (userid != null) {
        // Now fetch the user data after the userid is available
        await _fetchUserData(userid);
      } else {
        // Handle the case when the document is not found
        print('User ID not found.');
      }
    } catch (e) {
      print("Error initializing user data: $e");
    }
  }


  Future<void> _fetchUserData(userid) async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .get();

      setState(() {
        userData = document;
        pinController.text = document['pin'];
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> findDocumentByPhoneNum(String collectionName, String phoneNum) async {
    try {
      final CollectionReference coll = FirebaseFirestore.instance.collection(collectionName);

      QuerySnapshot querySnapshot = await coll
          .where('phoneNum', isEqualTo: phoneNum)
          .limit(1)  // Fetch only one document
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
       userid = doc.id;
      } else {
        print('No document found with the given phone number');
        return null;
      }
    } catch (e) {
      print("Error fetching document by phoneNum: $e");
      return null;
    }
  }

  Future<void> _changePin() async {
    if (pinController.text.isNotEmpty && pinController.text.length == 4) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userid)
            .update({'pin': pinController.text});

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("PIN changed successfully"),
        ));
        setState(() {
          isEditingPin = false;
        });
      } catch (e) {
        print("Error updating PIN: $e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("PIN must be 4 digits"),
      ));
    }
  }


  Future<void> _openDeleteAccount() async {
    const url = 'https://www.example.com/delete-account';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
        ),
      );
    }

    String phoneNum = userData!['phoneNum'];
    String subscriptionId = userData!['subscription_id'];
    String isCreated = userData!['isCreated'];
    bool isPremium = userData!['isPremium'];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Account Settings',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Phone Number"),
            _buildDetailText(phoneNumber),
            Divider(color: Colors.grey),

            _buildSectionTitle("Subscription ID"),
            _buildDetailText(subscriptionId),
            Divider(color: Colors.grey),

            _buildSectionTitle("Account Created On"),
            _buildDetailText(isCreated),
            Divider(color: Colors.grey),

            _buildPremiumStatus(isPremium),
            Divider(color: Colors.grey, height: 40),

            // Change PIN Section
            _buildPinSection(),

            SizedBox(height: 20),

            _buildExtraOption('Delete Account', _openDeleteAccount),

            SizedBox(height: 40),

            // Logout button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Logout', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 14, color: Colors.grey[400], fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildDetailText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildPremiumStatus(bool isPremium) {
    return Row(
      children: [
        Text("Premium Status: ", style: TextStyle(fontSize: 16, color: Colors.white)),
        Text(
          isPremium ? "Premium" : "Free",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isPremium ? Colors.teal : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildPinSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("PIN: ", style: TextStyle(fontSize: 16, color: Colors.white)),
            if (!isEditingPin)
              TextButton(
                onPressed: () {
                  setState(() {
                    isEditingPin = true;
                  });
                },
                child: Text("Edit", style: TextStyle(color: Colors.teal)),
              ),
          ],
        ),
        if (isEditingPin)
          Column(
            children: [
              TextField(
                controller: pinController,
                decoration: InputDecoration(
                  labelText: 'Enter new PIN',
                  labelStyle: TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _changePin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: Text('Update PIN', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildExtraOption(String title, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.teal,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
