import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnerSettingsScreen extends StatefulWidget {
  const OwnerSettingsScreen({Key? key}) : super(key: key);

  @override
  State<OwnerSettingsScreen> createState() => _OwnerSettingsScreenState();
}

class _OwnerSettingsScreenState extends State<OwnerSettingsScreen> {
  bool isTurfOpen = true;
  String ownerName = '';
  String ownerEmail = '';
  String turfName = 'PlayArena Turf'; // Default

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadOwnerData();
  }

  Future<void> loadOwnerData() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('owners').doc(user!.uid).get();

    if (doc.exists) {
      setState(() {
        ownerName = doc['name'] ?? '';
        ownerEmail = doc['email'] ?? '';
        turfName = doc['turfName'] ?? 'PlayArena Turf';
        isTurfOpen = doc['isTurfOpen'] ?? true;
      });
    }
  }

  Future<void> updateTurfAvailability(bool value) async {
    if (user == null) return;
    await FirebaseFirestore.instance.collection('owners').doc(user!.uid).update({
      'isTurfOpen': value,
    });
  }

  Future<void> _logout() async {
    // Sign out Firebase
    await FirebaseAuth.instance.signOut();

    // Clear login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to role selection
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, "/select-role", (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Owner Settings"),
        backgroundColor: Colors.teal[800],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // Owner Info
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal[200],
                child: Text(ownerName.isNotEmpty ? ownerName[0] : '?',
                    style: const TextStyle(fontSize: 20, color: Colors.white)),
              ),
              title: Text(ownerName),
              subtitle: Text(ownerEmail),
            ),
          ),

          const SizedBox(height: 20),

          // Turf Name
          Card(
            child: ListTile(
              leading: const Icon(Icons.sports_soccer, color: Colors.orange),
              title: const Text("Turf Name"),
              subtitle: Text(turfName),
            ),
          ),

          const SizedBox(height: 20),

          // Turf Availability Switch
          SwitchListTile(
            title: const Text("Turf Availability"),
            subtitle: Text(isTurfOpen ? "Open for Bookings" : "Closed Temporarily"),
            secondary: Icon(
              isTurfOpen ? Icons.check_circle : Icons.cancel,
              color: isTurfOpen ? Colors.green : Colors.red,
            ),
            value: isTurfOpen,
            onChanged: (val) {
              setState(() => isTurfOpen = val);
              updateTurfAvailability(val);
            },
          ),

          const SizedBox(height: 20),

          // Update Profile
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: const Text("Update Profile"),
            onTap: () {
              Navigator.pushNamed(context, '/owner/profile');
            },
          ),

          const Divider(),

          // Change Password
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.deepPurple),
            title: const Text("Change Password"),
            onTap: () {
              // Optional: Implement password reset
              Navigator.pushNamed(context, '/reset-password');
            },
          ),

          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: _logout,
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
