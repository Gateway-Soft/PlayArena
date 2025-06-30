import 'package:cloud_firestore/cloud_firestore.dart';

class TurfModel {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final double pricePerHour;
  final String ownerId;
  final DateTime createdAt;

  TurfModel({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.pricePerHour,
    required this.ownerId,
    required this.createdAt,
  });

  factory TurfModel.fromMap(Map<String, dynamic> data, String id) {
    return TurfModel(
      id: id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      pricePerHour: (data['pricePerHour'] ?? 0).toDouble(),
      ownerId: data['ownerId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'pricePerHour': pricePerHour,
      'ownerId': ownerId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
