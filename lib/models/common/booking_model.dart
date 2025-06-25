import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String bookingId;
  final String userId;
  final String userName;
  final String turfId;
  final String turfName;
  final DateTime bookingDate;
  final DateTime startTime;
  final DateTime endTime;
  final String timeSlot;
  final double amountPaid;
  final String status;

  BookingModel({
    required this.bookingId,
    required this.userId,
    required this.userName,
    required this.turfId,
    required this.turfName,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.timeSlot,
    required this.amountPaid,
    required this.status,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map, String id) {
    return BookingModel(
      bookingId: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      turfId: map['turfId'] ?? '',
      turfName: map['turfName'] ?? '',
      bookingDate: (map['bookingDate'] as Timestamp).toDate(),
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      timeSlot: map['timeSlot'] ?? '',
      amountPaid: (map['amountPaid'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'turfId': turfId,
      'turfName': turfName,
      'bookingDate': bookingDate,
      'startTime': startTime,
      'endTime': endTime,
      'timeSlot': timeSlot,
      'amountPaid': amountPaid,
      'status': status,
    };
  }
}
