import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/user/payment-success'),
          child: const Text("Simulate Payment"),
        ),
      ),
    );
  }
}
