import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result;
    } catch (e) {
      debugPrint('Error during anonymous sign in: $e');
      rethrow;
    }
  }

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

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);

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

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Error during password reset: $e');
      rethrow;
    }
  }

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
