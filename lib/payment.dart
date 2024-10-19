import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment {
  late Razorpay _razorpay;

  Payment(context) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        (response) => _handlePaymentErrorResponse(context, response));
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (response) => _handlePaymentSuccessResponse(context, response));
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
        (response) => _handleExternalWalletSelected(context, response));
  }

  // Create a subscription in the Flutter app
  Future<String?> createSubscription() async {
    var authKey = base64Encode(utf8.encode('rzp_test_XcommSeoYFGmeQ:kWT4kDG5N5gQ0wVENQCjw3ke')); // Replace with your test/live key ID and secret

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $authKey',
    };

    var body = jsonEncode({
      "plan_id": "plan_P2TfUk93xAkwm6",  // Replace with your actual plan ID
      "customer_notify": 1,
      "total_count": 12,         // Total count of billing cycles (e.g., 12 for yearly)
      "start_at": (DateTime.now().millisecondsSinceEpoch / 1000).round() + 3600*2,  // Start subscription 1 hour from now
      "notes": {
        "note_key_1": "Premium Subscription"
      }
    });

    var response = await http.post(
      Uri.parse('https://api.razorpay.com/v1/subscriptions'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['id']; // Return the subscription ID
    } else {
      print('Failed to create subscription: ${response.body}');
      return null;
    }
  }

  // Initiate subscription payment
  Future<void> initiateSubscriptionPayment(BuildContext context, String phoneNum, String email) async {
    String? subscriptionId = await createSubscription();  // Get the subscription ID

    if (subscriptionId != null) {
      var options = {
        'key': 'rzp_test_XcommSeoYFGmeQ',  // Replace with your actual Razorpay key
        'subscription_id': subscriptionId,  // Use the subscription ID
        'name': 'Starlight',
        'description': 'Premium Subscription',
        'prefill': {
          'contact': phoneNum,
          'email': email,
        },
        'send_sms_hash': true,
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        print("Error: $e");
      }
    } else {
      _showAlertDialog(context, 'Subscription Failed', 'Unable to create a subscription.');
    }
  }

  void _handlePaymentErrorResponse(context, PaymentFailureResponse response) {
    _showAlertDialog(
      context,
      "Payment Failed",
      "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}",
    );
  }

  void _handlePaymentSuccessResponse(
      context, PaymentSuccessResponse response) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessPage(paymentId: response.paymentId!),
      ),
    );
  }

  void _handleExternalWalletSelected(context, ExternalWalletResponse response) {
    _showAlertDialog(
      context,
      "External Wallet Selected",
      "${response.walletName}",
    );
  }

  void _showAlertDialog(context, String title, String message) {
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class PaymentSuccessPage extends StatelessWidget {
  final String paymentId;

  const PaymentSuccessPage({Key? key, required this.paymentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Success'),
      ),
      body: Center(
        child: Text('Payment successful with ID: $paymentId'),
      ),
    );
  }
}
