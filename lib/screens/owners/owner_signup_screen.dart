import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ providers/auth_provider.dart';


class OwnerSignUpScreen extends StatefulWidget {
  const OwnerSignUpScreen({super.key});

  @override
  State<OwnerSignUpScreen> createState() => _OwnerSignUpScreenState();
}

class _OwnerSignUpScreenState extends State<OwnerSignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> handleSignUp() async {
    setState(() => isLoading = true);
    try {
      await Provider.of<AppAuthProvider>(context, listen: false).signUpWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final user = FirebaseAuth.instance.currentUser;
      final doc = FirebaseFirestore.instance.collection('owners').doc(user!.uid);
      final exists = await doc.get();

      if (!exists.exists) {
        await doc.set({
          'name': nameController.text.trim(),
          'email': user.email,
          'photoUrl': user.photoURL ?? '',
          'role': 'owner',
          'createdAt': Timestamp.now(),
        });
      }

      // ✅ Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('loggedRole', 'owner');

      Navigator.pushNamedAndRemoveUntil(context, '/owner/home', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-Up Failed: ${e.toString()}")),
      );
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Owner Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: handleSignUp,
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
