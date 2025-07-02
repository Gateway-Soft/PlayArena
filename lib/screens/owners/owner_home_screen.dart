import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../theme/theme_provider.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({Key? key}) : super(key: key);

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  String ownerName = '';
  String ownerEmail = '';
  String photoUrl = '';
  String currentLocation = 'Triplicane'; // ✅ Default

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadOwnerInfo();
    _detectLocation(); // 🌍 Auto-detect on start
  }

  Future<void> loadOwnerInfo() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('owners').doc(user!.uid).get();
      if (doc.exists) {
        setState(() {
          ownerName = doc['name'] ?? '';
          ownerEmail = doc['email'] ?? '';
          photoUrl = doc['photoUrl'] ?? '';
          currentLocation = doc['location'] ?? 'Triplicane';
        });
      }
    }
  }

  Future<void> _detectLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) return;
      }

      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // 🌐 Reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      String readableLocation = 'Your Location';

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        readableLocation = "${place.subLocality}, ${place.locality}";
      }

      setState(() {
        currentLocation = readableLocation;
      });

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('owners').doc(uid).update({
          'location': readableLocation,
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
          decoration: const InputDecoration(hintText: 'E.g. Triplicane'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid != null) {
                await FirebaseFirestore.instance.collection('owners').doc(uid).update({
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

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/select-role', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(ownerName),
              accountEmail: Text(ownerEmail),
              currentAccountPicture: CircleAvatar(
                backgroundImage: photoUrl.isNotEmpty
                    ? NetworkImage(photoUrl)
                    : const AssetImage('assets/default_user.png') as ImageProvider,
              ),
              decoration: BoxDecoration(color: Colors.teal[800]),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () => Navigator.pushNamed(context, '/owner/dashboard'),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Add Turf"),
              onTap: () => Navigator.pushNamed(context, '/owner/add-turf'),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text("My Turfs"),
              onTap: () => Navigator.pushNamed(context, '/owner/my-turf-list'),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text("Slot Management"),
              onTap: () => Navigator.pushNamed(context, '/owner/slot-management'),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("View Bookings"),
              onTap: () => Navigator.pushNamed(context, '/owner/view-bookings'),
            ),
            SwitchListTile(
              title: const Text("Dark Theme"),
              secondary: const Icon(Icons.dark_mode),
              value: themeProvider.isDarkMode,
              onChanged: (val) async {
                themeProvider.toggleTheme(val);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isDarkMode', val);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About App"),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome, $ownerName 👋",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("📍 $currentLocation", style: const TextStyle(color: Colors.grey)),
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
                    icon: Icons.message,
                    title: 'Messages',
                    color: Colors.purple,
                    onTap: () => Navigator.pushNamed(context, '/owner/messages'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
