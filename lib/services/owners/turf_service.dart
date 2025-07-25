import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/common/turf_model.dart';

class TurfService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🔹 Create a new turf document (Owner/Admin use only)
  Future<void> createTurf(TurfModel turf) async {
    await _db.collection('turfs').add(turf.toMap());
  }

  /// 🔹 Get all turfs at once (Non-realtime usage)
  Future<List<TurfModel>> fetchAllTurfs() async {
    try {
      final snapshot = await _db.collection('turfs').get();
      return snapshot.docs.map((doc) {
        return TurfModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching turfs: $e');
    }
  }

  /// 🔹 Get all turfs in realtime (Use in StreamBuilder)
  Stream<List<TurfModel>> getAllTurfsStream() {
    return _db.collection('turfs').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TurfModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// 🔹 Get single turf by ID (for detail screen)
  Future<TurfModel> fetchTurfById(String turfId) async {
    try {
      final doc = await _db.collection('turfs').doc(turfId).get();
      if (!doc.exists) throw Exception('Turf not found');
      return TurfModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to fetch turf: $e');
    }
  }

  /// 🔹 Update turf (Admin/Owner feature)
  Future<void> updateTurf(String turfId, TurfModel turf) async {
    await _db.collection('turfs').doc(turfId).update(turf.toMap());
  }

  /// 🔹 Delete turf (Admin/Owner feature)
  Future<void> deleteTurf(String turfId) async {
    await _db.collection('turfs').doc(turfId).delete();
  }
}
