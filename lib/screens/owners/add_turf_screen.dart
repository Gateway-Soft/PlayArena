import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTurfScreen extends StatefulWidget {
  const AddTurfScreen({super.key});

  @override
  State<AddTurfScreen> createState() => _AddTurfScreenState();
}

class _AddTurfScreenState extends State<AddTurfScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;

  Future<void> addTurf() async {
    setState(() => isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      await FirebaseFirestore.instance.collection('turfs').add({
        'name': nameController.text.trim(),
        'location': locationController.text.trim(),
        'description': descriptionController.text.trim(),
        'ownerId': user.uid,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Turf added successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add turf: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Turf')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Turf Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add Turf"),
              onPressed: addTurf,
            ),
          ],
        ),
      ),
    );
  }
}
