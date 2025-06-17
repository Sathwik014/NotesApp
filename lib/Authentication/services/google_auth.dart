import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// 🔐 Signs in the user using Google and returns a UserCredential
Future<UserCredential?> signInWithGoogle() async {
  try {
    // 📲 Starts Google Sign-In flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // 👤 User cancelled login

    // 🧠 Get Google authentication tokens
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // 🔑 Create Firebase credential using Google token
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // 🔐 Sign in to Firebase with credential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print("Google Sign-In Error: $e"); // ❌ Log error
    return null;
  }
}
