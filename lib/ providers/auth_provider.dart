import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Always ask account picker on each login
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    forceCodeForRefreshToken: true,
  );

  User? get user => _auth.currentUser;

  // 🔐 Email Login
  Future<void> loginWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
  }

  // 🔐 Email Signup
  Future<void> signUpWithEmail(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    notifyListeners();
  }

  // 🔓 Google Sign-In + Save Role (used during signup)
  Future<void> signInWithGoogleAndSaveRole(String role) async {
    final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
    if (gUser == null) return;

    final gAuth = await gUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      final docRef = FirebaseFirestore.instance
          .collection(role == 'owner' ? 'owners' : 'users')
          .doc(user.uid);
      final doc = await docRef.get();

      if (!doc.exists) {
        await docRef.set({
          'name': user.displayName ?? '',
          'email': user.email,
          'photoUrl': user.photoURL ?? '',
          'role': role,
          'createdAt': Timestamp.now(),
        });
      }

      notifyListeners();
    }
  }

  // 🧠 Auto Login with Google and Navigate Based on Role (for login)
  Future<String?> signInWithGoogleAndDetectRole() async {
    final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
    if (gUser == null) return null;

    final gAuth = await gUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(credential);
    final user = userCred.user;

    if (user != null) {
      // Try fetching from 'users' first
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data()?['role'] == 'user') {
        notifyListeners();
        return 'user';
      }

      // Try fetching from 'owners' collection
      final ownerDoc = await FirebaseFirestore.instance.collection('owners').doc(user.uid).get();
      if (ownerDoc.exists && ownerDoc.data()?['role'] == 'owner') {
        notifyListeners();
        return 'owner';
      }

      // 🚫 No role found, let the app route to '/select-role'
      return null;
    }

    return null;
  }

  // 🔒 Logout
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    notifyListeners();
  }
}
