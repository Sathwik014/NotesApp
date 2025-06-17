import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes_app/App/Screens/splashPage.dart';
import 'package:notes_app/Authentication/Screens/PageDecider.dart';
import 'Authentication/services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const RaskuneApp());
}

class RaskuneApp extends StatelessWidget {
  const RaskuneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raskune App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Splash(), // Auto navigates based on login status
    );
  }
}
