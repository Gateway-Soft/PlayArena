import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ providers/auth_provider.dart';
import '../../theme/theme_provider.dart';
 // ✅ Add theme provider

class CustomDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userPhotoUrl;

  const CustomDrawer({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(userName),
                accountEmail: Text(userEmail),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(userPhotoUrl),
                ),
                decoration: const BoxDecoration(color: Colors.indigo),
              ),

              // 🔹 Navigation Links
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () => Navigator.pushNamed(context, '/user/home'),
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
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () => Navigator.pushNamed(context, '/user/settings'),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () => Navigator.pushNamed(context, '/user/profile'),
              ),

              // 🌙 Theme Toggle
              SwitchListTile(
                secondary: Icon(
                  themeProvider.currentTheme == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                title: const Text('Dark Mode'),
                value: themeProvider.currentTheme == ThemeMode.dark,
                onChanged: (val) => themeProvider.toggleTheme(val), // ✅ Pass bool
              ),


              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Provider.of<AppAuthProvider>(context, listen: false).signOut();
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                },
              ),

              const Spacer(),

              // 🔸 Footer Info
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
                      onTap: () {
                        // You can launch a real link using url_launcher
                      },
                      child: const Text('Terms of Service / Privacy Policy',
                          style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                              color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
