import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OwnerSettingsScreen extends StatefulWidget {
  const OwnerSettingsScreen({Key? key}) : super(key: key);

  @override
  State<OwnerSettingsScreen> createState() => _OwnerSettingsScreenState();
}

class _OwnerSettingsScreenState extends State<OwnerSettingsScreen> {
  bool isTurfOpen = true;

  // Example dummy owner details (replace with Firestore values)
  final String ownerName = "Srigunaseelan";
  final String ownerEmail = "srigunaseelan2004@gmail.com";
  final String turfName = "PlayArena Turf";

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, "/login");
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
                child: Text(ownerName[0], style: const TextStyle(fontSize: 20, color: Colors.white)),
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

          // Availability Switch
          SwitchListTile(
            title: const Text("Turf Availability"),
            subtitle: Text(isTurfOpen ? "Open for Bookings" : "Closed Temporarily"),
            secondary: const Icon(Icons.toggle_on, color: Colors.green),
            value: isTurfOpen,
            onChanged: (val) {
              setState(() {
                isTurfOpen = val;
              });

              // TODO: Update availability status in Firestore
            },
          ),

          const SizedBox(height: 20),

          // Update Profile
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: const Text("Update Profile"),
            onTap: () {
              // TODO: Navigate to edit profile screen
            },
          ),

          const Divider(),

          // Change Password
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.deepPurple),
            title: const Text("Change Password"),
            onTap: () {
              // TODO: Navigate to password reset screen
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
