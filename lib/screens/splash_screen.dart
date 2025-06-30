import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToRoleSelection();
  }

  Future<void> _navigateToRoleSelection() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, '/select-role');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Image.asset(
                'assets/PlayArena splash screen logo.jpg',
                height: 120,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.sports_soccer, size: 100, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // App Name
              const Text(
                'PlayArena',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              // Loader
              const CircularProgressIndicator(),

              const SizedBox(height: 40),

              // Footer
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
