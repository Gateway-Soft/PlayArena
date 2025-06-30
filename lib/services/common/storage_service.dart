import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfilePhoto(String uid, File file) async {
    final ref = _storage.ref().child('profile_pictures').child('$uid.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<String> uploadTurfImage(String turfId, File file) async {
    final ref = _storage.ref().child('turfs').child('$turfId.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> deleteProfilePhoto(String uid) async {
    final ref = _storage.ref().child('profile_pictures').child('$uid.jpg');
    await ref.delete();
  }
}
