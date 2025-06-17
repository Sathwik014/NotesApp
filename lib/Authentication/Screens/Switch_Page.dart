import 'package:flutter/material.dart';
import 'package:notes_app/Authentication/Screens/LoginPage.dart';
import 'package:notes_app/Authentication/Screens/RegisterPage.dart';

class SwitchPages extends StatefulWidget {
  const SwitchPages({super.key});

  @override
  State<SwitchPages> createState() => _SwitchPagesState();
}

class _SwitchPagesState extends State<SwitchPages> {
  bool showLogin = true;

  void togglePages() {
    setState(() => showLogin = !showLogin);
  }

  @override
  Widget build(BuildContext context) {
    return showLogin
        ? LoginPage(onTap: togglePages)
        : Register_Page(onTap: togglePages);
  }
}
