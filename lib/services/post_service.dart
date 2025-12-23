import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String uid;
  final String displayName;
  final String content;
  final Timestamp timestamp;

  Post({
    required this.id,
    required this.uid,
    required this.displayName,
    required this.content,
    required this.timestamp,
  });

  factory Post.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      uid: data['uid'] ?? '',
      displayName: data['displayName'] ?? '',
      content: data['content'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}

class PostService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Post>> userPostsStream(String uid) {
    try {
      return _db
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snap) => snap.docs.map((d) => Post.fromDoc(d)).toList());
    } catch (e) {
      // If Firestore isn't configured, return empty stream
      return Stream.value([]);
    }
  }

  Future<void> addPost({
    required String uid,
    required String displayName,
    required String content,
  }) async {
    final doc = {
      'uid': uid,
      'displayName': displayName,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await _db.collection('posts').add(doc);
    } on FirebaseException catch (e) {
      // Re-throw for UI to handle, or log
      throw e;
    }
  }
}
