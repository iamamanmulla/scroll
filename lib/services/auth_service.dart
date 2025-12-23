import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Register with Email/Password + Save Extra Data
  Future<String?> registerUser({
    required String email,
    required String password,
    required String phone,
    required String gender,
    required int age,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential result;
      try {
        result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        // Log the precise FirebaseAuth error for debugging (reCAPTCHA, network, etc.)
        // ignore: avoid_print
        print('FirebaseAuth error: ${e.code} — ${e.message}');
        rethrow;
      }

      User? user = result.user;

      // Save additional info to Firestore
      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'phone': phone,
          'gender': gender,
          'age': age,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  // 2. Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      // Use the singleton instance and call the interactive `authenticate` flow
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      // `authentication` is available synchronously on the account object
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null || googleAuth.idToken!.isEmpty) {
        // ignore: avoid_print
        print('Google Sign-In: idToken missing');
        return null;
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      return result.user;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print('FirebaseAuth (Google) error: ${e.code} — ${e.message}');
      return null;
    } catch (e, st) {
      // ignore: avoid_print
      print('Google Sign In Error: $e\n$st');
      return null;
    }
  }

  // Friendly FirebaseAuthException mapping used by UI/tests
  // Friendly FirebaseAuthException mapping used by UI/tests
  static String friendlyErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-not-found':
        return 'No user found with that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return e.message ?? 'Authentication error';
    }
  }

  // 3. Login with Email/Password
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "success";
    } catch (e) {
      return e.toString();
    }
  }
}
