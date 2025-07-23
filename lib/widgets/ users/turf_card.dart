import 'package:flutter/material.dart';
import '../../models/common/turf_model.dart';
import '../../screens/users/turf_detail_screen.dart';

class TurfCard extends StatelessWidget {
  final Map<String, dynamic> turfData;
  final String turfId;

  const TurfCard({
    Key? key,
    required this.turfData,
    required this.turfId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final turf = TurfModel.fromMap(turfData, turfId);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TurfDetailScreen(turf: turf),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Force a consistent image size
            SizedBox(
              height: 100,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: turf.imageUrl.isNotEmpty
                    ? Image.network(
                  turf.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Image.asset('assets/turf_sample.jpg', fit: BoxFit.cover),
                )
                    : Image.asset('assets/turf_sample.jpg', fit: BoxFit.cover),
              ),
            ),

            // Wrap text area in Expanded + padding
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      turf.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      turf.location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
