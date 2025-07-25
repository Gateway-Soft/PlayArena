import 'package:cloud_firestore/cloud_firestore.dart';

class SlotModel {
  final String id;
  final String turfId;
  final String turfName;
  final String timeSlot; // e.g., "Evening"
  final String time;     // e.g., "17:00"
  final DateTime date;
  final String userId;
  final bool isBooked;

  SlotModel({
    required this.id,
    required this.turfId,
    required this.turfName,
    required this.timeSlot,
    required this.time,
    required this.date,
    required this.userId,
    required this.isBooked,
  });

  /// 🔄 Deserialize from Firestore
  factory SlotModel.fromMap(Map<String, dynamic> map, String id) {
    return SlotModel(
      id: id,
      turfId: map['turfId'] ?? '',
      turfName: map['turfName'] ?? '',
      timeSlot: map['timeSlot'] ?? '',
      time: map['time'] ?? '',
      date: map['date'] != null
          ? (map['date'] is Timestamp
          ? (map['date'] as Timestamp).toDate()
          : DateTime.tryParse(map['date'].toString()) ?? DateTime.now())
          : DateTime.now(),
      userId: map['userId'] ?? '',
      isBooked: map['isBooked'] ?? false,
    );
  }

  /// 🔁 Serialize to Firestore
  Map<String, dynamic> toMap() {
    return {
      'turfId': turfId,
      'turfName': turfName,
      'timeSlot': timeSlot,
      'time': time,
      'date': date,
      'userId': userId,
      'isBooked': isBooked,
    };
  }
}
