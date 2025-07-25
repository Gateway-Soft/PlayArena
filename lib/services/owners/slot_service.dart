// services/owners/slot_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/owners/slot_model.dart';

class SlotService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all booked slots (optional admin view)
  Future<List<SlotModel>> getAllBookedSlots() async {
    try {
      final snapshot = await _db.collection('slots').get();
      return snapshot.docs.map((doc) => SlotModel.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      print('Error fetching booked slots: $e');
      return [];
    }
  }

  // 🔹 Get only available slots for user to book
  Future<List<SlotModel>> getAvailableSlotsByTurf(String turfId) async {
    try {
      final snapshot = await _db
          .collection('slots')
          .where('turfId', isEqualTo: turfId)
          .where('isBooked', isEqualTo: false)
          .orderBy('date')
          .get();

      return snapshot.docs.map((doc) => SlotModel.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      print('Error fetching available slots: $e');
      return [];
    }
  }

  // 🔹 Book a slot
  Future<void> bookSlot(String slotId, String userId) async {
    try {
      await _db.collection('slots').doc(slotId).update({
        'isBooked': true,
        'userId': userId,
      });
    } catch (e) {
      print('Error booking slot: $e');
    }
  }

  // 🔹 Fetch all slots (booked + available) for specific turf
  Future<List<SlotModel>> getSlotsForTurf(String turfId) async {
    try {
      final snapshot = await _db
          .collection('slots')
          .where('turfId', isEqualTo: turfId)
          .orderBy('date')
          .get();

      return snapshot.docs.map((doc) => SlotModel.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      print('Error fetching slots: $e');
      return [];
    }
  }

  // 🔹 Real-time stream of slot updates
  Stream<List<SlotModel>> streamSlotsForTurf(String turfId) {
    return _db
        .collection('slots')
        .where('turfId', isEqualTo: turfId)
        .orderBy('date')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => SlotModel.fromMap(doc.data(), doc.id)).toList());
  }

  // 🔹 Optional real-time fetcher
  Stream<List<SlotModel>> getSlotsByTurfId(String turfId) {
    return _db
        .collection('slots')
        .where('turfId', isEqualTo: turfId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => SlotModel.fromMap(doc.data(), doc.id)).toList());
  }
}
