import 'package:flutter/material.dart';

class TurfCard extends StatelessWidget {
  final Map<String, dynamic> turfData;

  const TurfCard({super.key, required this.turfData});

  @override
  Widget build(BuildContext context) {
    final String name = turfData['name'] ?? 'Turf Name';
    final String location = turfData['location'] ?? 'Unknown';
    final String imageUrl = turfData['imageUrl'] ?? '';

    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$name tapped")),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🖼 Turf Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset('assets/turf_sample.jpg', fit: BoxFit.cover),
                )
                    : Image.asset('assets/turf_sample.jpg', fit: BoxFit.cover),
              ),
            ),
            // 📄 Turf Name & Location
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
