import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../models/common/turf_model.dart';

class FirebaseTurfService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  Future<String> uploadTurfImage(File file) async {
    final ref = _storage.ref().child("turfs/${_uuid.v4()}.jpg");
    final uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> saveTurfDetails(TurfModel turf) async {
    await _firestore.collection('turfs').doc(turf.id).set(turf.toMap());
  }
}
