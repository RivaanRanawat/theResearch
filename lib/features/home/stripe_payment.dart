import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:research/features/auth/auth_controller.dart';
import 'package:research/providers.dart';
import 'package:research/secrets.dart';
import 'package:research/utils.dart';

class StripePaymentHandle {
  final WidgetRef ref;
  StripePaymentHandle(this.ref);
  Map<String, dynamic>? paymentIntent;

  Future<void> stripeMakePayment(
      double selectedPrice, BuildContext context) async {
    try {
      await Stripe.instance.applySettings();
      final value = (selectedPrice).toInt().toString();
      paymentIntent = await createPaymentIntent(value, 'INR');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  billingDetails: const BillingDetails(
                    name: 'YOUR NAME',
                    email: 'YOUREMAIL@gmail.com',
                    phone: 'YOUR NUMBER',
                    address: Address(
                      city: 'YOUR CITY',
                      country: 'YOUR COUNTRY',
                      line1: 'YOUR ADDRESS 1',
                      line2: 'YOUR ADDRESS 2',
                      postalCode: 'YOUR PINCODE',
                      state: 'YOUR STATE',
                    ),
                  ),
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Ikay'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(value, context);
    } catch (e) {
      print(e.toString());
    }
  }

  displayPaymentSheet(value, context) async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();
      var user = ref.read(currentUserModelProvider)!;

      user = user.copyWith(
        funding: user.funding + (int.parse(value) ~/ 83),
      );

      ref.read(authControllerProvider.notifier).updateUserData(user);

      showSnackBar(
        context,
        ('\$${value / 83} worth of tokens added to your account!'),
      );
    } catch (e) {
      // if (e is StripeException) {
      //   Fluttertoast.showToast(
      //       msg: 'Error from Stripe: ${e.error.localizedMessage}');
      // } else {
      //   Fluttertoast.showToast(msg: 'Unforeseen error: ${e}');
      // }
      print(e);
    }
  }

//create Payment
  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $stripeAPIKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

//calculate Amount
  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
