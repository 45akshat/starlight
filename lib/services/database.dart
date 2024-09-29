import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('userDetails');
  // Collection reference

  // Add order data
  Future<void> addOrder(Map<String, dynamic> orderData, collectionName) async {
    try {
       final CollectionReference coll = FirebaseFirestore.instance.collection(collectionName);

      await coll.add(orderData);
    } catch (e) {
      print("Error adding order: $e");
    }
  }

  // Update order
  Future<void> updateOrder(String id, Map<String, dynamic> orderData) async {
    try {
      await usersCollection.doc(id).update(orderData);
    } catch (e) {
      print("Error updating order: $e");
    }
  }

  // Delete order
  Future<void> deleteOrder(String id) async {
    try {
      await usersCollection.doc(id).delete();
    } catch (e) {
      print("Error deleting order: $e");
    }
  }

  // Find a document by phoneNum and fetch only one document using .limit(1)
  Future<Map<String, dynamic>?> findDocumentByPhoneNum(String collectionName, String phoneNum) async {
    try {
      final CollectionReference coll = FirebaseFirestore.instance.collection(collectionName);

      QuerySnapshot querySnapshot = await coll
          .where('phoneNum', isEqualTo: phoneNum)
          .limit(1)  // Fetch only one document
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        return doc.data() as Map<String, dynamic>;
      } else {
        print('No document found with the given phone number');
        return null;
      }
    } catch (e) {
      print("Error fetching document by phoneNum: $e");
      return null;
    }
  }


// Read data from a collection filtered by email
Future<List<Map<String, dynamic>>> readDataByEmail(String collectionName, String email) async {
  try {
    final CollectionReference coll = FirebaseFirestore.instance.collection(collectionName);
    QuerySnapshot querySnapshot = await coll.where('email', isEqualTo: email)
                                             .orderBy('date', descending: true) // Replace 'timestamp' with your actual timestamp field
                                             .get();

    List<Map<String, dynamic>> dataList = [];

    querySnapshot.docs.forEach((DocumentSnapshot doc) {
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        dataList.add(data);
      } else {
        print('Document does not exist');
      }
    });

    return dataList;
  } catch (e) {
    print("Error reading data: $e");
    return [];
  }
}

Future<List<Map<String, dynamic>>> readDataByPaymentId(String collectionName, String paymentId) async {
  try {
    final CollectionReference coll = FirebaseFirestore.instance.collection(collectionName);
    QuerySnapshot querySnapshot = await coll.where('paymentId', isEqualTo: paymentId)
                                             .orderBy('date', descending: true) // Replace 'timestamp' with your actual timestamp field
                                             .get();

    List<Map<String, dynamic>> dataList = [];

    querySnapshot.docs.forEach((DocumentSnapshot doc) {
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        dataList.add(data);
      } else {
        print('Document does not exist');
      }
    });

    return dataList;
  } catch (e) {
    print("Error reading data: $e");
    return [];
  }
}


Future<List<Map<String, dynamic>>> readDataByEmailLimit(String collectionName, String email) async {
  try {
    final CollectionReference coll = FirebaseFirestore.instance.collection(collectionName);
    QuerySnapshot querySnapshot = await coll.where('email', isEqualTo: email)
                                             .orderBy('date', descending: true) // Replace 'timestamp' with your actual timestamp field
                                             .limit(1)
                                             .get();

    List<Map<String, dynamic>> dataList = [];

    querySnapshot.docs.forEach((DocumentSnapshot doc) {
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        dataList.add(data);
      } else {
        print('Document does not exist');
      }
    });

    return dataList;
  } catch (e) {
    print("Error reading data: $e");
    return [];
  }
}
Future<List<Map<String, dynamic>>> readDataByEmailLimitForUserDetails(String collectionName, String email) async {
  try {
    final CollectionReference coll = FirebaseFirestore.instance.collection(collectionName);
    QuerySnapshot querySnapshot = await coll.where('email', isEqualTo: email)
                                             .limit(1)
                                             .get();

    List<Map<String, dynamic>> dataList = [];

    querySnapshot.docs.forEach((DocumentSnapshot doc) {
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        dataList.add(data);
      } else {
        print('Document does not exist');
      }
    });

    return dataList;
  } catch (e) {
    print("Error reading data: $e");
    return [];
  }
}

  // Add or Update user data based on email
  Future<void> addOrUpdateBookingByEmail(String email, Map<String, dynamic> userData, collectionName) async {
    try {
      
       final CollectionReference coll = FirebaseFirestore.instance.collection(collectionName);
         QuerySnapshot querySnapshot = await coll.where('email', isEqualTo: email).orderBy('date', descending: true).limit(1).get();


      if (querySnapshot.docs.isNotEmpty) {
        // Document with email exists, update it
        DocumentReference docRef = querySnapshot.docs.first.reference;
        await docRef.update(userData);
      } else {
        // Document with email does not exist, add new document
        await coll.add(userData);
      }
    } catch (e) {
      print("Error adding or updating user: $e");
    }
  }

  
    Future<void> addOrUpdateUserByEmail(String email, Map<String, dynamic> userData, collectionName) async {
    try {
      
       final CollectionReference coll = FirebaseFirestore.instance.collection(collectionName);
         QuerySnapshot querySnapshot = await coll.where('email', isEqualTo: email).limit(1).get();


      if (querySnapshot.docs.isNotEmpty) {
        // Document with email exists, update it
        DocumentReference docRef = querySnapshot.docs.first.reference;
        await docRef.update(userData);
      } else {
        // Document with email does not exist, add new document
        await coll.add(userData);
      }
    } catch (e) {
      print("Error adding or updating user: $e");
    }
  }

Future<void> updateWalletIfOnline(String email, String collectionName) async {
  try {
    final CollectionReference coll = FirebaseFirestore.instance.collection(collectionName);
    QuerySnapshot querySnapshot = await coll.where('email', isEqualTo: email).orderBy('date', descending: true).limit(1).get();

    print("onnnnnnnnnnnnnnnnnnnnn**********************");

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot docSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;

      // Extract values from the document
      int estPriceInt = userData['estPrice'];
      double estPrice = estPriceInt.toDouble() ?? 0.0;
      String paymentStatus = userData['paymentStatus'] ?? '';
      String bookingStatus = userData['booking_status'] ?? '';

      // Check payment status and booking status
      if (paymentStatus == "online" && bookingStatus == "cancelled") {
        // Top up wallet with estPrice
        await topupWallet(email, "userDetails", estPrice);
        print("Wallet updated successfully");
      } else {
        print("Payment status is not online or booking status is not cancelled. Wallet not updated.");
      }
    } else {
      print("No document found for the given email.");
    }
  } catch (e) {
    print("Error updating wallet: $e");
  }
}




Future<double> readWallet(String email, String collectionName) async {
  try {
    final CollectionReference coll = FirebaseFirestore.instance.collection(collectionName);
    QuerySnapshot querySnapshot = await coll.where('email', isEqualTo: email).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference docRef = querySnapshot.docs.first.reference;
      DocumentSnapshot docSnapshot = await docRef.get();
      Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;

      // Check the wallet balance
            double walletBalance = 0.0;

      if (userData['wallet'] != null) {
        if (userData['wallet'] is int) {
          walletBalance = (userData['wallet'] as int).toDouble();
        } else if (userData['wallet'] is double) {
          walletBalance = userData['wallet'] as double;
        }
      }

      return walletBalance;
    } else {
      print("No document found for the given email.");
      return 0.0; // or any default value you want to return
    }
  } catch (e) {
    print("Error reading wallet: $e");
    return 0.0; // handle error by returning a default value
  }
}



Future<void> topupWallet(String email, String collectionName, double topupAmount) async {
  try {
    final CollectionReference coll = FirebaseFirestore.instance.collection(collectionName);
    QuerySnapshot querySnapshot = await coll.where('email', isEqualTo: email).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference docRef = querySnapshot.docs.first.reference;
      DocumentSnapshot docSnapshot = await docRef.get();
      Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;

      // Check the wallet balance
            double walletBalance = 0.0;

      if (userData['wallet'] != null) {
        if (userData['wallet'] is int) {
          walletBalance = (userData['wallet'] as int).toDouble();
        } else if (userData['wallet'] is double) {
          walletBalance = userData['wallet'] as double;
        }
      }


      // Top up the wallet
      walletBalance += topupAmount;
      await docRef.update({'wallet': walletBalance});
      print("Wallet topped up successfully.");
    } else {
      print("No document found for the given email.");
    }
  } catch (e) {
    print("Error topping up wallet: $e");
  }
}


  // addOrUpdateUserByEmail("talkwithakshat@gmail.com", )
}
