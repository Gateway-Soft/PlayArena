import 'package:cloud_firestore/cloud_firestore.dart';

class OwnerModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String role;
  final DateTime createdAt;
  final String mobile; // ✅ Add this

  OwnerModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.role,
    required this.createdAt,
    required this.mobile,
  });

  factory OwnerModel.fromMap(Map<String, dynamic> data, String uid) {
    return OwnerModel(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      role: data['role'] ?? 'owner',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      mobile: data['mobile'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
      'mobile': mobile,
    };
  }
}
