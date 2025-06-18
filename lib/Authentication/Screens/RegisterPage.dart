import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/Authentication/Components/Button.dart';
import 'package:notes_app/Authentication/Components/TextField.dart';
import 'package:lottie/lottie.dart';
import '../Components/ErrorMessage.dart';

class Register_Page extends StatefulWidget {
  final void Function()? onTap;

  Register_Page({super.key, required this.onTap});

  @override
  State<Register_Page> createState() => _Register_PageState();
}

class _Register_PageState extends State<Register_Page> {
  // Controllers to collect input
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<UserCredential>? _registerFuture;

  // Function to initiate user registration
  Future<UserCredential> registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      throw Exception("Passwords do not match");
    }

    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: FutureBuilder<UserCredential>(
        future: _registerFuture,
        builder: (context, snapshot) {
          // While waiting for the future to complete
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If an error occurred
          if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              displayError(context, snapshot.error.toString());
              setState(() {
                _registerFuture = null; // Reset future
              });
            });
          }

          // Registration successful (Optional handling)
          if (snapshot.hasData) {
          }

          // Main registration form
          return SingleChildScrollView(
            child: Column(
              children: [
                // Animated logo
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Lottie.asset('assets/animations/logo.json', width: 300, height: 300),
                ),

                // Email input field
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                // Password input field
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                // Confirm password input
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),
                const SizedBox(height: 25),

                // Register button
                MyButton(
                  text: "Register",
                  onTap: () {
                    setState(() {
                      _registerFuture = registerUser();
                    });
                  },
                ),
                const SizedBox(height: 15),

                // Switch to login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a member?"),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        " Login now",
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
