import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseStorageService {
  final storage = FirebaseStorage.instance;
  final picker = ImagePicker();

  // 🔽 Pick image and upload
  Future<String?> uploadProfileImage({required bool isOwner}) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final path = isOwner ? 'owners/$uid/profile.jpg' : 'users/$uid/profile.jpg';
    final ref = storage.ref().child(path);

    final file = File(pickedFile.path);
    await ref.putFile(file);

    return await ref.getDownloadURL(); // 🔁 Return image URL
  }
}
