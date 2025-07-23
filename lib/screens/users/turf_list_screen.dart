import 'package:flutter/material.dart';
import '../../models/common/turf_model.dart';
import '../../services/owners/turf_service.dart';
import 'turf_detail_screen.dart';

class TurfListScreen extends StatelessWidget {
  final TurfService service = TurfService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Turfs")),
      body: StreamBuilder<List<TurfModel>>(
        stream: service.getAllTurfsStream(), // ✅ real-time stream
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No turfs available.'));
          }

          final turfs = snapshot.data!;
          return ListView.builder(
            itemCount: turfs.length,
            itemBuilder: (context, index) {
              final turf = turfs[index];
              return ListTile(
                leading: Image.network(turf.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                title: Text(turf.name),
                subtitle: Text(turf.location),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TurfDetailScreen(turf: turf),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
