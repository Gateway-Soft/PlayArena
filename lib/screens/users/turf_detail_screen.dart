import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/common/turf_model.dart';
import '../../models/owners/slot_model.dart';
import '../../models/owners/owner_model.dart';
import '../../services/owners/slot_service.dart';

class TurfDetailScreen extends StatelessWidget {
  final TurfModel turf;
  final SlotService service = SlotService();

  TurfDetailScreen({super.key, required this.turf});

  /// 🔍 Fetch Owner Details
  Future<OwnerModel?> _fetchOwnerDetails(String ownerId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('owners').doc(ownerId).get();
      if (!doc.exists) return null;
      return OwnerModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      print("Error fetching owner: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(turf.name)),
      body: Column(
        children: [
          Image.network(
            turf.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
            const Center(child: Text("Image not available")),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 📌 Turf Basic Info
                  Text(turf.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 20),
                      const SizedBox(width: 5),
                      Expanded(child: Text(turf.location, style: const TextStyle(fontSize: 16))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (turf.description.isNotEmpty) ...[
                    const Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(turf.description, style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 8),
                  ],
                  const Text("Price per hour:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("₹${turf.price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 8),
                  const Text("Timings:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${turf.openingTime} - ${turf.closingTime}", style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 8),

                  /// 💼 Amenities
                  if (turf.amenities.isNotEmpty) ...[
                    const Text("Amenities:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8.0,
                      children: turf.amenities.map((a) => Chip(label: Text(a))).toList(),
                    ),
                    const SizedBox(height: 8),
                  ],

                  /// 👤 Owner Info
                  const Divider(thickness: 1),
                  const Text("Owner Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  FutureBuilder<OwnerModel?>(
                    future: _fetchOwnerDetails(turf.ownerId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return const Text("Owner info not available");
                      }
                      final owner = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name: ${owner.name}", style: const TextStyle(fontSize: 15)),
                          Text("Email: ${owner.email}", style: const TextStyle(fontSize: 15)),
                          Text("Mobile: ${owner.mobile}", style: const TextStyle(fontSize: 15)),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  ),

                  /// ⏱️ Slots Info
                  const Divider(thickness: 1),
                  const Text("Available Slots", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  StreamBuilder<List<SlotModel>>(
                    stream: service.streamSlotsForTurf(turf.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Text('Error loading slots');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("No slots available");
                      }

                      final availableSlots = snapshot.data!.where((slot) => !slot.isBooked).toList();
                      if (availableSlots.isEmpty) {
                        return const Text("No available slots right now.");
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: availableSlots.length,
                        itemBuilder: (context, index) {
                          final slot = availableSlots[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: const Icon(Icons.access_time),
                              title: Text("${slot.timeSlot} (${slot.time})"),
                              subtitle: Text(
                                slot.date != null
                                    ? DateFormat('dd MMM yyyy, hh:mm a').format(slot.date)
                                    : "Date not set",
                              ),
                              trailing: ElevatedButton(
                                onPressed: () async {
                                  final userId = FirebaseAuth.instance.currentUser?.uid;
                                  if (userId != null) {
                                    await service.bookSlot(slot.id, userId);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Slot Booked!")),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Please log in first")),
                                    );
                                  }
                                },
                                child: const Text("Book"),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
