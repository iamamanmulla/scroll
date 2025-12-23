import 'package:flutter/material.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Find Friends',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildActionItem(Icons.contacts, 'Invite friends', 'Invite friends to join Scroll'),
          _buildActionItem(Icons.person_search, 'Find contacts', 'Find your contacts on Scroll'),
          _buildActionItem(Icons.facebook, 'Find Facebook friends', 'Connect with friends from Facebook'),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Suggested Accounts', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          _buildContactItem('Alice Smith', '@alice_s'),
          _buildContactItem('Bob Jones', '@bobby_j'),
          _buildContactItem('Charlie Day', '@dayman'),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFEA4359).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFFEA4359)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }

  Widget _buildContactItem(String name, String username) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Text(name[0], style: const TextStyle(color: Colors.black)),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(username),
      trailing: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEA4359),
          elevation: 0,
        ),
        child: const Text('Follow', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
