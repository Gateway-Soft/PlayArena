import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../ providers/auth_provider.dart';
import '../../theme/theme_provider.dart';

class CustomOwnerDrawer extends StatelessWidget {
  const CustomOwnerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ownerId = FirebaseAuth.instance.currentUser?.uid;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Drawer(
          child: SafeArea(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('owners').doc(ownerId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!.data() as Map<String, dynamic>?;

                final ownerName = data?['name'] ?? 'Owner';
                final ownerEmail = data?['email'] ?? '';
                final ownerPhotoUrl = data?['photoUrl'] ?? '';

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // 🔝 Tappable profile section
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/owner/profile');
                        },
                        child: UserAccountsDrawerHeader(
                          accountName: Text(ownerName),
                          accountEmail: Text(ownerEmail),
                          currentAccountPicture: CircleAvatar(
                            backgroundImage: ownerPhotoUrl.isNotEmpty
                                ? NetworkImage(ownerPhotoUrl)
                                : const AssetImage('assets/default_avatar.png') as ImageProvider,
                          ),
                          decoration: const BoxDecoration(color: Colors.teal),
                        ),
                      ),

                      // 🔘 Drawer items
                      ListTile(
                        leading: const Icon(Icons.home),
                        title: const Text("Home"),
                        onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/owner/home', (_) => false),
                      ),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text("Profile"),
                        onTap: () => Navigator.pushNamed(context, '/owner/profile'),
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

                      // 🌗 Theme toggle
                      SwitchListTile(
                        title: const Text("Dark Theme"),
                        secondary: Icon(
                          themeProvider.currentTheme == ThemeMode.dark
                              ? Icons.dark_mode
                              : Icons.light_mode,
                        ),
                        value: themeProvider.currentTheme == ThemeMode.dark,
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

                      // 🔴 Logout
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text("Logout", style: TextStyle(color: Colors.red)),
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('isLoggedIn');
                          await prefs.remove('loggedRole');

                          await Provider.of<AppAuthProvider>(context, listen: false).signOut();

                          Navigator.pushNamedAndRemoveUntil(context, '/select-role', (_) => false);
                        },
                      ),

                      // 📱 App Info
                      const SizedBox(height: 8),
                      const Text('App Version: 1.0.0', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const Text('Powered by Gateway Software Solutions', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () async {
                          const url = 'https://your-terms-url.com';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          }
                        },
                        child: const Text(
                          'Terms of Service / Privacy Policy',
                          style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
