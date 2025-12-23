import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scroll/models/user_model.dart';
import 'package:scroll/services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProfileService _profileService = ProfileService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  UserModel? _userModel;
  bool _isLoading = false;
  File? _imageFile;
  File? _videoFile;

  // Controllers for text fields
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _instagramController;
  late TextEditingController _youtubeController;
  late TextEditingController _facebookController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchUserData();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _bioController = TextEditingController();
    _instagramController = TextEditingController();
    _youtubeController = TextEditingController();
    _facebookController = TextEditingController();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);
    final userAuth = _auth.currentUser;
    if (userAuth != null) {
      UserModel? user = await _profileService.getUserProfile(userAuth.uid);

      if (user != null) {
        _userModel = user;
        _nameController.text = user.displayName ?? '';
        _usernameController.text = user.username ?? '';
        _bioController.text = user.bio ?? '';
        _instagramController.text = user.instagramLink ?? '';
        _youtubeController.text = user.youtubeLink ?? '';
        _facebookController.text = user.facebookLink ?? '';
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => _videoFile = File(pickedFile.path));
      // Note: You'd typically use a video player package to preview this thumbnail
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    String uid = _auth.currentUser!.uid;
    String? newPhotoUrl = _userModel?.photoUrl;
    String? newVideoUrl = _userModel?.videoUrl;

    try {
      // 1. Check username uniqueness if it changed
      if (_usernameController.text != _userModel?.username) {
        bool isTaken = await _profileService.isUsernameTaken(
          _usernameController.text,
          uid,
        );
        if (isTaken) {
          throw Exception("Username already taken.");
        }
      }

      // 2. Upload new photo if picked
      if (_imageFile != null) {
        newPhotoUrl = await _profileService.uploadFile(
          _imageFile!,
          'user_media/$uid/profile_photo.jpg',
        );
      }

      // 3. Upload new video if picked
      if (_videoFile != null) {
        newVideoUrl = await _profileService.uploadFile(
          _videoFile!,
          'user_media/$uid/profile_video.mp4',
        );
      }

      // 4. Update user model
      UserModel updatedUser = UserModel(
        uid: uid,
        email: _auth.currentUser!.email!,
        displayName: _nameController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        photoUrl: newPhotoUrl,
        videoUrl: newVideoUrl,
        instagramLink: _instagramController.text,
        youtubeLink: _youtubeController.text,
      );

      // 5. Save to Firestore
      await _profileService.updateUserProfile(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString().replaceAll("Exception: ", "")}',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _userModel == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).canPop()
              ? Navigator.of(context).pop()
              : null, // Just for safe pop, though usually pushed
        ),
        title: const Text(
          'Edit profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: const Text('Save', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body:
          _isLoading &&
              _userModel !=
                  null // Show loading overlay if saving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Photo & Video Picker Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMediaPicker(
                          label: 'Change photo',
                          icon: Icons.camera_alt,
                          onTap: _pickImage,
                          imageFile: _imageFile,
                          networkUrl: _userModel?.photoUrl,
                        ),
                        _buildMediaPicker(
                          label: 'Change video',
                          icon: Icons.videocam,
                          onTap: _pickVideo,
                          imageFile:
                              _videoFile, // For video, you'd show a thumbnail or icon
                          networkUrl: _userModel
                              ?.videoUrl, // For video, you'd show a thumbnail or icon
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Profile Fields
                    _buildProfileField('Name', _nameController),
                    _buildProfileField(
                      'Username',
                      _usernameController,
                      validator: (val) {
                        if (val == null || val.isEmpty)
                          return 'Username cannot be empty';
                        if (val.length < 3) return 'Username too short';
                        return null;
                      },
                    ),
                    _buildProfileField('Bio', _bioController, maxLines: 3),
                    _buildProfileField(
                      'Instagram',
                      _instagramController,
                      hint: 'Add Instagram link',
                    ),
                    _buildProfileField(
                      'YouTube',
                      _youtubeController,
                      hint: 'Add YouTube link',
                    ),
                    _buildProfileField(
                      'Facebook',
                      _facebookController,
                      hint: 'Add Facebook link',
                    ), // Added Facebook field
                  ],
                ),
              ),
            ),
    );
  }

  // Helper widget for circular media pickers
  Widget _buildMediaPicker({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    File? imageFile,
    String? networkUrl,
  }) {
    ImageProvider? backgroundImage;
    if (imageFile != null) {
      backgroundImage = FileImage(imageFile);
    } else if (networkUrl != null && networkUrl.isNotEmpty) {
      backgroundImage = NetworkImage(networkUrl);
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[200],
            backgroundImage: backgroundImage,
            child: backgroundImage == null
                ? Icon(icon, size: 30, color: Colors.grey[800])
                : null,
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // Helper widget for form fields that look like list tiles
  Widget _buildProfileField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  maxLines: maxLines,
                  validator: validator,
                  decoration: InputDecoration(
                    hintText: hint ?? label,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _instagramController.dispose();
    _youtubeController.dispose();
    _facebookController.dispose();
    super.dispose();
  }
}
