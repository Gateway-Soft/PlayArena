class BookingModel {
  final String id;
  final String turfId;
  final String turfName;
  final String userId;
  final String userName;
  final DateTime startTime;
  final DateTime endTime;
  final int amountPaid;
  final String status; // e.g., "confirmed", "pending", etc.

  BookingModel({
    required this.id,
    required this.turfId,
    required this.turfName,
    required this.userId,
    required this.userName,
    required this.startTime,
    required this.endTime,
    required this.amountPaid,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'turfId': turfId,
      'turfName': turfName,
      'userId': userId,
      'userName': userName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'amountPaid': amountPaid,
      'status': status,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] ?? '',
      turfId: map['turfId'] ?? '',
      turfName: map['turfName'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      amountPaid: map['amountPaid'] ?? 0,
      status: map['status'] ?? 'pending',
    );
  }
}
