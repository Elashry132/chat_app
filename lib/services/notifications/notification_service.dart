import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

class NOtificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _messageStreamController = BehaviorSubject<RemoteMessage>();

  // request premission call this in main startuo
  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission: ${settings.authorizationStatus}');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print(
          'User granted provisional permission: ${settings.authorizationStatus}');
    } else {
      print(
          'User declined or have not accepted permission: ${settings.authorizationStatus}');
    }
  }

  // setup interations
  void setupInterations() {
    FirebaseMessaging.onMessage.listen((event) {
      print('Got a message whilst in the foreground! ${event.data}');
      print('messagedata: ${event.data}');
      _messageStreamController.add(event);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('Messege clicked');
    });
  }

  void dispose() {
    _messageStreamController.close();
  }

  //set token listeners
  void setTokenListeners() {
    FirebaseMessaging.instance.getToken().then((token) {
      saveTokenToDataBase(token);
    });
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDataBase);
  }

  //save device token
  void saveTokenToDataBase(String? token) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    //if current user is logged i and has a token sve it todb
    if (userId != null && token != null) {
      FirebaseFirestore.instance.collection('users').doc(userId).set(
        {
          'fcmToken': token,
        },
        SetOptions(
          merge: true,
        ),
      );
    }
  }

  //clear device token
  Future<void> clearTokenOnLogout(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': FieldValue.delete(),
      });
      print('token cleared');
    } catch (e) {
      print('error clearing token $e');
    }
  }
}
