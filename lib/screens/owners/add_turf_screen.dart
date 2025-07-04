import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTurfScreen extends StatefulWidget {
  const AddTurfScreen({super.key});

  @override
  State<AddTurfScreen> createState() => _AddTurfScreenState();
}

class _AddTurfScreenState extends State<AddTurfScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final priceController = TextEditingController();
  final maxPlayersController = TextEditingController();
  TimeOfDay? openTime;
  TimeOfDay? closeTime;
  File? turfImage;
  bool isLoading = false;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => turfImage = File(picked.path));
    }
  }

  Future<void> uploadTurf() async {
    if (!_formKey.currentState!.validate() || turfImage == null || openTime == null || closeTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All fields required")));
      return;
    }

    setState(() => isLoading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final imageRef = FirebaseStorage.instance.ref().child('turf_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await imageRef.putFile(turfImage!);
      final imageUrl = await imageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('turfs').add({
        'ownerId': uid,
        'name': nameController.text.trim(),
        'location': locationController.text.trim(),
        'pricePerHour': int.parse(priceController.text.trim()),
        'maxPlayers': int.parse(maxPlayersController.text.trim()),
        'openTime': openTime!.format(context),
        'closeTime': closeTime!.format(context),
        'imageUrl': imageUrl,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Turf added successfully")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> pickTime(bool isOpenTime) async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        if (isOpenTime) openTime = picked;
        else closeTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Turf")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: turfImage != null
                    ? Image.file(turfImage!, height: 150, fit: BoxFit.cover)
                    : Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(child: Text("Tap to upload turf image")),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Turf Name"),
                validator: (val) => val == null || val.isEmpty ? "Enter turf name" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (val) => val == null || val.isEmpty ? "Enter location" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price per hour"),
                validator: (val) => val == null || val.isEmpty ? "Enter price" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: maxPlayersController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Max Players per slot"),
                validator: (val) => val == null || val.isEmpty ? "Enter max players" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => pickTime(true),
                      child: Text(openTime != null ? "Open: ${openTime!.format(context)}" : "Pick Open Time"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => pickTime(false),
                      child: Text(closeTime != null ? "Close: ${closeTime!.format(context)}" : "Pick Close Time"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: uploadTurf,
                icon: const Icon(Icons.save),
                label: const Text("Add Turf"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
