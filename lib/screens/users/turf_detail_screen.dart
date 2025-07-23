import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/common/turf_model.dart';
import '../../models/owners/slot_model.dart';
import '../../services/owners/slot_service.dart';

class TurfDetailScreen extends StatelessWidget {
  final TurfModel turf;
  final SlotService service = SlotService();

  TurfDetailScreen({super.key, required this.turf});

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
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      turf.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 20),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            turf.location,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    /// 📝 Description
                    if (turf.description.isNotEmpty) ...[
                      const Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(turf.description, style: const TextStyle(fontSize: 15)),
                      const SizedBox(height: 8),
                    ],

                    /// 💰 Pricing
                    const Text("Price per hour:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("₹${turf.price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 8),

                    /// 📞 Contact
                    const Text("Contact:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(turf.phone, style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 8),

                    /// ⏰ Timing
                    const Text("Timings:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("${turf.openingTime} - ${turf.closingTime}", style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 8),

                    /// ⚙️ Amenities
                    if (turf.amenities.isNotEmpty) ...[
                      const Text("Amenities:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 8.0,
                        children: turf.amenities.map((amenity) => Chip(label: Text(amenity))).toList(),
                      ),
                      const SizedBox(height: 8),
                    ],

                    const Divider(thickness: 1),
                    const Text("Available Slots", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    /// 🕓 Slots
                    FutureBuilder<List<SlotModel>>(
                      future: service.getSlotsForTurf(turf.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Text('Error loading slots');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text("No slots available");
                        }

                        final slots = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: slots.length,
                          itemBuilder: (context, index) {
                            final slot = slots[index];
                            final isBooked = slot.userId != null;

                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: const Icon(Icons.timer),
                                title: Text(slot.timeSlot),
                                subtitle: Text(DateFormat('dd MMM yyyy').format(slot.date)),
                                trailing: isBooked
                                    ? const Text("Booked", style: TextStyle(color: Colors.red))
                                    : ElevatedButton(
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
          ),
        ],
      ),
    );
  }
}
