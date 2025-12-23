import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scroll/services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _instaController = TextEditingController();
  final _youtubeController = TextEditingController();
  final _facebookController = TextEditingController();

  bool _loading = false;
  String? _photoUrl;
  String? _videoUrl;

  final _picker = ImagePicker();
  final _userService = UserService();

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Pre-fill with existing auth info if available
      _nameController.text = user.displayName ?? '';
      _photoUrl = user.photoURL;
    }

    // Load Firestore user doc to fill other fields
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _userService.userStream(uid).first.then((u) {
        if (u != null && mounted) {
          _usernameController.text = u.username ?? '';
          _bioController.text = u.bio ?? '';
          _instaController.text = u.instagramLink ?? '';
          _youtubeController.text = u.youtubeLink ?? '';
          _facebookController.text = u.facebookLink ?? '';
          setState(() {
            _photoUrl = u.photoUrl ?? _photoUrl;
            _videoUrl = u.videoUrl ?? _videoUrl;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _instaController.dispose();
    _youtubeController.dispose();
    _facebookController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
    );
    if (result == null) return;

    final file = File(result.path);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _loading = true);
    try {
      final url = await _userService.uploadProfilePhoto(uid, file);
      await _userService.updateUser(uid, {'photoUrl': url});
      await _userService.updateAuthPhotoUrl(url);
      if (mounted) setState(() => _photoUrl = url);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to upload photo: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickVideo() async {
    final result = await _picker.pickVideo(source: ImageSource.gallery);
    if (result == null) return;

    final file = File(result.path);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _loading = true);
    try {
      final url = await _userService.uploadProfileVideo(uid, file);
      await _userService.updateUser(uid, {'videoUrl': url});
      if (mounted) setState(() => _videoUrl = url);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to upload video: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _loading = true);
    final displayName = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final bio = _bioController.text.trim();
    final instagram = _instaController.text.trim();
    final youtube = _youtubeController.text.trim();
    final facebook = _facebookController.text.trim();

    try {
      // Update Firestore user doc
      await _userService.updateUser(uid, {
        'displayName': displayName,
        'username': username,
        'bio': bio,
        'instagramLink': instagram,
        'youtubeLink': youtube,
        'facebookLink': facebook,
      });

      // Update Firebase Auth displayName and photoURL
      if (displayName.isNotEmpty)
        await _userService.updateAuthDisplayName(displayName);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile updated')));
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Update failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _loading ? null : _save,
            child: _loading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _photoUrl != null
                      ? NetworkImage(_photoUrl!)
                      : const NetworkImage('https://i.pravatar.cc/150?img=11'),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (_videoUrl != null) ...[
                SizedBox(
                  height: 120,
                  child: Center(
                    child: Text('Video selected (preview not implemented)'),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter a name' : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter a username' : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _bioController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Bio'),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _instaController,
                decoration: const InputDecoration(
                  labelText: 'Instagram profile link',
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _youtubeController,
                decoration: const InputDecoration(
                  labelText: 'YouTube channel link',
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _facebookController,
                decoration: const InputDecoration(
                  labelText: 'Facebook profile link',
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickVideo,
                      icon: const Icon(Icons.videocam),
                      label: const Text('Change video'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _loading ? null : _save,
                child: const Text('Save changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
