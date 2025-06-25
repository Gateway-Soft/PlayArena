import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> checkUserRole(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    Navigator.pushReplacementNamed(context, '/select-role'); // Fallback
    return;
  }

  try {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (userDoc.exists && userDoc.data()?['role'] == 'user') {
      Navigator.pushReplacementNamed(context, '/user/home');
      return;
    }

    final ownerDoc = await FirebaseFirestore.instance.collection('owners').doc(user.uid).get();
    if (ownerDoc.exists && ownerDoc.data()?['role'] == 'owner') {
      Navigator.pushReplacementNamed(context, '/owner/dashboard');
      return;
    }

    // ❌ Role not found — go to select screen
    Navigator.pushReplacementNamed(context, '/select-role');
  } catch (e) {
    debugPrint("Role check failed: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Unable to check role. Try again.")),
    );
  }
}
