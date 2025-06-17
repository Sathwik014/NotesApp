import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/App/Screens/homePage.dart';
import 'package:notes_app/Authentication/Screens/Switch_Page.dart';

class Decider_Page extends StatelessWidget {
  const Decider_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage(); // User is signed in
          } else {
            return const SwitchPages(); // Login/Register
          }
        },
      ),
    );
  }
}
