import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OwnerProvider extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _photoUrl = '';
  String _role = 'owner';
  String _uid = '';

  String get name => _name;
  String get email => _email;
  String get photoUrl => _photoUrl;
  String get role => _role;
  String get uid => _uid;

  Future<void> fetchOwnerData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _uid = user.uid;
      final doc = await FirebaseFirestore.instance.collection('owners').doc(_uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _name = data['name'] ?? '';
        _email = data['email'] ?? '';
        _photoUrl = data['photoUrl'] ?? '';
        _role = data['role'] ?? 'owner';
        notifyListeners();
      }
    }
  }

  void clearOwnerData() {
    _name = '';
    _email = '';
    _photoUrl = '';
    _uid = '';
    _role = 'owner';
    notifyListeners();
  }
}
