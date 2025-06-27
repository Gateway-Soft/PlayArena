import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../ providers/auth_provider.dart';

class OwnerLoginScreen extends StatefulWidget {
  const OwnerLoginScreen({super.key});

  @override
  State<OwnerLoginScreen> createState() => _OwnerLoginScreenState();
}

class _OwnerLoginScreenState extends State<OwnerLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void loginWithEmail() async {
    setState(() => isLoading = true);
    try {
      await Provider.of<AppAuthProvider>(context, listen: false).loginWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final role = await Provider.of<AppAuthProvider>(context, listen: false).getCurrentUserRole();
      if (role == 'owner') {
        Navigator.pushNamedAndRemoveUntil(context, '/owner/dashboard', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
    setState(() => isLoading = false);
  }

  void loginWithGoogle() async {
    setState(() => isLoading = true);
    try {
      final role = await Provider.of<AppAuthProvider>(context, listen: false)
          .signInWithGoogleAndDetectRole();

      final user = FirebaseAuth.instance.currentUser;

      if (user != null && role == null) {
        final doc = await FirebaseFirestore.instance.collection('owners').doc(user.uid).get();
        if (!doc.exists) {
          await FirebaseFirestore.instance.collection('owners').doc(user.uid).set({
            'name': user.displayName ?? '',
            'email': user.email,
            'photoUrl': user.photoURL ?? '',
            'role': 'owner',
            'createdAt': Timestamp.now(),
          });
        }
      }

      final updatedRole = await Provider.of<AppAuthProvider>(context, listen: false).getCurrentUserRole();
      if (updatedRole == 'owner') {
        Navigator.pushNamedAndRemoveUntil(context, '/owner/dashboard', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google Sign-In failed: $e')));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Owner Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : Column(
              children: [
                ElevatedButton(onPressed: loginWithEmail, child: const Text('Login')),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: loginWithGoogle, child: const Text('Login with Google')),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/owner/signup'),
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
