import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:flutter/material.dart';

import '../components/my_drawer.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  //chat & auth service
  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: _buildUserLIst(),
      drawer: const MyDrawer(),
    );
  }

//build a list of users except for the current logged in user
  Widget _buildUserLIst() {
    return StreamBuilder(
      stream: _chatServices.getUsersStreamExceptBlocked(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>(
                (userData) => _buildUserLIstItem(context, userData),
              )
              .toList(),
        );
      },
    );
  }

  // build individial list tile for user
  Widget _buildUserLIstItem(BuildContext context, dynamic userData) {
    //display all users except current user
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () async {
          //mark all messages as read
          await _chatServices.markMessagesAsRead(userData["uid"]);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                reciverEmail: userData["email"],
                reciverID: userData["uid"],
              ),
            ),
          );
        },
        unreadMessagesCount: userData['unreadCount'],
      );
    } else {
      return Container();
    }
  }
}
