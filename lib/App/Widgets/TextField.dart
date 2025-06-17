import 'package:flutter/material.dart';

/// 🔤 Custom Text Field widget used across app
class Text_Field extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const Text_Field({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: Colors.black,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[700]),

          /// 🔲 Borders
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade500),
          ),
        ),
      ),
    );
  }
}
