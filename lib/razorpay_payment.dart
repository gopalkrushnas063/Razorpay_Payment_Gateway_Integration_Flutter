import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayPage extends StatefulWidget {
  const RazorPayPage({super.key});

  @override
  State<RazorPayPage> createState() => _RazorPayPageState();
}

class _RazorPayPageState extends State<RazorPayPage> {
  late Razorpay _razorpay;
  TextEditingController amtController = new TextEditingController();

  void openCheckout(amount) async {
    amount = amount * 100;
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': 100,
      'name': 'New Bharat Biz',
      "image" : "https://play-lh.googleusercontent.com/P5S6UBnf7Md6sO1ddW4awqeFmVphTYoMA_DIgpxmVH50XcKmnmDR7UC31omTSAsJlQ=w480-h960-rw",
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error : $e");
    }
  }

  void handelPaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Pament Successful ${response.paymentId!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void handelPaymentFailure(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Pament Failed ${response.message!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void handelExternalWallets(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External Wallets ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handelPaymentFailure);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handelPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handelExternalWallets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Image.network(
              "https://newbharatbiz.in/static/media/Darklogo.8458a4a76da9adea8e8b.png",
              width: 300,
            ),
            const SizedBox(
              height: 0,
            ),
            const Text(
              "Welcome To Razorpay Payment Gateway",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                cursorColor: Colors.black,
                autofocus: false,
                style: TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: "Enter Amount",
                  labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  )),
                  errorStyle: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 15,
                  ),
                ),
                controller: amtController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter amount to be paid";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (amtController.text.toString().isNotEmpty) {
                  int amount = int.parse(amtController.text.toString());
                  openCheckout(amount);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child:  const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Make Payment",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
