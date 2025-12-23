import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShareSheet extends StatelessWidget {
  const ShareSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Share to', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 24),
          
          // Row 1: Social Apps
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildShareItem(FontAwesomeIcons.whatsapp, 'WhatsApp', Colors.green),
                _buildShareItem(FontAwesomeIcons.whatsapp, 'Status', Colors.green),
                _buildShareItem(FontAwesomeIcons.facebookMessenger, 'Messenger', Colors.blue),
                _buildShareItem(FontAwesomeIcons.commentDots, 'SMS', Colors.greenAccent),
                _buildShareItem(FontAwesomeIcons.instagram, 'Instagram', Colors.purpleAccent),
                _buildShareItem(FontAwesomeIcons.twitter, 'Twitter', Colors.lightBlue),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Row 2: Actions
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildActionItem(Icons.flag_outlined, 'Report'),
                _buildActionItem(Icons.heart_broken_outlined, 'Not interested'),
                _buildActionItem(Icons.download_rounded, 'Save video'),
                _buildActionItem(Icons.copy_all, 'Duet'),
                _buildActionItem(Icons.emoji_emotions_outlined, 'React'),
                _buildActionItem(Icons.bookmark_border, 'Add to Favorites'),
              ],
            ),
          ),
          
          const Divider(),
          ListTile(
            title: const Center(child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold))),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildShareItem(IconData icon, String label, Color color) {
    return Container(
      width: 72,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center, maxLines: 2),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label) {
     return Container(
      width: 72,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.black, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center, maxLines: 2),
        ],
      ),
    );
  }
}
