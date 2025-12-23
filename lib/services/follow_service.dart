import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Send a follow request from current user to `targetUserId`.
  /// Creates a pending entry under current user's `following/userFollowing`
  /// and writes a notification into the target user's `activity/notifications`.
  Future<void> sendFollowRequest(
    String targetUserId, {
    String? fromUsername,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw StateError('Not signed in');

    final currentUserId = currentUser.uid;

    // 1) Mark following as pending for current user
    await _db
        .collection('following')
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(targetUserId)
        .set({'status': 'pending', 'timestamp': FieldValue.serverTimestamp()});

    // 2) Add notification to activity feed of the target user
    await _db
        .collection('activity')
        .doc(targetUserId)
        .collection('notifications')
        .add({
          'type': 'follow_request',
          'fromId': currentUserId,
          'fromUsername': fromUsername ?? '',
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'pending',
        });
  }
}
