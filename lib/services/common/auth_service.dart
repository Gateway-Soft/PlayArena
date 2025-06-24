import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ✅ Email & Password Sign Up
  Future<User?> signUpWithEmail(String name, String email, String password, String role) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    await _db.collection('users').doc(credential.user!.uid).set({
      'name': name,
      'email': email,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return credential.user;
  }

  // ✅ Email & Password Login
  Future<User?> loginWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  // ✅ Google Sign-In with Firestore role storage
  Future<User?> signInWithGoogle(String role) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    // If first login, add to Firestore
    final docRef = _db.collection('users').doc(user!.uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      await docRef.set({
        'name': user.displayName,
        'email': user.email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return user;
  }
}
