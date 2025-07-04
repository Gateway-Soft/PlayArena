import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TurfDetailScreen extends StatelessWidget {
  final String turfId;
  final Map<String, dynamic> turfData;

  const TurfDetailScreen({
    super.key,
    required this.turfId,
    required this.turfData,
  });

  Future<void> bookSlot(BuildContext context, String slotTime) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in to book a slot.")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': user.uid,
        'userName': user.displayName ?? 'User',
        'turfId': turfId,
        'turfName': turfData['name'] ?? '',
        'slot': slotTime,
        'date': DateTime.now().toString().split(' ')[0], // Today’s date
        'status': 'Confirmed',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Slot '$slotTime' booked successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking failed: $e")),
      );
    }
  }

  Stream<QuerySnapshot> getSlotStream() {
    return FirebaseFirestore.instance
        .collection('turfs')
        .doc(turfId)
        .collection('slots')
        .orderBy('time')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final name = turfData['name'] ?? 'Turf';
    final imageUrl = turfData['imageUrl'] ?? '';
    final category = turfData['category'] ?? 'Sports';
    final location = turfData['location'] ?? 'Unknown';
    final description = turfData['description'] ?? 'No description available.';

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🖼 Turf Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Image.asset('assets/turf_sample.jpg', height: 200, fit: BoxFit.cover),
            )
                : Image.asset('assets/turf_sample.jpg', height: 200, fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),

          // ℹ️ Turf Info
          Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Category: $category"),
          Text("Location: $location"),
          const SizedBox(height: 12),
          Text(description),

          const SizedBox(height: 20),

          const Text("Available Slots", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          // ⏰ Slot List
          StreamBuilder<QuerySnapshot>(
            stream: getSlotStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final slots = snapshot.data?.docs ?? [];

              if (slots.isEmpty) {
                return const Text("No slots available for this turf.");
              }

              return Column(
                children: slots.map((doc) {
                  final time = doc['time'];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(time),
                      trailing: ElevatedButton(
                        onPressed: () => bookSlot(context, time),
                        child: const Text("Book"),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
