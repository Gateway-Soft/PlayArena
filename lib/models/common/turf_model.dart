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
    };
  }
}
