import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class SearchService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<UserModel>> searchUsers({
    required String query,
    int limit = 20,
  }) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    // 1️⃣ Search by username
    final usernameSnap = await _db
        .collection('users')
        .where('username_lower', isGreaterThanOrEqualTo: q)
        .where('username_lower', isLessThanOrEqualTo: '$q\uf8ff')
        .orderBy('username_lower')
        .limit(limit)
        .get();

    // 2️⃣ Search by display name
    final nameSnap = await _db
        .collection('users')
        .where('displayName_lower', isGreaterThanOrEqualTo: q)
        .where('displayName_lower', isLessThanOrEqualTo: '$q\uf8ff')
        .orderBy('displayName_lower')
        .limit(limit)
        .get();

    // 3️⃣ Merge & remove duplicates
    final Map<String, UserModel> users = {};

    for (var d in usernameSnap.docs) {
      users[d.id] = UserModel.fromMap(d.data(), d.id);
    }

    for (var d in nameSnap.docs) {
      users[d.id] = UserModel.fromMap(d.data(), d.id);
    }

    return users.values.toList();
  }
}
