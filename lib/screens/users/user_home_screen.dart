import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // ✅ for reverse geocoding
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
  String searchQuery = '';
  String selectedCategory = '';
  String currentLocation = 'Your Location';

  final List<String> categories = ['Football', 'Cricket', 'Volleyball', 'Tennis', 'Hockey'];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _detectLocation(); // 🌍 Auto detect location
  }

  Future<void> _loadUserInfo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        userName = doc.data()?['name'] ?? 'User';
        userEmail = doc.data()?['email'] ?? '';
        photoUrl = doc.data()?['photoUrl'] ?? '';
        currentLocation = doc.data()?['location'] ?? 'Your Location';
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
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // ✅ Reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String place = 'Unknown Location';
      if (placemarks.isNotEmpty) {
        final Placemark p = placemarks.first;
        place = [
          if (p.subLocality != null && p.subLocality!.isNotEmpty) p.subLocality,
          if (p.locality != null && p.locality!.isNotEmpty) p.locality,
          if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty) p.administrativeArea,
        ].where((e) => e != null && e!.isNotEmpty).map((e) => e!).join(', ');
      }

      setState(() {
        currentLocation = place;
      });

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'location': place,
        });
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
          decoration: const InputDecoration(hintText: 'E.g. Chennai'),
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
        title: const Text('PlayArena'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(
        userName: userName,
        userEmail: userEmail,
        userPhotoUrl: photoUrl.isNotEmpty ? photoUrl : 'https://via.placeholder.com/150',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎉 Welcome + Location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Welcome to PlayArena 👋',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.location_on_outlined),
                  onPressed: _showLocationOptions,
                  tooltip: 'Update Location',
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(currentLocation, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 16),
            const Text('Nearby Turfs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            // 🔍 Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or location',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => setState(() => searchQuery = value.trim().toLowerCase()),
            ),
            const SizedBox(height: 12),

            // 🏟 Real-time Turf Grid
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('turfs').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final turfs = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['name']?.toLowerCase() ?? '';
                    final location = data['location']?.toLowerCase() ?? '';
                    final category = data['category']?.toLowerCase() ?? '';
                    return (name.contains(searchQuery) ||
                        location.contains(searchQuery)) &&
                        (selectedCategory.isEmpty || category == selectedCategory.toLowerCase());
                  }).toList();

                  if (turfs.isEmpty) return const Center(child: Text('No turfs found'));

                  return GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: turfs.map((doc) {
                      return TurfCard(turfData: doc.data() as Map<String, dynamic>);
                    }).toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ⚽ Browse by Category
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, index) {
                  final sport = categories[index];
                  final isSelected = selectedCategory == sport;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ChoiceChip(
                      label: Text(sport),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = isSelected ? '' : sport;
                        });
                      },
                    ),
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
