import 'package:flutter/material.dart';

class TurfDetailScreen extends StatelessWidget {
  const TurfDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Turf Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("PlayArena Turf", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Location: Chennai"),
            Text("Rating: 4.5 ⭐"),
            SizedBox(height: 16),
            Text("Description: Well maintained turf ideal for football and cricket."),
          ],
        ),
      ),
    );
  }
}
