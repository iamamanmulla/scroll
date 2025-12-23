import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<UserModel?> userStream(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((snap) {
      if (!snap.exists) return null;
      return UserModel.fromMap(snap.data() as Map<String, dynamic>, snap.id);
    });
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  Future<String> uploadProfilePhoto(String uid, File file) async {
    final ref = _storage.ref().child('users/$uid/profile_photo.jpg');
    final task = await ref.putFile(file);
    final url = await task.ref.getDownloadURL();
    return url;
  }

  Future<String> uploadProfileVideo(String uid, File file) async {
    final ref = _storage.ref().child('users/$uid/profile_video.mp4');
    final task = await ref.putFile(file);
    final url = await task.ref.getDownloadURL();
    return url;
  }

  Future<void> updateAuthDisplayName(String displayName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
      await user.reload();
    }
  }

  Future<void> updateAuthPhotoUrl(String url) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updatePhotoURL(url);
      await user.reload();
    }
  }
}
