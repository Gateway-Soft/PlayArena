import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/common/turf_model.dart';


class TurfService {
  final CollectionReference turfCollection =
  FirebaseFirestore.instance.collection('turfs');

  // 🔹 Add a new Turf
  Future<void> addTurf(TurfModel turf) async {
    await turfCollection.doc(turf.id).set(turf.toMap());
  }

  // 🔹 Update existing Turf
  Future<void> updateTurf(String turfId, Map<String, dynamic> updatedData) async {
    await turfCollection.doc(turfId).update(updatedData);
  }

  // 🔹 Delete Turf
  Future<void> deleteTurf(String turfId) async {
    await turfCollection.doc(turfId).delete();
  }

  // 🔹 Get Turf by ID
  Future<TurfModel?> getTurfById(String turfId) async {
    final doc = await turfCollection.doc(turfId).get();
    if (doc.exists) {
      return TurfModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // 🔹 Stream All Turfs (for listing)
  Stream<List<TurfModel>> streamAllTurfs() {
    return turfCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TurfModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // 🔹 Get Turfs Owned by Specific Owner
  Future<List<TurfModel>> getTurfsByOwner(String ownerId) async {
    final snapshot = await turfCollection.where('ownerId', isEqualTo: ownerId).get();
    return snapshot.docs.map((doc) {
      return TurfModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
