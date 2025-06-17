import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/Authentication/Components/Button.dart';
import 'package:notes_app/Authentication/Components/TextField.dart';
import 'package:lottie/lottie.dart';

import '../Components/ErrorMessage.dart';

class Register_Page extends StatelessWidget {
  final void Function()? onTap;
  Register_Page({super.key, required this.onTap});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void registerUser(BuildContext context ) async {
    if (passwordController.text != confirmPasswordController.text) {
      displayError(context, "Passwords do not match");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } catch (e) {
      displayError(context, 'Registration Error: \$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Lottie.asset('assets/animations/logo.json', width: 300, height: 300),
            ),

            MyTextField(
              controller: emailController,
              hintText: "Email",
              obscureText: false,
            ),
            const SizedBox(height: 10),

            MyTextField(
              controller: passwordController,
              hintText: "Password",
              obscureText: true,
            ),
            const SizedBox(height: 10),

            MyTextField(
              controller: confirmPasswordController,
              hintText: "Confirm Password",
              obscureText: true,
            ),

            const SizedBox(height: 25),
            MyButton(text: "Register", onTap:() => registerUser(context)),

            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already a member?"),
                GestureDetector(
                  onTap: onTap,
                  child: const Text(
                    " Login now",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
