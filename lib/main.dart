import 'package:chat_app/services/auth/auth_gate.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/services/notifications/notification_service.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_handleNotificationBackground);

  //request permission
  final notification = NOtificationService();
  await notification.requestPermission();
  notification.setupInterations();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

// notification background handler
Future<void> _handleNotificationBackground(RemoteMessage message) async {
  print("handling a background message: ${message.messageId}");
  print("message data: ${message.data}");
  print(" message notification: ${message.notification?.title}");
  print(" message notification: ${message.notification?.body}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
      },
    );
  }
}
