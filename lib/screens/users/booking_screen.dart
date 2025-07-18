import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  String? selectedTurfId;
  String? selectedTime;
  Map<String, dynamic> turfs = {};
  List<String> availableSlots = [];

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTurfs(); // Fetch turf data on start
  }

  Future<void> fetchTurfs() async {
    try {
      final snapshot = await _firestore.collection('turfs').get();
      setState(() {
        turfs = {for (var doc in snapshot.docs) doc.id: doc.data()};
      });
    } catch (e) {
      print("❌ Error fetching turfs: $e");
    }
  }

  void updateSlotsForTurf(String turfId) {
    final turf = turfs[turfId];
    print("✅ Selected Turf: ${turf['name']}");
    print("🕒 Available Slots: ${turf['availableSlots']}");
    setState(() {
      availableSlots = List<String>.from(turf['availableSlots'] ?? []);
    });
  }

  Future<void> bookSlot() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || selectedTurfId == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    try {
      final turf = turfs[selectedTurfId];
      await _firestore.collection('bookings').add({
        'userId': user.uid,
        'userName': userNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'turfId': selectedTurfId,
        'turfName': turf['name'],
        'selectedTime': selectedTime,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Slot booked successfully!')),
      );

      // Clear form
      setState(() {
        selectedTurfId = null;
        selectedTime = null;
        availableSlots = [];
      });
      userNameController.clear();
      phoneController.clear();
    } catch (e) {
      print("❌ Error booking slot: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book slot: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📅 Book Turf Slot')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: selectedTurfId,
                decoration: const InputDecoration(labelText: "Select Turf"),
                items: turfs.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedTurfId = value;
                      selectedTime = null;
                    });
                    updateSlotsForTurf(value);
                  }
                },
                validator: (value) => value == null ? 'Please select a turf' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedTime,
                decoration: const InputDecoration(labelText: "Select Time Slot"),
                items: availableSlots.map((slot) {
                  return DropdownMenuItem(
                    value: slot,
                    child: Text(slot),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedTime = value),
                validator: (value) => value == null ? 'Please select a slot' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: userNameController,
                decoration: const InputDecoration(labelText: "Your Name"),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Phone Number"),
                validator: (value) => value!.isEmpty ? 'Enter phone number' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: bookSlot,
                child: const Text("✅ Book Slot"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
