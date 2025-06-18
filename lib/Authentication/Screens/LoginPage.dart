import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/Authentication/Components/Button.dart';
import 'package:notes_app/Authentication/Components/ErrorMessage.dart';
import 'package:notes_app/Authentication/Components/TextField.dart';
import 'package:notes_app/Authentication/services/google_auth.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 👇 Loader control for Google sign-in
  Future<UserCredential?>? _googleSignInFuture;

  // Email/Password Sign-In
  void signInUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      String errorMsg;
      switch (e.code) {
        case 'user-not-found':
          errorMsg = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMsg = 'Wrong password provided.';
          break;
        default:
          errorMsg = 'Login failed. Please try again.';
      }
      displayError(context, errorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Raskune App",
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Lottie.asset('assets/animations/logo.json', width: 300, height: 300),
            ),

            // 🔤 Email
            MyTextField(
              controller: emailController,
              hintText: "UserName",
              obscureText: false,
            ),
            const SizedBox(height: 10),

            // 🔑 Password
            MyTextField(
              controller: passwordController,
              hintText: "Password",
              obscureText: true,
            ),
            const SizedBox(height: 25),

            // 🔵 Sign In Button
            MyButton(
              text: "Sign In",
              onTap: () => signInUser(context),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                const Expanded(child: Divider(color: Colors.grey)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text("Or continue with", style: TextStyle(color: Colors.grey[700])),
                ),
                const Expanded(child: Divider(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),

            // 🔄 Google Sign-In with FutureBuilder Loader
            FutureBuilder<UserCredential?>(
              future: _googleSignInFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // ⏳ Show loader
                } else if (snapshot.hasError) {
                  displayError(context, "Google sign-in failed. Please try again.");
                }
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _googleSignInFuture = signInWithGoogle();
                      });
                    },
                    icon: Image.asset("assets/animations/google.jpg", height: 24),
                    label: const Text("Sign in with Google", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black12,
                      padding: const EdgeInsets.symmetric(horizontal: 110, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                );
              },
            ),

            // 🔁 Switch to Register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Not a member?"),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    " Register now",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
