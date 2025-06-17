import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final screenWidth = MediaQuery.of(context).size.width;
    final avatarSize = screenWidth * 0.3; // 30% of screen width for profile image

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),

            // 🔵 Circular Avatar with fallback image
            CircleAvatar(
              radius: avatarSize / 2,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const AssetImage('assets/animations/google.jpg') as ImageProvider,
              backgroundColor: Colors.grey[200],
            ),

            const SizedBox(height: 20),

            // 🧑 Display name or fallback
            Text(
              user?.displayName ?? "User",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            const Divider(height: 30),

            // 📧 Email
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(user?.email ?? "No email"),
            ),

            const ListTile(
              leading: Icon(Icons.work_outline),
              title: Text("Profession: Student"),
            ),
            const ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Joined on: June 15, 2024"),
            ),
            const ListTile(
              leading: Icon(Icons.verified),
              title: Text("Account Status: Verified"),
            ),
            const ListTile(
              leading: Icon(Icons.update),
              title: Text("App Version: 1.0.0"),
            ),

            const Spacer(),

            // 🔘 Logout Button
            ElevatedButton.icon(
              onPressed: () => _signOut(context),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.2, vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
