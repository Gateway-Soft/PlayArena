import 'package:flutter/material.dart';

class UserOrOwnerSelectionScreen extends StatelessWidget {
  const UserOrOwnerSelectionScreen({super.key});

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
                onPressed: () {
                  Navigator.pushNamed(context, '/user/login'); // ✅ connects to user login
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.sports_soccer),
                label: const Text("I'm an Owner"),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  Navigator.pushNamed(context, '/owner/login'); // ✅ connects to owner login
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
