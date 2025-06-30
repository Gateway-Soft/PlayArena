import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/common/turf_model.dart';

class TurfService {
  final CollectionReference turfCollection =
  FirebaseFirestore.instance.collection('turfs');

  Future<void> addTurf(TurfModel turf) async {
    try {
      await turfCollection.doc(turf.id).set(turf.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('Error adding turf: $e');
      rethrow;
    }
  }

  Future<void> updateTurf(String turfId, Map<String, dynamic> updatedData) async {
    try {
      await turfCollection.doc(turfId).update(updatedData);
    } catch (e) {
      print('Error updating turf: $e');
      rethrow;
    }
  }

  Future<void> deleteTurf(String turfId) async {
    try {
      await turfCollection.doc(turfId).delete();
    } catch (e) {
      print('Error deleting turf: $e');
      rethrow;
    }
  }

  Future<TurfModel?> getTurfById(String turfId) async {
    final doc = await turfCollection.doc(turfId).get();
    if (doc.exists) {
      return TurfModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Stream<List<TurfModel>> streamAllTurfs() {
    return turfCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TurfModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<List<TurfModel>> getTurfsByOwner(String ownerId) async {
    final snapshot =
    await turfCollection.where('ownerId', isEqualTo: ownerId).get();
    return snapshot.docs.map((doc) {
      return TurfModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
