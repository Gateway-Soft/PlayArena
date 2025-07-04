import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../ providers/auth_provider.dart';


class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final nameController = TextEditingController();
  final locationController = TextEditingController();

  String name = '';
  String email = '';
  String photoUrl = '';
  File? newProfileImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    final data = doc.data();
    if (data != null) {
      setState(() {
        name = data['name'] ?? '';
        email = data['email'] ?? '';
        photoUrl = data['photoUrl'] ?? '';
        nameController.text = name;
        locationController.text = data['location'] ?? '';
      });
    }
  }

  Future<void> requestPermission() async {
    await [
      Permission.photos,
      Permission.mediaLibrary,
      Permission.storage,
    ].request();
  }

  Future<void> pickProfileImage() async {
    try {
      await requestPermission();
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => newProfileImage = File(picked.path));
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  Future<void> fetchCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location services are disabled.")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission permanently denied")),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        String address =
            "${place.name}, ${place.locality}, ${place.administrativeArea}";
        setState(() {
          locationController.text = address;
        });
      }
    } catch (e) {
      debugPrint("Location Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch location: $e")),
      );
    }
  }

  Future<void> updateProfile() async {
    if (user == null || nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name cannot be empty")),
      );
      return;
    }

    setState(() => isLoading = true);
    String uploadedUrl = photoUrl;

    try {
      if (newProfileImage != null) {
        final ref =
        FirebaseStorage.instance.ref().child('profile_photos/${user!.uid}.jpg');
        await ref.putFile(newProfileImage!);
        uploadedUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'name': nameController.text.trim(),
        'photoUrl': uploadedUrl,
        'location': locationController.text.trim(),
      });

      setState(() {
        photoUrl = uploadedUrl;
        name = nameController.text.trim();
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    } catch (e) {
      debugPrint("Upload error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update profile")),
      );
      setState(() => isLoading = false);
    }
  }

  Future<void> logout() async {
    await Provider.of<AppAuthProvider>(context, listen: false).signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/select-role', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: newProfileImage != null
                        ? FileImage(newProfileImage!)
                        : (photoUrl.isNotEmpty
                        ? NetworkImage(photoUrl)
                        : const AssetImage('assets/user_placeholder.png')
                    as ImageProvider),
                  ),
                  GestureDetector(
                    onTap: pickProfileImage,
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: email,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Email',
                suffixIcon: Tooltip(
                  message: 'Email can’t be edited',
                  child: Icon(Icons.lock),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Your Location',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.location_on, color: Colors.red),
                  tooltip: 'Fetch current location',
                  onPressed: fetchCurrentLocation,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save Changes"),
              onPressed: updateProfile,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: logout,
            ),
          ],
        ),
      ),
    );
  }
}
