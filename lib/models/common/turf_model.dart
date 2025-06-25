class TurfModel {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final double pricePerHour;
  final String ownerId;

  TurfModel({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.pricePerHour,
    required this.ownerId,
  });

  factory TurfModel.fromMap(Map<String, dynamic> data, String id) {
    return TurfModel(
      id: id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      pricePerHour: (data['pricePerHour'] ?? 0).toDouble(),
      ownerId: data['ownerId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'pricePerHour': pricePerHour,
      'ownerId': ownerId,
    };
  }
}
