import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SlotManagementScreen extends StatefulWidget {
  const SlotManagementScreen({super.key});

  @override
  State<SlotManagementScreen> createState() => _SlotManagementScreenState();
}

class _SlotManagementScreenState extends State<SlotManagementScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final slotController = TextEditingController();
  String? selectedTurfId;

  Future<List<Map<String, dynamic>>> fetchOwnerTurfs() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('turfs')
        .where('ownerId', isEqualTo: currentUser!.uid)
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'],
      };
    }).toList();
  }

  Stream<QuerySnapshot> getSlotStream(String turfId) {
    return FirebaseFirestore.instance
        .collection('turfs')
        .doc(turfId)
        .collection('slots')
        .orderBy('time')
        .snapshots();
  }

  Future<void> addSlot(String time) async {
    if (selectedTurfId == null || time.isEmpty) return;
    final slotRef = FirebaseFirestore.instance
        .collection('turfs')
        .doc(selectedTurfId)
        .collection('slots');

    await slotRef.add({'time': time});
    slotController.clear();
  }

  Future<void> deleteSlot(String slotId) async {
    await FirebaseFirestore.instance
        .collection('turfs')
        .doc(selectedTurfId)
        .collection('slots')
        .doc(slotId)
        .delete();
  }

  @override
  void dispose() {
    slotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Slot Management"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchOwnerTurfs(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final turfs = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  hint: const Text("Select Turf"),
                  value: selectedTurfId,
                  items: turfs.map((turf) {
                    return DropdownMenuItem<String>(
                      value: turf['id'],
                      child: Text(turf['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedTurfId = value);
                  },
                ),
                const SizedBox(height: 20),

                if (selectedTurfId != null) ...[
                  TextField(
                    controller: slotController,
                    decoration: InputDecoration(
                      labelText: "Enter Slot Time (e.g. 5:00 PM - 6:00 PM)",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => addSlot(slotController.text.trim()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: getSlotStream(selectedTurfId!),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                        final slots = snapshot.data!.docs;

                        if (slots.isEmpty) return const Text("No slots added yet.");

                        return ListView.builder(
                          itemCount: slots.length,
                          itemBuilder: (context, index) {
                            final slot = slots[index];
                            final time = slot['time'];
                            return ListTile(
                              title: Text(time),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteSlot(slot.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
