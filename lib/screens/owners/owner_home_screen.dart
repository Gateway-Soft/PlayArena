import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import '../../theme/theme_provider.dart';
import '../../widgets/owners/Owner_Custom_Drawer.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({Key? key}) : super(key: key);

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  String currentLocation = 'Fetching...';
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _detectLocation(); // 🌍 auto detect
  }

  Future<void> _detectLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) return;
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      String readableLocation = placemarks.isNotEmpty
          ? "${placemarks.first.subLocality}, ${placemarks.first.locality}"
          : 'Unknown';

      setState(() => currentLocation = readableLocation);

      final uid = user?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('owners').doc(uid).update({
          'location': readableLocation,
        });
      }
    } catch (e) {
      print("Location error: $e");
    }
  }

  void _enterManualLocation() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter Your Location"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Eg: T Nagar'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              final uid = user?.uid;
              if (uid != null) {
                await FirebaseFirestore.instance.collection('owners').doc(uid).update({
                  'location': controller.text,
                });
              }
              setState(() => currentLocation = controller.text);
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('owners').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final ownerName = data['name'] ?? '';
        final locationFromDB = data['location'] ?? currentLocation;

        return Scaffold(
          appBar: AppBar(
            title: const Text("PlayArena Owner"),
            backgroundColor: Colors.teal[800],
            actions: [
              IconButton(
                icon: const Icon(Icons.location_on_outlined),
                tooltip: 'Update Location',
                onPressed: _showLocationOptions,
              ),
            ],
          ),
          drawer: const CustomOwnerDrawer(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome, $ownerName 👋",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("📍 $locationFromDB",
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _OwnerActionCard(
                        icon: Icons.calendar_month,
                        title: 'Bookings',
                        color: Colors.blue,
                        onTap: () => Navigator.pushNamed(context, '/owner/bookings'),
                      ),
                      _OwnerActionCard(
                        icon: Icons.attach_money,
                        title: 'Earnings',
                        color: Colors.green,
                        onTap: () => Navigator.pushNamed(context, '/owner/earnings'),
                      ),
                      _OwnerActionCard(
                        icon: Icons.sports_soccer,
                        title: 'Manage Turf',
                        color: Colors.orange,
                        onTap: () => Navigator.pushNamed(context, '/owner/turf'),
                      ),
                      _OwnerActionCard(
                        icon: Icons.dashboard,
                        title: 'Dashboard',
                        color: Colors.indigo,
                        onTap: () => Navigator.pushNamed(context, '/owner/dashboard'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OwnerActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _OwnerActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
