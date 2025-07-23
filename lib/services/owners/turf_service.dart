import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/common/turf_model.dart';

class TurfService {
  final _db = FirebaseFirestore.instance;

  /// Create a new turf document (used by owner/admin)
  Future<void> createTurf(TurfModel turf) async {
    await _db.collection('turfs').add(turf.toMap());
  }

  /// Get all turfs once (for non-realtime usage)
  Future<List<TurfModel>> fetchAllTurfs() async {
    final snapshot = await _db.collection('turfs').get();
    return snapshot.docs
        .map((doc) => TurfModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Get all turfs as a real-time stream (for StreamBuilder)
  Stream<List<TurfModel>> getAllTurfsStream() {
    return _db.collection('turfs').snapshots().map(
          (snapshot) {
        return snapshot.docs.map(
              (doc) => TurfModel.fromMap(doc.data(), doc.id),
        ).toList();
      },
    );
  }

  /// Get a single turf by ID
  Future<TurfModel> fetchTurfById(String turfId) async {
    final doc = await _db.collection('turfs').doc(turfId).get();
    if (!doc.exists) throw Exception('Turf not found');
    return TurfModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  /// Update turf (optional utility for admin usage)
  Future<void> updateTurf(String turfId, TurfModel turf) async {
    await _db.collection('turfs').doc(turfId).update(turf.toMap());
  }

  /// Delete turf (optional utility for admin usage)
  Future<void> deleteTurf(String turfId) async {
    await _db.collection('turfs').doc(turfId).delete();
  }
}
