import 'package:flutter/material.dart';
import '../../screens/users/turf_detail_screen.dart';

class TurfCard extends StatelessWidget {
  final Map<String, dynamic> turfData;
  final String turfId;

  const TurfCard({super.key, required this.turfData, required this.turfId});

  @override
  Widget build(BuildContext context) {
    final String name = turfData['name'] ?? 'Turf Name';
    final String location = turfData['location'] ?? 'Unknown';
    final String imageUrl = turfData['imageUrl'] ?? '';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TurfDetailScreen(
                turfId: turfId,
                turfData: turfData,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Image.asset('assets/turf_sample.jpg', fit: BoxFit.cover),
                )
                    : Image.asset('assets/turf_sample.jpg', fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
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
