import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../widgets/ users/turf_card.dart';
import '../../widgets/ users/user_custom_drawer.dart';
import '../../theme/theme_provider.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String userName = '';
  String userEmail = '';
  String photoUrl = '';
  String searchQuery = '';
  String selectedCategory = '';
  String currentLocation = 'Your Location';

  final List<String> categories = ['Football', 'Cricket', 'Volleyball', 'Tennis', 'Hockey'];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _detectLocation();
  }

  Future<void> _loadUserInfo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        userName = doc['name'] ?? 'User';
        userEmail = doc['email'] ?? '';
        photoUrl = doc['photoUrl'] ?? '';
        currentLocation = doc['location'] ?? 'Your Location';
      });
    }
  }

  Future<void> _detectLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      String place = 'Unknown';
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        place = "${p.locality}, ${p.administrativeArea}";
      }

      setState(() => currentLocation = place);
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({'location': place});
      }
    } catch (e) {
      print("Location error: $e");
    }
  }

  Future<void> _enterManualLocation() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter Your Location"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'E.g. Karaikudi'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid != null) {
                await FirebaseFirestore.instance.collection('users').doc(uid).update({
                  'location': controller.text,
                });
              }
              setState(() {
                currentLocation = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showLocationOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.gps_fixed),
            title: const Text('Detect Automatically'),
            onTap: () {
              Navigator.pop(context);
              _detectLocation();
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_location_alt),
            title: const Text('Enter Manually'),
            onTap: () {
              Navigator.pop(context);
              _enterManualLocation();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PlayArena"),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on, color: Colors.white),
            tooltip: 'Update Location',
            onPressed: _showLocationOptions,
          ),
        ],
      ),
      drawer: CustomDrawer(userName: userName, userEmail: userEmail, userPhotoUrl: photoUrl),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome, $userName 👋", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("\u{1F4CD} $currentLocation", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search turfs...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => setState(() => searchQuery = val.toLowerCase()),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories.map((sport) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(sport),
                      selected: selectedCategory == sport,
                      onSelected: (_) => setState(() {
                        selectedCategory = selectedCategory == sport ? '' : sport;
                      }),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('turfs').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final turfs = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = (data['name'] ?? '').toLowerCase();
                    final location = (data['location'] ?? '').toLowerCase();
                    final category = (data['category'] ?? '').toLowerCase();
                    return (name.contains(searchQuery) || location.contains(searchQuery)) &&
                        (selectedCategory.isEmpty || category == selectedCategory.toLowerCase());
                  }).toList();

                  if (turfs.isEmpty) return const Center(child: Text('No turfs found.'));

                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: turfs.map((doc) {
                      final turfData = doc.data() as Map<String, dynamic>;
                      final turfId = doc.id;
                      return TurfCard(turfData: turfData, turfId: turfId);
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
