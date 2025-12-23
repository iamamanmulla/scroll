import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class SearchService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Search users by username prefix using a range query.
  /// This uses the typical Firestore prefix trick with `\uf8ff`.
  Future<List<UserModel>> searchUsersByUsernamePrefix(
    String prefix, {
    int limit = 20,
  }) async {
    prefix = prefix.trim().toLowerCase();
    if (prefix.isEmpty) return [];

    final q = _db
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: prefix)
        .where('username', isLessThanOrEqualTo: '$prefix\uf8ff')
        .orderBy('username')
        .limit(limit);

    final snap = await q.get();
    return snap.docs
        .map((d) => UserModel.fromMap(d.data(), d.id))
        .toList();
  }
}
