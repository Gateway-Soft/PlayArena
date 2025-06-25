import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../ providers/auth_provider.dart';
import '../../widgets/ users/turf_card.dart';
import '../../widgets/common/custom_drawer.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String userName = '';
  String userEmail = '';
  String photoUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        userName = doc.data()?['name'] ?? 'User';
        userEmail = doc.data()?['email'] ?? '';
        photoUrl = doc.data()?['photoUrl'] ?? '';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlayArena'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(
        userName: userName,
        userEmail: userEmail,
        userPhotoUrl: photoUrl.isNotEmpty
            ? photoUrl
            : 'https://via.placeholder.com/150',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to PlayArena 👋',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nearby Turfs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: List.generate(6, (index) {
                  return TurfCard(index: index);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
