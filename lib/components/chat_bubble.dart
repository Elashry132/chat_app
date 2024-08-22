// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/themes/theme_provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId,
  });

  // show options
  void _showOption(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
            child: Wrap(
          children: [
            // report button
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report'),
              onTap: () {
                Navigator.pop(context);
                // report logic here
                _reportMessage(context, messageId, userId);
              },
            ),

            //block user button
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Block User'),
              onTap: () {
                Navigator.pop(context);
                _blockUser(context, userId);
              },
            ),

            //cancel button
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ));
      },
    );
  }

  // report message
  void _reportMessage(
    BuildContext context,
    String messageId,
    String userId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text('Report Message'),
          content: const Text('Please enter a reason for reporting'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ChatServices().reportUser(userId, messageId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reported Successfully'),
                  ),
                );
              },
              child: const Text('Report'),
            ),
          ]),
    );
  }

  //block user
  void _blockUser(
    BuildContext context,
    String userId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text('Block User'),
          content: const Text('Please enter a reason for Blocking'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ChatServices().blockUser(userId);
                // dismiss dialog
                Navigator.pop(context);
                // dismiss page
                Navigator.pop(context);
                // let user know of the result
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Blocked Successfully'),
                  ),
                );
              },
              child: const Text('Block'),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // light vs dark mode for correct bubble colors
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          //show options
          _showOption(context, messageId, userId);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 25,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? (isDarkMode ? Colors.grey.shade500 : Colors.green.shade600)
              : (isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isCurrentUser
                ? Colors.white
                : (isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
