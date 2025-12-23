import 'package:flutter/material.dart';
import '../../features/feed/feed_screen.dart';
import '../../features/profile/profile_screen.dart';

import '../../features/discover/discover_screen.dart';
import '../../features/create/camera_screen.dart';
import '../../features/inbox/inbox_screen.dart';
import 'custom_navbar.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const DiscoverScreen(),
    const Center(child: Text('Add')),    // Placeholder
    const InboxScreen(),                 // Real Screen
    const ProfileScreen(),
  ];


  void _onItemTapped(int index) {
    if (index == 2) {
      // Navigate to CameraScreen full screen
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CameraScreen()),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Safety background
      body: Stack(
        children: [
          // Screen Content
          Positioned.fill(
            child: _screens[_selectedIndex],
          ),
          
          // Custom Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomNavbar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}
