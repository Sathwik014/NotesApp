import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/Authentication/Components/Button.dart';
import 'package:notes_app/Authentication/Components/ErrorMessage.dart';
import 'package:notes_app/Authentication/Components/TextField.dart';
import 'package:notes_app/Authentication/services/google_auth.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signInUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // You can navigate to the home screen here
     } on FirebaseAuthException catch (e) {
      String errorMsg;

      switch (e.code) {
        case 'user-not-found':
          errorMsg = 'No user found with that email.';
          break;
        case 'wrong-password':
          errorMsg = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMsg = 'Invalid email address.';
          break;
        case 'user-disabled':
          errorMsg = 'This user account has been disabled.';
          break;
        default:
          errorMsg = 'An unexpected error occurred. Please try again.';
      }
         displayError(context, errorMsg); // ← Show Lottie error dialog
      } catch (e) {
         displayError(context, 'Something went wrong. Please try again.');
      }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(10),
            child: const Text("Raskune App",
              style: TextStyle(fontSize: 34,
              fontWeight: FontWeight.bold),
                  ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Lottie.asset('assets/animations/logo.json', width: 300, height: 300),
            ),

            MyTextField(
              controller: emailController,
              hintText: "UserName",
              obscureText: false,
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: passwordController,
              hintText: "Password",
              obscureText: true,
            ),

            const SizedBox(height: 25),
            MyButton(text: "Sign In", onTap: () => signInUser(context)) ,
            const SizedBox(height: 20),

            const DividerWithText(),

            // Google Sign In Button
            Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton.icon(
                  onPressed: () async {
                    final userCredential = await signInWithGoogle();
                    if (userCredential == null) {
                      displayError(context, "Google sign-in failed. Please try again.");
                    }
                  },
                  icon: Image.asset("assets/animations/google.jpg", height: 24),
                  label: const Text("Sign in with Google",
                       style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black12,
                  padding: const EdgeInsets.symmetric(horizontal: 110,vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Not a member?"),
                GestureDetector(
                  onTap: onTap,
                  child: const Text(
                    " Register now",
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

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.grey)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text("Or continue with", style: TextStyle(color: Colors.grey[700])),
        ),
        const Expanded(child: Divider(color: Colors.grey)),
      ],
    );
  }
}
