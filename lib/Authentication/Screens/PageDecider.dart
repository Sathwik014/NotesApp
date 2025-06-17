import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/App/Screens/homePage.dart';
import 'package:notes_app/Authentication/Screens/Switch_Page.dart';

/// 🔍 This widget listens to auth state (login/logout)
/// and navigates user to Home or Login/Register screen accordingly.
class Decider_Page extends StatelessWidget {
  const Decider_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 🔁 StreamBuilder rebuilds when the user's auth state changes
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            /// ✅ User is signed in → Go to home page
            return HomePage();
          } else {
            /// 🔐 User not signed in → Show login/register
            return const SwitchPages();
          }
        },
      ),
    );
  }
}
