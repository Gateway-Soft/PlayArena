import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserOrOwnerSelectionScreen extends StatelessWidget {
  const UserOrOwnerSelectionScreen({super.key});

  Future<void> _setRoleAndNavigate(BuildContext context, String role, String route) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedRole', role); // ✅ Save selected role
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Your Role")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/PlayArena splash screen logo.jpg', height: 120),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.person),
                label: const Text("I'm a User"),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                onPressed: () => _setRoleAndNavigate(context, 'user', '/user/login'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.sports_soccer),
                label: const Text("I'm an Owner"),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                onPressed: () => _setRoleAndNavigate(context, 'owner', '/owner/login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
