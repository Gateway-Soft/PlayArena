import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    forceCodeForRefreshToken: true,
  );

  User? get user => _auth.currentUser;

  // ✅ Check if user previously logged in
  Future<bool> checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // 🔐 Email Login
  Future<void> loginWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    notifyListeners();
  }

  // 🔐 Email Signup
  Future<void> signUpWithEmail(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    notifyListeners();
  }

  // 🔓 Google Sign-In + Save Role (signup)
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

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      notifyListeners();
    }
  }

  // 🧠 Google Login to detect role (manual login)
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // ✅ Prioritize owners
      final ownerDoc = await FirebaseFirestore.instance.collection('owners').doc(user.uid).get();
      print("Fetched owner doc: ${ownerDoc.data()}");
      if (ownerDoc.exists && ownerDoc.data()?['role'] == 'owner') {
        notifyListeners();
        return 'owner';
      }

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      print("Fetched user doc: ${userDoc.data()}");
      if (userDoc.exists && userDoc.data()?['role'] == 'user') {
        notifyListeners();
        return 'user';
      }

      return null;
    }

    return null;
  }

  // ✅ AUTO LOGIN WITHOUT POPUP
  Future<String?> tryAutoLogin() async {
    final gUser = await _googleSignIn.signInSilently();
    if (gUser == null) return null;

    final gAuth = await gUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(credential);
    final user = userCred.user;

    if (user != null) {
      // ✅ Prioritize owners
      final ownerDoc = await FirebaseFirestore.instance.collection('owners').doc(user.uid).get();
      if (ownerDoc.exists && ownerDoc.data()?['role'] == 'owner') {
        notifyListeners();
        return 'owner';
      }

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data()?['role'] == 'user') {
        notifyListeners();
        return 'user';
      }

      return null;
    }

    return null;
  }

  // ✅ Get current user role manually
  Future<String?> getCurrentUserRole() async {
    final user = _auth.currentUser;
    if (user != null) {
      final ownerDoc = await FirebaseFirestore.instance.collection('owners').doc(user.uid).get();
      if (ownerDoc.exists && ownerDoc.data()?['role'] == 'owner') {
        return 'owner';
      }

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data()?['role'] == 'user') {
        return 'user';
      }
    }
    return null;
  }

  // 🔒 Logout
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    notifyListeners();
  }
}
