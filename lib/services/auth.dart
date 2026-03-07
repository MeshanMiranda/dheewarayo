import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream listening to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // 1. Sign in anonymously
  Future<UserCredential?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result;
    } catch (e) {
      debugPrint('Error during anonymous sign in: $e');
      rethrow;
    }
  }

  // 2. Register using email and password
  Future<UserCredential?> registerWithEmailAndPassword(
    String email,
    String password,
    Map<String, dynamic> userData,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user data in Firestore
      if (result.user != null) {
        userData['createdAt'] = FieldValue.serverTimestamp();
        _firestore
            .collection('users')
            .doc(result.user!.uid)
            .set(userData)
            .catchError((e) => debugPrint('Firestore error: $e'));
      }
      return result;
    } catch (e) {
      debugPrint('Error during email registration: $e');
      rethrow;
    }
  }

  // 3. Sign in using email and password
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      debugPrint('Error during email sign in: $e');
      rethrow;
    }
  }

  // 4. Sign in using a Google account
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential result = await _auth.signInWithCredential(credential);

      // Check if this is a new user and add them to Firestore
      if (result.additionalUserInfo?.isNewUser ?? false) {
        _firestore
            .collection('users')
            .doc(result.user!.uid)
            .set({
              'fullName': googleUser.displayName ?? '',
              'email': googleUser.email,
              'uid': result.user!.uid,
              'createdAt': FieldValue.serverTimestamp(),
            })
            .catchError((e) => debugPrint('Firestore error: $e'));
      }

      return result;
    } catch (e) {
      debugPrint('Error during Google sign in: $e');
      rethrow;
    }
  }

  // 5. Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Error during password reset: $e');
      rethrow;
    }
  }

  // 6. Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error during sign out: $e');
      rethrow;
    }
  }
}
