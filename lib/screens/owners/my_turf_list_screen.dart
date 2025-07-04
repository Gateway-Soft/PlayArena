import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_turf_screen.dart';
import 'add_turf_screen.dart';

class MyTurfListScreen extends StatefulWidget {
  const MyTurfListScreen({super.key});

  @override
  State<MyTurfListScreen> createState() => _MyTurfListScreenState();
}

class _MyTurfListScreenState extends State<MyTurfListScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  Stream<QuerySnapshot> getTurfStream() {
    return FirebaseFirestore.instance
        .collection('turfs')
        .where('ownerId', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  void _navigateToEdit(String turfId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTurfScreen(turfId: turfId),
      ),
    );
  }

  void _deleteTurf(String turfId) async {
    await FirebaseFirestore.instance.collection('turfs').doc(turfId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Turf deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Turfs"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTurfScreen()),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getTurfStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final turfDocs = snapshot.data?.docs ?? [];

          if (turfDocs.isEmpty) {
            return const Center(child: Text("No turfs added yet."));
          }

          return ListView.builder(
            itemCount: turfDocs.length,
            itemBuilder: (context, index) {
              final turf = turfDocs[index];
              final turfId = turf.id;
              final data = turf.data() as Map<String, dynamic>;
              final name = data['name'] ?? 'Unknown Turf';
              final location = data['location'] ?? 'Unknown Location';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(name),
                  subtitle: Text(location),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _navigateToEdit(turfId),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTurf(turfId),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
