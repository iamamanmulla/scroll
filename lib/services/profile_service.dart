import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scroll/models/user_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collection reference
  CollectionReference get _usersCollection => _firestore.collection('users');

  // Fetch current user's profile
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching user profile: $e");
      return null;
    }
  }

  // Update user profile data
  Future<void> updateUserProfile(UserModel user) async {
    try {
      // Use set with merge: true to update existing fields or create new ones
      await _usersCollection.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
    } catch (e) {
      // ignore: avoid_print
      print("Error updating user profile: $e");
      rethrow;
    }
  }

  // Check if a username is already taken
  Future<bool> isUsernameTaken(String username, String currentUid) async {
    final QuerySnapshot result = await _usersCollection
        .where('username_lower', isEqualTo: username.toLowerCase())
        .get();

    // If any document is found, check if it belongs to a different user
    for (var doc in result.docs) {
      if (doc.id != currentUid) {
        return true; // Username is taken by someone else
      }
    }
    return false; // Username is available or belongs to the current user
  }

  // Upload image/video to Firebase Storage and get the download URL
  Future<String> uploadFile(File file, String path) async {
    try {
      Reference ref = _storage.ref().child(path);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      // ignore: avoid_print
      print("Error uploading file: $e");
      rethrow;
    }
  }
}
