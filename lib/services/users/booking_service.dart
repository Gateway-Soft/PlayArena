import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createBooking({
    required String turfId,
    required String userId,
    required String turfName,
    required DateTime date,
    required String timeSlot,
    required double price,
  }) async {
    try {
      final bookingId = _firestore.collection('bookings').doc().id;

      await _firestore.collection('bookings').doc(bookingId).set({
        'bookingId': bookingId,
        'turfId': turfId,
        'turfName': turfName,
        'userId': userId,
        'date': Timestamp.fromDate(date),
        'timeSlot': timeSlot,
        'price': price,
        'status': 'confirmed',
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      print('Error creating booking: $e');
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> getUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<Map<String, dynamic>>> getTurfBookings(String turfId) {
    return _firestore
        .collection('bookings')
        .where('turfId', isEqualTo: turfId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'cancelled',
      });
    } catch (e) {
      print('Error cancelling booking: $e');
      rethrow;
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).delete();
    } catch (e) {
      print('Error deleting booking: $e');
      rethrow;
    }
  }
}
