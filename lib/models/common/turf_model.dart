class TurfModel {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final String openTime;
  final String closeTime;
  final int pricePerHour;
  final int maxPlayers;
  final String ownerId;
  final List<String> availableSlots;

  TurfModel({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.openTime,
    required this.closeTime,
    required this.pricePerHour,
    required this.maxPlayers,
    required this.ownerId,
    required this.availableSlots,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'openTime': openTime,
      'closeTime': closeTime,
      'pricePerHour': pricePerHour,
      'maxPlayers': maxPlayers,
      'ownerId': ownerId,
      'availableSlots': availableSlots,
    };
  }

  factory TurfModel.fromMap(Map<String, dynamic> map) {
    return TurfModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      openTime: map['openTime'] ?? '',
      closeTime: map['closeTime'] ?? '',
      pricePerHour: map['pricePerHour'] ?? 0,
      maxPlayers: map['maxPlayers'] ?? 0,
      ownerId: map['ownerId'] ?? '',
      availableSlots: List<String>.from(map['availableSlots'] ?? []),
    );
  }
}