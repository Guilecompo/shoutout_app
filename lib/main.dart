import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shout_out_app/firebase_options.dart';
import 'package:shout_out_app/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Initializing Firebase...");
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
