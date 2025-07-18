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

  List<String> selectedSlots = [];

  final List<String> slotOptions = [
    "06:00 AM", "07:00 AM", "08:00 AM",
    "09:00 AM", "10:00 AM", "11:00 AM",
    "12:00 PM", "01:00 PM", "02:00 PM",
    "03:00 PM", "04:00 PM", "05:00 PM",
    "06:00 PM", "07:00 PM", "08:00 PM", "09:00 PM"
  ];

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      final fileSize = await file.length();
      if (fileSize > 2 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image too large. Max 2MB allowed.")),
        );
        return;
      }
      setState(() => turfImage = file);
    }
  }

  Future<void> uploadTurf() async {
    if (!_formKey.currentState!.validate() ||
        turfImage == null ||
        openTime == null ||
        closeTime == null ||
        selectedSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required.")),
      );
      return;
    }

    if (_compareTimes(openTime!, closeTime!) >= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Open time must be before close time.")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final imageRef = FirebaseStorage.instance
          .ref()
          .child('turf_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await imageRef.putFile(turfImage!);
      final imageUrl = await imageRef.getDownloadURL();

      final turfDoc = FirebaseFirestore.instance.collection('turfs').doc();

      await turfDoc.set({
        'id': turfDoc.id,
        'ownerId': uid,
        'name': nameController.text.trim(),
        'location': locationController.text.trim(),
        'pricePerHour': int.parse(priceController.text.trim()),
        'maxPlayers': int.parse(maxPlayersController.text.trim()),
        'openTime': openTime!.format(context),
        'closeTime': closeTime!.format(context),
        'imageUrl': imageUrl,
        'availableSlots': selectedSlots,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Turf added successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  int _compareTimes(TimeOfDay t1, TimeOfDay t2) {
    return t1.hour * 60 + t1.minute - (t2.hour * 60 + t2.minute);
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

  Widget buildSlotSelector() {
    return Wrap(
      spacing: 10,
      children: slotOptions.map((slot) {
        final isSelected = selectedSlots.contains(slot);
        return FilterChip(
          label: Text(slot),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                selectedSlots.add(slot);
              } else {
                selectedSlots.remove(slot);
              }
            });
          },
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    priceController.dispose();
    maxPlayersController.dispose();
    super.dispose();
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
                validator: (val) =>
                val == null || val.isEmpty ? "Enter turf name" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (val) =>
                val == null || val.isEmpty ? "Enter location" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price per hour"),
                validator: (val) {
                  if (val == null || val.isEmpty) return "Enter price";
                  if (int.tryParse(val) == null) return "Enter a valid number";
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: maxPlayersController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Max Players"),
                validator: (val) {
                  if (val == null || val.isEmpty) return "Enter max players";
                  if (int.tryParse(val) == null) return "Enter a valid number";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => pickTime(true),
                      child: Text(openTime != null
                          ? "Open: ${openTime!.format(context)}"
                          : "Pick Open Time"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => pickTime(false),
                      child: Text(closeTime != null
                          ? "Close: ${closeTime!.format(context)}"
                          : "Pick Close Time"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Select Available Slots:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              buildSlotSelector(),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: uploadTurf,
                icon: const Icon(Icons.save),
                label: const Text("Add Turf"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}