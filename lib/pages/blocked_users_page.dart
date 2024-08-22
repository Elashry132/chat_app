import 'package:chat_app/components/user_tile.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';
import '../services/chat/chat_services.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  // chat & auth service
  final AuthService _authService = AuthService();
  final ChatServices _chatService = ChatServices();

  void _showUnBlockBox(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unblock'),
        content: const Text('Are you sure you want to unblock this user?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _chatService.unblockUser(userId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User unblocked'),
                ),
              );
            },
            child: const Text('Unblock'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = _authService.getCurrentUser()!.uid;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Blocked Users'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _chatService.getBlockedUsersStream(userId),
        builder: (context, snapshot) {
          // error
          if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          }
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final blockedUsers = snapshot.data ?? [];

          //no users
          if (blockedUsers.isEmpty) {
            return const Center(child: Text('No blocked users'));
          }

          // load complete
          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final user = blockedUsers[index];
              return UserTile(
                text: user['email'],
                onTap: () => _showUnBlockBox(
                  context,
                  user['uid'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
