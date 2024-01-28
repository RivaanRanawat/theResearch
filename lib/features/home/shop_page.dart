import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research/features/home/stripe_payment.dart';
import 'package:research/utils.dart';

class ShopPage extends ConsumerStatefulWidget {
  const ShopPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  var selectedPrice = 0.1;

  void stripePay() async {
    try {
      selectedPrice = selectedPrice * 83;
      await StripePaymentHandle(ref).stripeMakePayment(selectedPrice);
      if (context.mounted) {
        showSnackBar(
          context,
          ('\$${selectedPrice / 83} worth of tokens added to your account!'),
        );
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy TRToken'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset('assets/images/coin_tr.jpeg'),
            ),
          ),
          Slider(
            value: selectedPrice,
            min: 0,
            max: 1000,
            thumbColor: Colors.blue,
            activeColor: Colors.blue.withOpacity(0.7),
            divisions: 1000,
            label: '\$$selectedPrice',
            onChanged: (val) {
              setState(() {
                selectedPrice = val;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: MaterialButton(
              elevation: 0,
              minWidth: double.maxFinite,
              height: 50,
              onPressed: () {
                stripePay();
              },
              color: Colors.blue,
              textColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Text(
                'Buy \$$selectedPrice',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
