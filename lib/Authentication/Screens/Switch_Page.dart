import 'package:flutter/material.dart';
import 'package:notes_app/Authentication/Screens/LoginPage.dart';
import 'package:notes_app/Authentication/Screens/RegisterPage.dart';

/// 🔁 This widget switches between login and register pages
class SwitchPages extends StatefulWidget {
  const SwitchPages({super.key});

  @override
  State<SwitchPages> createState() => _SwitchPagesState();
}

class _SwitchPagesState extends State<SwitchPages> {
  /// 👈 Flag to determine which screen to show
  bool showLogin = true;

  /// 🔀 Toggles between login and register screens
  void togglePages() {
    setState(() => showLogin = !showLogin);
  }

  @override
  Widget build(BuildContext context) {
    /// 👇 Show either Login or Register based on `showLogin` flag
    return showLogin
        ? LoginPage(onTap: togglePages)
        : Register_Page(onTap: togglePages);
  }
}
