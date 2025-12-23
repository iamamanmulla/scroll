import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // using a light theme explicitly for this screen as per screenshot or inheriting app theme
    // Assuming App is dark, but the screenshot provided was Light. 
    // I will use Theme.of(context) but ensure good contrast.
    return Scaffold(
      backgroundColor: Colors.white, // Matching the light theme screenshot provided in requirements
      appBar: AppBar(
        title: const Text('Edit profile', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Photo / Video Change
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildChangeMediaCircle(Icons.camera_alt, 'Change photo'),
                _buildChangeMediaCircle(Icons.videocam, 'Change video'),
              ],
            ),
            const SizedBox(height: 32),
            
            // Fields
            _buildFieldTile(context, 'Name', 'Jacob West'),
            _buildFieldTile(context, 'Username', 'jacob_w'),
            
            // TikTok link copy special row
            const SizedBox(height: 8),
            _buildLinkRow(context, 'tiktok.com/@jacob_w'),
            const SizedBox(height: 8),
            
            _buildFieldTile(context, 'Bio', 'Add a bio to your profile'),
            
            const SizedBox(height: 24),
            // Socials
             _buildFieldTile(context, 'Instagram', 'Add Instagram to your profile', isAction: true),
             _buildFieldTile(context, 'YouTube', 'Add YouTube to your profile', isAction: true),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeMediaCircle(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11'), // Mock image overlay
          child: Container(
             decoration: BoxDecoration(
               color: Colors.black54,
               shape: BoxShape.circle,
             ),
             child: Center(
               child: Icon(icon, color: Colors.white, size: 30),
             ),
          ),
        ),
        const SizedBox(height: 12),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black)),
      ],
    );
  }

  Widget _buildFieldTile(BuildContext context, String label, String value, {bool isAction = false}) {
    return ListTile(
      onTap: () {
        // Mock navigation
        debugPrint('Tapped $label');
      },
      title: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black))),
          Expanded(
            child: Text(
              value, 
              textAlign: TextAlign.right,
              style: TextStyle(
                color: isAction ? Colors.grey : Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }

  Widget _buildLinkRow(BuildContext context, String link) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Slightly simpler than full screenshot match implies but clean
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Text(link, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
           const Icon(Icons.copy, size: 18, color: Colors.black),
        ],
      ),
    );
  }
}
