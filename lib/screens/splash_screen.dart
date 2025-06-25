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
    _navigateToRoleScreen();
  }

  Future<void> _navigateToRoleScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, '/select-role');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/PlayArena splash screen logo.jpg', height: 200),
            const SizedBox(height: 15),
            const Text("Play Arena", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Powered by Gateway Software Solutions", style: TextStyle(fontSize: 15)),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
