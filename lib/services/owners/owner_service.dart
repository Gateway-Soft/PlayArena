import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/common/turf_model.dart';
import '../../models/owners/owner_model.dart';

class OwnerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔍 Fetch turfs created by owner
  Future<List<TurfModel>> fetchOwnerTurfs(String ownerId) async {
    try {
      final snapshot = await _firestore
          .collection('turfs')
          .where('ownerId', isEqualTo: ownerId)
          .get();

      return snapshot.docs.map((doc) {
        return TurfModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception("Error fetching turfs: $e");
    }
  }

  /// 💾 Save or update turf (used in owner UI)
  Future<void> saveTurf(TurfModel turf) async {
    try {
      await _firestore.collection('turfs').doc(turf.id).set(turf.toMap());
    } catch (e) {
      throw Exception("Failed to save turf: $e");
    }
  }

  /// ❌ Delete a turf
  Future<void> deleteTurf(String turfId) async {
    try {
      await _firestore.collection('turfs').doc(turfId).delete();
    } catch (e) {
      throw Exception("Failed to delete turf: $e");
    }
  }

  /// 👤 Fetch owner details
  Future<OwnerModel> getOwnerById(String ownerId) async {
    try {
      final doc = await _firestore.collection('owners').doc(ownerId).get();
      if (!doc.exists) throw Exception("Owner not found");
      return OwnerModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw Exception("Failed to fetch owner: $e");
    }
  }
}
