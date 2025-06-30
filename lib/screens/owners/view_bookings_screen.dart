import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewBookingsScreen extends StatefulWidget {
  const ViewBookingsScreen({Key? key}) : super(key: key);

  @override
  State<ViewBookingsScreen> createState() => _ViewBookingsScreenState();
}

class _ViewBookingsScreenState extends State<ViewBookingsScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Future<List<String>> fetchOwnerTurfIds() async {
    final turfSnapshot = await FirebaseFirestore.instance
        .collection('turfs')
        .where('ownerId', isEqualTo: user?.uid)
        .get();

    return turfSnapshot.docs.map((doc) => doc.id).toList();
  }

  Stream<QuerySnapshot> fetchBookingsStream(List<String> turfIds) {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('turfId', whereIn: turfIds)
        .orderBy('date', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Bookings"),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<String>>(
        future: fetchOwnerTurfIds(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final turfIds = snapshot.data!;
          if (turfIds.isEmpty) {
            return const Center(child: Text("No turfs found for this owner."));
          }

          return StreamBuilder<QuerySnapshot>(
            stream: fetchBookingsStream(turfIds),
            builder: (context, bookingSnapshot) {
              if (!bookingSnapshot.hasData) return const Center(child: CircularProgressIndicator());

              final bookings = bookingSnapshot.data!.docs;

              if (bookings.isEmpty) {
                return const Center(child: Text("No bookings available."));
              }

              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final userName = booking['userName'] ?? 'Unknown';
                  final turfName = booking['turfName'] ?? 'N/A';
                  final slot = booking['slot'] ?? '';
                  final date = booking['date'] ?? '';
                  final status = booking['status'] ?? 'Confirmed';

                  return Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 3,
                    child: ListTile(
                      leading: const Icon(Icons.book_online, color: Colors.blue),
                      title: Text(userName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Turf: $turfName"),
                          Text("Slot: $slot"),
                          Text("Date: $date"),
                          Text("Status: $status"),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
