import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy and settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('ACCOUNT'),
          _buildSettingsTile(Icons.person_outline, 'Manage my account'),
          _buildSettingsTile(Icons.lock_outline, 'Privacy and safety'),
          _buildSettingsTile(Icons.videocam_outlined, 'Content preferences'),
          _buildSettingsTile(Icons.account_balance_wallet_outlined, 'Balance'),
          _buildSettingsTile(Icons.share_outlined, 'Share profile'),
          _buildSettingsTile(Icons.qr_code_scanner, 'TikCode'),
          const Divider(),
          
          _buildSectionHeader('GENERAL'),
          _buildSettingsTile(Icons.notifications_none, 'Push notifications'),
          _buildSettingsTile(Icons.language, 'Language'),
          _buildSettingsTile(Icons.umbrella_outlined, 'Digital Wellbeing'),
          _buildSettingsTile(Icons.accessibility_new_outlined, 'Accessibility'),
          _buildSettingsTile(Icons.data_usage, 'Data Saver'),
          const Divider(),
          
          _buildSectionHeader('SUPPORT'),
          _buildSettingsTile(Icons.edit_outlined, 'Report a problem'),
          _buildSettingsTile(Icons.help_outline, 'Help Center'),
           const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600], size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black, 
          fontSize: 15, 
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        // Placeholder tap
      },
    );
  }
}
