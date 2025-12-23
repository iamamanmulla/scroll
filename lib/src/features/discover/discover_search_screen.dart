import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scroll/services/search_service.dart';
import 'package:scroll/models/user_model.dart';
import '../profile/user_profile_screen.dart';

class DiscoverSearchScreen extends StatefulWidget {
  const DiscoverSearchScreen({super.key});

  @override
  State<DiscoverSearchScreen> createState() => _DiscoverSearchScreenState();
}

class _DiscoverSearchScreenState extends State<DiscoverSearchScreen> {
  final _searchController = TextEditingController();
  final _searchService = SearchService();
  Timer? _debounce;
  String _query = '';
  Future<List<UserModel>>? _resultsFuture;

  void _onSearchChanged() {
    final q = _searchController.text.trim().toLowerCase();
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _query = q;
        if (q.isEmpty) {
          _resultsFuture = null;
        } else {
          _resultsFuture = _searchService.searchUsers(query: q);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search users',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.black),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_query.isEmpty) {
      return const Center(child: Text('Search for users by username'));
    }

    return FutureBuilder<List<UserModel>>(
      future: _resultsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final results = snapshot.data ?? [];
        if (results.isEmpty) return const Center(child: Text('No users found'));

        return ListView.separated(
          itemCount: results.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final u = results[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: u.photoUrl != null
                    ? NetworkImage(u.photoUrl!)
                    : const NetworkImage('https://i.pravatar.cc/150?img=11'),
              ),
              title: Text(u.displayName ?? u.username ?? u.email),
              subtitle: Text('@${u.username ?? u.email.split('@').first}'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserProfileScreen(uid: u.uid),
                    ),
                  );
                },
                child: const Text('Profile'),
              ),
            );
          },
        );
      },
    );
  }
}
