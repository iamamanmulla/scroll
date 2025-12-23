import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'create_post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/post_service.dart';
import 'package:scroll/services/user_service.dart';
import '../../../models/user_model.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/create/add_user_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _postService = PostService();
  final _userService = UserService();

  // Local fallback posts for devices/projects without Firestore configured
  final List<Post> _localPosts = [];

  String _displayNameFor(UserModel? u, User? authUser) {
    // Prefer the Firestore display name when available, then username, then auth displayName, then email prefix.
    if (u != null && (u.displayName?.isNotEmpty ?? false))
      return u.displayName!;
    if (u != null && (u.username?.isNotEmpty ?? false)) return u.username!;
    if (authUser != null)
      return authUser.displayName ?? authUser.email?.split('@').first ?? 'User';
    return 'Guest';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white, // white background per app style
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: StreamBuilder<UserModel?>(
          stream: user == null
              ? Stream.value(null)
              : _userService.userStream(user.uid),
          builder: (context, snapshot) {
            final u = snapshot.data;
            final name =
                u?.displayName ??
                user?.displayName ??
                user?.email?.split('@').first ??
                'User';
            return Text(
              name,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person_add_alt_1_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddUserScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),

      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              StreamBuilder<UserModel?>(
                stream: user == null
                    ? Stream.value(null)
                    : _userService.userStream(user.uid),
                builder: (context, snapshot) {
                  final u = snapshot.data;
                  return SliverList(
                    delegate: SliverChildListDelegate([
                      _buildProfileHeader(context, u, user),
                    ]),
                  );
                },
              ),
            ];
          },
          body: Column(
            children: [
              const TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(icon: Icon(Icons.grid_3x3)), // Posted
                  Tab(icon: Icon(Icons.favorite_border)), // Liked
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildPostsGrid(user),
                    _buildVideoGrid(isPosted: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel? u, User? user) {
    final displayName = _displayNameFor(u, user);
    final photo = u?.photoUrl ?? user?.photoURL;
    final bio = u?.bio ?? '';

    return Column(
      children: [
        const SizedBox(height: 16),
        CircleAvatar(
          radius: 50,
          backgroundImage: photo != null
              ? NetworkImage(photo) as ImageProvider
              : const NetworkImage('https://i.pravatar.cc/150?img=11'),
        ),
        const SizedBox(height: 12),
        Text(
          displayName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          u != null && (u.username?.isNotEmpty ?? false)
              ? '@${u.username}'
              : (user?.email != null
                    ? '@${user!.email!.split('@').first}'
                    : ''),
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 8),
        if (bio.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              bio,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        const SizedBox(height: 16),

        // Stats (Following / Followers / Likes)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStat((u?.followingCount ?? 0).toString(), 'Following'),
            const SizedBox(width: 32),
            _buildStat((u?.followerCount ?? 0).toString(), 'Followers'),
            const SizedBox(width: 32),
            _buildStat('0', 'Likes'),
          ],
        ),

        const SizedBox(height: 24),

        // Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                side: BorderSide(color: Colors.grey.shade300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Edit profile',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: IconButton(
                icon: const Icon(Icons.bookmark_border, color: Colors.black),
                onPressed: () {},
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildPostsGrid(User? user) {
    return StreamBuilder<List<Post>>(
      stream: user == null
          ? Stream.value([])
          : _postService.userPostsStream(user.uid),
      builder: (context, snapshot) {
        final posts = snapshot.data ?? [];

        final allPosts = [..._localPosts, ...posts];
        return GridView.builder(
          padding: const EdgeInsets.all(1),
          itemCount: (allPosts.isEmpty ? 1 : allPosts.length + 1),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            // Create new tile
            if (index == 0) {
              return InkWell(
                onTap: () async {
                  final result = await Navigator.of(context)
                      .push<Map<String, dynamic>?>(
                        MaterialPageRoute(
                          builder: (_) => const CreatePostScreen(),
                        ),
                      );

                  if (result != null) {
                    if (result['created'] == true) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Post uploaded successfully'),
                        ),
                      );
                    } else {
                      final post = Post(
                        id: 'local-${DateTime.now().millisecondsSinceEpoch}',
                        uid: result['uid'] ?? 'local',
                        displayName: result['displayName'] ?? 'You',
                        content: result['content'] ?? '',
                        timestamp: Timestamp.now(),
                      );
                      setState(() => _localPosts.insert(0, post));

                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Post saved locally (offline)'),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  color: Colors.grey.shade100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, color: Colors.black, size: 32),
                      SizedBox(height: 4),
                      Text(
                        'Tap to create\na new post',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }

            final post = allPosts[index - 1];
            return Container(
              color: Colors.grey.shade900,
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  post.content,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVideoGrid({required bool isPosted}) {
    return GridView.builder(
      padding: const EdgeInsets.all(1),
      itemCount: 15,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey.shade900,
          child: Image.network(
            'https://picsum.photos/200/300?random=$index',
            fit: BoxFit.cover,
            errorBuilder: (c, o, s) => const Center(
              child: Icon(Icons.videocam, color: Colors.white54),
            ),
          ),
        );
      },
    );
  }
}
