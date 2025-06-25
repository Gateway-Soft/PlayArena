import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../ providers/auth_provider.dart';
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String name = '';
  String email = '';
  String photoUrl = '';
  File? newProfileImage;
  final nameController = TextEditingController();
  bool isLoading = false;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

    setState(() {
      name = doc.data()?['name'] ?? '';
      email = doc.data()?['email'] ?? '';
      photoUrl = doc.data()?['photoUrl'] ?? '';
      nameController.text = name;
    });
  }

  Future<void> pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => newProfileImage = File(picked.path));
    }
  }

  Future<void> updateProfile() async {
    if (user == null) return;
    setState(() => isLoading = true);

    String uploadedUrl = photoUrl;

    if (newProfileImage != null) {
      final ref = FirebaseStorage.instance.ref().child('profile_photos/${user!.uid}.jpg');
      await ref.putFile(newProfileImage!);
      uploadedUrl = await ref.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'name': nameController.text.trim(),
      'photoUrl': uploadedUrl,
    });

    setState(() {
      photoUrl = uploadedUrl;
      name = nameController.text.trim();
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully")),
    );
  }

  void logout() async {
    await Provider.of<AppAuthProvider>(context, listen: false).signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/select-role', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickProfileImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: newProfileImage != null
                    ? FileImage(newProfileImage!)
                    : (photoUrl.isNotEmpty
                    ? NetworkImage(photoUrl)
                    : const AssetImage('assets/default_user.png') as ImageProvider),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.edit, size: 20),
                  ),
                ),
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
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save Changes"),
              onPressed: updateProfile,
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: logout,
            ),
          ],
        ),
      ),
    );
  }
}
