import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  String _currentView = 'Direct messages'; // Default view
  final List<String> _views = ['Direct messages', 'All activity'];

  @override
  Widget build(BuildContext context) {
    bool isDirectMessages = _currentView == 'Direct messages';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: isDirectMessages
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                onPressed: () {
                   // Mock back or maybe toggle back to main if this was a sub-screen
                   // But since it's a main nav tab, back might not make sense unless specifically requested.
                   // The screenshot shows a back arrow for DM view, so keeping it.
                }, 
              )
            : null,
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _currentView,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            dropdownColor: Colors.white,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            items: _views.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _currentView = newValue;
                });
              }
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDirectMessages ? Icons.add : FontAwesomeIcons.paperPlane,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: isDirectMessages ? _buildDirectMessagesView() : _buildAllActivityView(),
      ),
    );
  }

  Widget _buildDirectMessagesView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(FontAwesomeIcons.paperPlane, size: 80, color: Colors.grey), // Closest to the skeletal icon
        const SizedBox(height: 24),
        const Text(
          'Message your friends',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Text(
          'Share videos or start a conversation',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEA4359),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            elevation: 0,
          ),
          child: const Text('Start chatting', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildAllActivityView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey), // Placeholder for rectangular chat icon
        const SizedBox(height: 24),
        const Text(
          'Notifications aren\'t available',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Text(
          'Notifications about your account will appear here',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ],
    );
  }
}
