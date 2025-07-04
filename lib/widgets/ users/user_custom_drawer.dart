import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../ providers/auth_provider.dart';
import '../../theme/theme_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required String userName, required String userEmail, required String userPhotoUrl});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Drawer(
          child: SafeArea(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!.data() as Map<String, dynamic>?;

                final userName = data?['name'] ?? 'User';
                final userEmail = data?['email'] ?? '';
                final userPhotoUrl = data?['photoUrl'] ?? '';

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/user/profile');
                        },
                        child: UserAccountsDrawerHeader(
                          accountName: Text(userName),
                          accountEmail: Text(userEmail),
                          currentAccountPicture: CircleAvatar(
                            backgroundImage: userPhotoUrl.isNotEmpty
                                ? NetworkImage(userPhotoUrl)
                                : const AssetImage('assets/default_avatar.png') as ImageProvider,
                          ),
                          decoration: const BoxDecoration(color: Colors.indigo),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.home),
                        title: const Text("Home"),
                        onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/user/home', (_) => false),
                      ),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Profile'),
                        onTap: () => Navigator.pushNamed(context, '/user/profile'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Settings'),
                        onTap: () => Navigator.pushNamed(context, '/user/settings'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('My Bookings'),
                        onTap: () => Navigator.pushNamed(context, '/user/bookings'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.account_balance_wallet),
                        title: const Text('Wallet / Payment History'),
                        onTap: () => Navigator.pushNamed(context, '/user/wallet'),
                      ),
                      SwitchListTile(
                        secondary: Icon(
                          themeProvider.currentTheme == ThemeMode.dark
                              ? Icons.dark_mode
                              : Icons.light_mode,
                        ),
                        title: const Text('Dark Mode'),
                        value: themeProvider.currentTheme == ThemeMode.dark,
                        onChanged: (val) => themeProvider.toggleTheme(val),
                      ),
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text("About App"),
                        onTap: () => Navigator.pushNamed(context, '/about'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text('Logout', style: TextStyle(color: Colors.red)),
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('isLoggedIn');
                          await prefs.remove('loggedRole');
                          await Provider.of<AppAuthProvider>(context, listen: false).signOut();
                          Navigator.pushNamedAndRemoveUntil(context, '/select-role', (_) => false);
                        },
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: [
                            const Text('App Version: 1.0.0',
                                style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const Text('Powered by Gateway Software Solutions',
                                style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 5),
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
                          ],
                        ),
                      ),
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
