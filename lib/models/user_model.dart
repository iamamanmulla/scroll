/// UserModel represents a user profile stored in Firestore.
///
/// Firestore structure (high-level):
/// - users (collection): user documents keyed by uid containing profile fields
///   (username, displayName, bio, followerCount, followingCount, etc.)
/// - followers (collection) → {userId} (doc) → userFollowers (subcollection)
/// - following (collection) → {userId} (doc) → userFollowing (subcollection)
/// - activity (collection) → {userId} (doc) → notifications (subcollection)
class UserModel {
  String uid;
  String email;
  String? displayName;
  String? username;
  String? bio;
  String? photoUrl;
  String? videoUrl;
  String? instagramLink;
  String? youtubeLink;
  String? facebookLink;
  String? displayNameLower;

  /// Counts for social graph. Keep these as ints for easy sorting/reads.
  int followerCount;
  int followingCount;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.username,
    this.bio,
    this.photoUrl,
    this.videoUrl,
    this.instagramLink,
    this.youtubeLink,
    this.facebookLink,
    this.displayNameLower,
    this.followerCount = 0,
    this.followingCount = 0,
  });

  // Factory constructor to create a UserModel from Firestore data
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'],
      username: map['username'],
      bio: map['bio'],
      photoUrl: map['photoUrl'],
      videoUrl: map['videoUrl'],
      instagramLink: map['instagramLink'],
      youtubeLink: map['youtubeLink'],
      facebookLink: map['facebookLink'],
      displayNameLower: map['displayName_lower'],
      followerCount: (map['followerCount'] is int)
          ? map['followerCount'] as int
          : (map['followerCount'] is num
                ? (map['followerCount'] as num).toInt()
                : 0),
      followingCount: (map['followingCount'] is int)
          ? map['followingCount'] as int
          : (map['followingCount'] is num
                ? (map['followingCount'] as num).toInt()
                : 0),
    );
  }

  // Convert UserModel to a Map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'username': username,
      'bio': bio,
      'photoUrl': photoUrl,
      'videoUrl': videoUrl,
      'instagramLink': instagramLink,
      'youtubeLink': youtubeLink,
      'facebookLink': facebookLink,
      'followerCount': followerCount,
      'followingCount': followingCount,
      'displayName_lower': displayNameLower,
      if (username != null) 'username_lower': username!.toLowerCase(),
    };
  }
}
