class SlotModel {
  final String id;
  final String turfId;
  final String turfName;
  final String timeSlot; // e.g., "Evening Batch"
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

  factory SlotModel.fromMap(Map<String, dynamic> map, String id) {
    return SlotModel(
      id: id,
      turfId: map['turfId'] ?? '',
      turfName: map['turfName'] ?? '',
      timeSlot: map['timeSlot'] ?? '',
      time: map['time'] ?? '',
      date: map['date'] != null
          ? DateTime.tryParse(map['date']) ?? DateTime.now()
          : DateTime.now(),
      userId: map['userId'] ?? '',
      isBooked: map['isBooked'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'turfId': turfId,
      'turfName': turfName,
      'timeSlot': timeSlot,
      'time': time,
      'date': date.toIso8601String(),
      'userId': userId,
      'isBooked': isBooked,
    };
  }
}
