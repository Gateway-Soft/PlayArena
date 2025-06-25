// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:playarena/screens/users/user_home_screen.dart';
//
// import '../services/common/auth_service.dart';
// import 'owners/owner_dashboard_screen.dart';
// import 'signup_screen.dart';
//
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _email = TextEditingController();
//   final _password = TextEditingController();
//   String _role = 'user';
//
//   final AuthService _authService = AuthService();
//
//   Future<void> _navigateToRoleScreen(String uid) async {
//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .get();
//     final role = doc.data()?['role'] ?? 'user';
//
//     if (role == 'owner') {
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (_) => const OwnerDashboardScreen()));
//     } else {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => const UserHomeScreen()));
//     }
//   }
//
//   void _login() async {
//     try {
//       final user = await _authService.loginWithEmail(
//           _email.text, _password.text);
//       if (user != null) {
//         _navigateToRoleScreen(user.uid);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Login error: $e")));
//     }
//   }
//
//   void _googleLogin() async {
//     try {
//       final user = await _authService.signInWithGoogle(_role);
//       if (user != null) {
//         _navigateToRoleScreen(user.uid);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Google login error: $e")));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             DropdownButtonFormField<String>(
//               value: _role,
//               items: ['user', 'owner']
//                   .map((role) =>
//                   DropdownMenuItem(
//                       value: role, child: Text(role.toUpperCase())))
//                   .toList(),
//               onChanged: (value) => setState(() => _role = value!),
//             ),
//             TextField(controller: _email,
//                 decoration: const InputDecoration(labelText: "Email")),
//             TextField(controller: _password,
//                 decoration: const InputDecoration(labelText: "Password"),
//                 obscureText: true),
//             const SizedBox(height: 16),
//             ElevatedButton(onPressed: _login, child: const Text("Login")),
//             OutlinedButton(onPressed: _googleLogin,
//                 child: const Text("Sign in with Google")),
//             const SizedBox(height: 12),
//             TextButton(
//               onPressed: () =>
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const SignupScreen()),
//                   ),
//               child: const Text("Don't have an account? Sign up"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }