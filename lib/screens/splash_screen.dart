import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('user_role');

    if (user == null) {
      Navigator.pushReplacementNamed(context, '/select-role');
    } else if (role == 'user') {
      Navigator.pushReplacementNamed(context, '/user/home');
    } else if (role == 'owner') {
      Navigator.pushReplacementNamed(context, '/owner/home');
    } else {
      Navigator.pushReplacementNamed(context, '/select-role');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[300] : Colors.grey;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/PlayArena splash screen logo.jpg',
                height: 120,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.sports_soccer, size: 100, color: subtitleColor),
              ),
              const SizedBox(height: 24),
              Text(
                'PlayArena',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              const CircularProgressIndicator(),
              const SizedBox(height: 40),
              Text(
                'Powered by Gateway Software Solutions',
                style: TextStyle(
                  fontSize: 14,
                  color: subtitleColor,
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
