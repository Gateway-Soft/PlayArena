import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditTurfScreen extends StatefulWidget {
  final String turfId; // Required to identify which turf to edit

  const EditTurfScreen({super.key, required this.turfId});

  @override
  State<EditTurfScreen> createState() => _EditTurfScreenState();
}

class _EditTurfScreenState extends State<EditTurfScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTurfDetails();
  }

  Future<void> loadTurfDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('turfs')
          .doc(widget.turfId)
          .get();

      final data = doc.data();
      if (data != null) {
        nameController.text = data['name'] ?? '';
        locationController.text = data['location'] ?? '';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading turf: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> updateTurf() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await FirebaseFirestore.instance.collection('turfs').doc(widget.turfId).update({
        'name': nameController.text.trim(),
        'location': locationController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Turf updated successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Turf")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Turf Name"),
                validator: (value) =>
                value == null || value.isEmpty ? "Please enter a turf name" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (value) =>
                value == null || value.isEmpty ? "Please enter a location" : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: updateTurf,
                icon: const Icon(Icons.save),
                label: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
