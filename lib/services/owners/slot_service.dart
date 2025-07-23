import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/owners/slot_model.dart';

class SlotService {
  final _firestore = FirebaseFirestore.instance;

  // Get all booked slots
  Future<List<SlotModel>> getAllBookedSlots() async {
    try {
      final snapshot = await _firestore.collection('slots').get();
      return snapshot.docs.map((doc) {
        return SlotModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching slots: $e');
      return [];
    }
  }

  // New: get available slots by turf ID
  Future<List<SlotModel>> getAvailableSlotsByTurf(String turfId) async {
    try {
      final snapshot = await _firestore
          .collection('slots')
          .where('turfId', isEqualTo: turfId)
          .where('isBooked', isEqualTo: false)
          .get();

      return snapshot.docs.map((doc) {
        return SlotModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching available slots: $e');
      return [];
    }
  }

  // Book slot
  Future<void> bookSlot(String slotId, String userId) async {
    await _firestore.collection('slots').doc(slotId).update({
      'isBooked': true,
      'userId': userId,
    });
  }

  // ✅ Add this: Get all slots (booked + available) by turf ID
  Future<List<SlotModel>> getSlotsForTurf(String turfId) async {
    try {
      final snapshot = await _firestore
          .collection('slots')
          .where('turfId', isEqualTo: turfId)
          .orderBy('date')
          .get();

      return snapshot.docs.map((doc) {
        return SlotModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching slots for turf $turfId: $e');
      return [];
    }
  }
}
