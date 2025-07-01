import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ providers/auth_provider.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> checkUserRoleAndNavigate() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final ownerDoc = await FirebaseFirestore.instance.collection('owners').doc(uid).get();
    final prefs = await SharedPreferences.getInstance();

    if (userDoc.exists && ownerDoc.exists) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Choose Role'),
          content: const Text('This account is registered as both User and Owner.'),
          actions: [
            TextButton(
              onPressed: () async {
                await prefs.setString('user_role', 'user');
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/user/home');
              },
              child: const Text('User'),
            ),
            TextButton(
              onPressed: () async {
                await prefs.setString('user_role', 'owner');
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/owner/home');
              },
              child: const Text('Owner'),
            ),
          ],
        ),
      );
    } else if (userDoc.exists) {
      await prefs.setString('user_role', 'user');
      Navigator.pushReplacementNamed(context, '/user/home');
    } else if (ownerDoc.exists) {
      await prefs.setString('user_role', 'owner');
      Navigator.pushReplacementNamed(context, '/owner/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Access Denied: No role assigned')),
      );
    }
  }

  void loginWithEmail() async {
    setState(() => isLoading = true);
    try {
      await Provider.of<AppAuthProvider>(context, listen: false).loginWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      await checkUserRoleAndNavigate();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
    setState(() => isLoading = false);
  }

  void loginWithGoogle() async {
    setState(() => isLoading = true);
    try {
      final role = await Provider.of<AppAuthProvider>(context, listen: false)
          .signInWithGoogleAndDetectRole();

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'name': user.displayName ?? '',
            'email': user.email,
            'photoUrl': user.photoURL ?? '',
            'role': 'user',
            'createdAt': Timestamp.now(),
          });
        }
        await checkUserRoleAndNavigate();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $e')),
      );
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgot-password');
              },
              child: const Text("Forgot Password?"),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : Column(
              children: [
                ElevatedButton(
                  onPressed: loginWithEmail,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: loginWithGoogle,
                  child: const Text('Login with Google'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/user/signup'),
                  child: const Text("Don't have an account? Sign Up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
