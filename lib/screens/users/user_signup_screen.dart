import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../ providers/auth_provider.dart';

class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({super.key});

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void handleSignUp() async {
    setState(() => isLoading = true);
    try {
      await Provider.of<AppAuthProvider>(context, listen: false).signUpWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': nameController.text.trim(),
        'email': user.email,
        'photoUrl': user.photoURL ?? '',
        'role': 'user',
        'createdAt': Timestamp.now(),
      });

      Navigator.pushReplacementNamed(context, '/user/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign-Up Failed: $e")));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: handleSignUp, child: const Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
