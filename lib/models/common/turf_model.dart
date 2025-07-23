class TurfModel {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final String description;
  final double pricePerHour;
  final List<String> amenities;
  final String openingTime;
  final String closingTime;
  final double price; // 👈 new
  final String phone; // 👈 new
  final String ownerId;

  TurfModel({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.description,
    required this.pricePerHour,
    required this.amenities,
    required this.openingTime,
    required this.closingTime,
    required this.price,
    required this.phone,
    required this.ownerId,
  });

  factory TurfModel.fromMap(Map<String, dynamic> map, String docId) {
    return TurfModel(
      id: docId,
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      pricePerHour: (map['pricePerHour'] ?? 0).toDouble(),
      amenities: List<String>.from(map['amenities'] ?? []),
      openingTime: map['openingTime'] ?? '',
      closingTime: map['closingTime'] ?? '',
      ownerId: map['ownerId'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      phone: map['phone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'description': description,
      'pricePerHour': pricePerHour,
      'amenities': amenities,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'ownerId': ownerId,
      'price': price,
      'phone': phone,
    };
  }
}
