import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatServices extends ChangeNotifier {
  // get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get all user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('users').snapshots().map((event) {
      return event.docs.map((doc) => doc.data()).toList();
    });
  }

  // get all users stream exceot blocked users
  Stream<List<Map<String, dynamic>>> getUsersStreamExceptBlocked() {
    final currentUser = _auth.currentUser;

    return _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      //get all users
      final usersSnapshot = await _firestore.collection('users').get();

      // return as stream list
      final userData = await Future.wait(
        // get all the docs
        usersSnapshot.docs
            .where(
          (doc) =>
              doc.data()['email'] != currentUser.email &&
              !blockedUserIds.contains(doc.id),
        )
            .map(
          (doc) async {
            final userData = doc.data();
            final chatRoomID = [currentUser.uid, doc.id]..sort();
            final unreadMessagesSnapShot = await _firestore
                .collection('chat_rooms')
                .doc(
                  chatRoomID.join('_'),
                )
                .collection('messages')
                .where('receiverID', isEqualTo: currentUser.uid)
                .where('isRead', isEqualTo: false)
                .get();

            userData['unreadCount'] = unreadMessagesSnapShot.docs.length;
            return userData;
          },
        ).toList(),
      );
      return userData;
    });
  }

  // mark messages as read
  Future<void> markMessagesAsRead(String receiverId) async {
    final currentUserID = _auth.currentUser!.uid;
    //get chat room
    List<String> ids = [currentUserID, receiverId];
    ids.sort();
    final chatRoomID = ids.join('_');
    // get unread message
    final unreadMessagesSnapShot = _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .where('receiverID', isEqualTo: currentUserID)
        .where('isRead', isEqualTo: false);

    final unreadMessagesSnapSHot = await unreadMessagesSnapShot.get();

    //go through each messages and mark as read
    for (var doc in unreadMessagesSnapSHot.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  //send message
  Future<void> sendMessage(String receiverId, String message) async {
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUseremail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newmessage = Message(
      senderID: currentUserID,
      senderEmail: currentUseremail,
      receiverID: receiverId,
      message: message,
      timestamp: timestamp,
      isRead: false,
    );

    //construct chat room id for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    // add new message to database
    await _firestore
        .collection('chat_rooms') // Adjusted to match the retrieval path
        .doc(chatRoomId)
        .collection('messages') // Ensure this matches the retrieval
        .add(newmessage.toMap());
  }

  //get messgaes
  Stream<QuerySnapshot> getMessage(String userID, otherUserID) {
    // construct a chatroom ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // report user
  Future<void> reportUser(String userId, String messageId) async {
    //get current user info
    final currentUser = _auth.currentUser;

    final resport = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timeStamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('Reports').add(resport);
  }

  //block user
  Future<void> blockUser(String userId) async {
    //get current user info
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userId)
        .set({});
    notifyListeners();
  }

  //unblock user
  Future<void> unblockUser(String blockedUserId) async {
    //get current user info
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserId)
        .delete();
  }

  //get blocked user
  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap(
      (snapshot) async {
        // get list of blocked userids
        final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

        final userDocs = await Future.wait(
          blockedUserIds.map(
            (id) => _firestore.collection('users').doc(id).get(),
          ),
        );

        debugPrint(
            "blocked user:${userDocs.map((doc) => doc.data() as Map<String, dynamic>)}");

        return userDocs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList(); // return list of blocked users
      },
    );
  }
}
