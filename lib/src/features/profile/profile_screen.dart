import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'edit_profile_screen.dart';
import '../../features/discover/discover_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/create/add_user_screen.dart';
import 'package:scroll/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedProfile = 'Jacob West';
  final List<String> _profiles = ['Jacob West', 'Jacob_Backup'];

  @override
  Widget build(BuildContext context) {
    // Ensuring Scaffold background matches the requested 'Light' theme style from screenshot
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
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
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _profiles.contains(_selectedProfile)
                ? _selectedProfile
                : null,
            hint: Text(
              _selectedProfile,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 17,
              ),
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            dropdownColor: Colors.white,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 17,
            ),
            items: [
              ..._profiles.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }),
              const DropdownMenuItem<String>(
                value: 'ADD_ACCOUNT',
                child: Row(
                  children: [
                    Icon(Icons.add, size: 20, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Add account'),
                  ],
                ),
              ),
            ],
            onChanged: (String? newValue) async {
              if (newValue == 'ADD_ACCOUNT') {
                // Navigate to Login for adding account
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(isAddingAccount: true),
                  ),
                );

                if (result != null && result is String) {
                  setState(() {
                    if (!_profiles.contains(result)) {
                      _profiles.add(result);
                    }
                    _selectedProfile = result;
                  });
                }
              } else if (newValue != null) {
                setState(() {
                  _selectedProfile = newValue;
                });
              }
            },
          ),
        ),
        actions: [
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
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildProfileHeader(context),
                ]),
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
                  Tab(icon: Icon(Icons.grid_3x3)), // Posted videos
                  Tab(icon: Icon(Icons.favorite_border)), // Liked videos
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildVideoGrid(isPosted: true),
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

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
        ),
        const SizedBox(height: 12),
        const Text(
          '@jacob_w',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 24),

        // Stats
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStat('14', 'Following'),
            const SizedBox(width: 32),
            _buildStat('38', 'Followers'),
            const SizedBox(width: 32),
            _buildStat('91', 'Likes'),
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
        const Text(
          'Tap to add bio',
          style: TextStyle(color: Colors.grey, fontSize: 14),
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
        // Special "Create new" tile for the first item of posted tab
        if (isPosted && index == 0) {
          return Container(
            color: Colors.grey.shade100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add, color: Colors.black, size: 32),
                SizedBox(height: 4),
                Text(
                  'Tap to create\na new video',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        }

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
