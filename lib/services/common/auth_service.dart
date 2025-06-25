import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ------------------ Email/Password Signup ------------------
  Future<User?> signUpWithEmail(String name, String email, String password, String role) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _db.collection('users').doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential.user;
    } catch (e) {
      print('Signup error: $e');
      rethrow;
    }
  }

  // ------------------ Email/Password Login ------------------
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  // ------------------ Google Sign-In ------------------
  Future<User?> signInWithGoogle(String selectedRole) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null; // User canceled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      // Save to Firestore if first-time login
      final docRef = _db.collection('users').doc(user!.uid);
      final doc = await docRef.get();

      if (!doc.exists) {
        await docRef.set({
          'name': user.displayName ?? '',
          'email': user.email,
          'role': selectedRole,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      print('Google Sign-In error: $e');
      rethrow;
    }
  }

  // ------------------ Get Current User Role ------------------
  Future<String?> getUserRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data()?['role'] as String?;
  }

  // ------------------ Sign Out ------------------
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Sign-out error: $e');
    }
  }
}
