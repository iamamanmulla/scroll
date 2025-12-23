import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scroll/services/user_service.dart';
import 'package:scroll/models/user_model.dart';
import 'package:scroll/services/follow_service.dart';
import 'edit_profile_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserService _userService = UserService();
  final FollowService _followService = FollowService();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
      ),
      body: StreamBuilder<UserModel?>(
        stream: _userService.userStream(widget.uid),
        builder: (context, snapshot) {
          final u = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (u == null) return const Center(child: Text('User not found'));

          final isCurrentUser = currentUser != null && currentUser.uid == u.uid;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: u.photoUrl != null
                      ? NetworkImage(u.photoUrl!)
                      : const NetworkImage('https://i.pravatar.cc/150?img=11'),
                ),
                const SizedBox(height: 12),
                Text(
                  u.displayName ?? u.username ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${u.username ?? u.email.split('@').first}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                if ((u.bio ?? '').isNotEmpty)
                  Text(u.bio!, textAlign: TextAlign.center),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          u.followingCount.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text('Following'),
                      ],
                    ),
                    const SizedBox(width: 32),
                    Column(
                      children: [
                        Text(
                          u.followerCount.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text('Followers'),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (!isCurrentUser) ...[
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await _followService.sendFollowRequest(
                          u.uid,
                          fromUsername:
                              FirebaseAuth.instance.currentUser?.displayName,
                        );
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Follow request sent')),
                        );
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    },
                    child: const Text('Follow'),
                  ),
                ] else ...[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      );
                    },
                    child: const Text('Edit profile'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
