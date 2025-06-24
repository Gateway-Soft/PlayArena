import 'package:flutter/material.dart';

import '../services/common/auth_service.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String _role = 'user';

  final AuthService _authService = AuthService();

  void _signup() async {
    try {
      final user = await _authService.signUpWithEmail(_name.text, _email.text, _password.text, _role);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account created as $_role")));
        Navigator.pop(context); // Back to login
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _role,
              items: ['user', 'owner'].map((role) => DropdownMenuItem(value: role, child: Text(role.toUpperCase()))).toList(),
              onChanged: (value) => setState(() => _role = value!),
            ),
            TextField(controller: _name, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: _email, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _password, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _signup, child: const Text("Sign Up")),
          ],
        ),
      ),
    );
  }
}
