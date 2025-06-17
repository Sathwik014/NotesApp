import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // 🔓 Firebase Sign Out Function
  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // 🧭 Redirect to LoginPage after logout
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final screenWidth = MediaQuery.of(context).size.width;
    final avatarSize = screenWidth * 0.3; // Avatar is 30% of screen width

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // 🖼️ Profile picture (Google photo or fallback)
            CircleAvatar(
              radius: avatarSize / 2,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const AssetImage('assets/animations/google.jpg') as ImageProvider,
              backgroundColor: Colors.grey[200],
            ),

            const SizedBox(height: 20),

            // 👤 Display Name (if available)
            Text(
              user?.displayName ?? "User",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            const Divider(height: 30),

            // 📧 Email info
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(user?.email ?? "No email"),
            ),

            // 👨 Profession - Hardcoded for now
            const ListTile(
              leading: Icon(Icons.work_outline),
              title: Text("Profession: Student"),
            ),

            // 📅 Static joining info
            const ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Joined on: June 15, 2024"),
            ),

            // ✅ Verified status
            const ListTile(
              leading: Icon(Icons.verified),
              title: Text("Account Status: Verified"),
            ),

            // 🔧 App version
            const ListTile(
              leading: Icon(Icons.update),
              title: Text("App Version: 1.0.0"),
            ),

            const Spacer(),

            // 🚪 Logout button
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
                  horizontal: screenWidth * 0.2,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
