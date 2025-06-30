import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _turfController = TextEditingController();

  bool isLoading = false;

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    final bookingData = {
      'userId': user?.uid,
      'turf': _turfController.text.trim(),
      'date': _dateController.text.trim(),
      'time': _timeController.text.trim(),
      'createdAt': Timestamp.now(),
    };

    try {
      await FirebaseFirestore.instance.collection('bookings').add(bookingData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking successful')),
        );
        Navigator.pushNamed(context, '/user/order-summary');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book a Turf")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _turfController,
                decoration: const InputDecoration(labelText: 'Turf Name'),
                validator: (val) => val!.isEmpty ? 'Enter turf name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Booking Date'),
                validator: (val) => val!.isEmpty ? 'Enter date' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time Slot'),
                validator: (val) => val!.isEmpty ? 'Enter time' : null,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _submitBooking,
                child: const Text("Confirm Booking"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
