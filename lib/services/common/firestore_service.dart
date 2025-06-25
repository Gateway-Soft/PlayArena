import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Save user data
  Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
    required String role,
    String photoUrl = '',
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'role': role,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  // 🔹 Save owner data
  Future<void> saveOwner({
    required String uid,
    required String name,
    required String email,
    required String role,
    String photoUrl = '',
  }) async {
    await _firestore.collection('owners').doc(uid).set({
      'name': name,
      'email': email,
      'role': role,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  // 🔹 Get user document
  Future<DocumentSnapshot> getUser(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  // 🔹 Get owner document
  Future<DocumentSnapshot> getOwner(String uid) async {
    return await _firestore.collection('owners').doc(uid).get();
  }

  // 🔹 Update profile fields
  Future<void> updateUserProfile(String uid, Map<String, dynamic> updates) async {
    await _firestore.collection('users').doc(uid).update(updates);
  }

  Future<void> updateOwnerProfile(String uid, Map<String, dynamic> updates) async {
    await _firestore.collection('owners').doc(uid).update(updates);
  }

  // 🔹 Fetch all turfs (for home screen listing)
  Stream<List<Map<String, dynamic>>> getAllTurfs() {
    return _firestore.collection('turfs').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList());
  }
}
