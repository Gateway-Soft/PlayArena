import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserOrOwnerSelectionScreen extends StatelessWidget {
  const UserOrOwnerSelectionScreen({super.key});

  Future<void> _setRoleAndNavigate(BuildContext context, String role, String route) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedRole', role); // ✅ Save selected role

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected role: $role')),
    );
    await Future.delayed(const Duration(milliseconds: 500)); // Let snackbar show

    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Your Role")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/PlayArena splash screen logo.jpg',
                  height: 120,
                ),
              ),
              const SizedBox(height: 30),

              // User Button
              ElevatedButton.icon(
                icon: const Icon(Icons.person),
                label: const Text("I'm a User"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => _setRoleAndNavigate(context, 'user', '/user/login'),
              ),
              const SizedBox(height: 20),

              // Owner Button
              ElevatedButton.icon(
                icon: const Icon(Icons.sports_soccer),
                label: const Text("I'm an Owner"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => _setRoleAndNavigate(context, 'owner', '/owner/login'),
              ),
              const SizedBox(height: 40),

              // Branding footer
              const Text(
                'Powered by Gateway Software Solutions',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
