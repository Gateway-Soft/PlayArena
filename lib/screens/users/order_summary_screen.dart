import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  Future<void> bookTurf(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    final bookingData = {
      "userId": user.uid,
      "turf": "PlayArena Turf",
      "date": "2025-07-01",
      "time": "5 PM - 6 PM",
      "createdAt": Timestamp.now(),
    };

    try {
      await FirebaseFirestore.instance.collection("bookings").add(bookingData);

      // Navigate to booking confirmation screen
      Navigator.pushNamed(context, '/user/booking-confirmation');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Turf: PlayArena Turf", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            const Text("Date: 2025-07-01", style: TextStyle(fontSize: 16)),
            const Text("Time: 5 PM - 6 PM", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text("Amount: ₹500", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Spacer(),
            ElevatedButton(
              onPressed: () => bookTurf(context),
              child: const Text("Confirm & Book"),
            ),
          ],
        ),
      ),
    );
  }
}
