import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/App/Screens/profilePage.dart';
import 'package:notes_app/App/Widgets/note_tile.dart';
import 'package:notes_app/App/Screens/CalenderPage.dart';
import 'package:notes_app/Authentication/Screens/Switch_Page.dart';
import 'note_popup.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // 🔘 Keeps track of selected bottom nav tab
  final userId = FirebaseAuth.instance.currentUser!.uid; // 🔐 Get current user UID
  final TextEditingController _searchController = TextEditingController(); // 🔍 Search field controller
  String searchText = ""; // 📥 Stores search input
  String selectedCategory = 'All'; // 🔖 Current selected filter category


  // 🧾 Categories for filtering notes
  final List<String> categories = ['All', 'work', 'study', 'fitness', 'coding', 'to-do'];

  @override
  Widget build(BuildContext context) {
    // 🧭 Pages for each tab in the bottom nav bar
    final List<Widget> pages = [
      buildHomeContent(),     // 🏠 Home tab with notes
      Container(),            // ➕ Placeholder for 'New Note' (Dialog)
      Calender(),             // 📅 Calendar page
      ProfilePage(),          // 👤 Profile page
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Raskune App',
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
        ),
        actions: [
          // 🚪 Logout button
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: "Logout",
            onPressed: () async {
              // 🔃 Show loader
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );

              try {
                await FirebaseAuth.instance.signOut();

                // ✅ Remove loader and navigate to LoginPage directly
                Navigator.of(context).pop(); // remove loader
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SwitchPages()),
                      (route) => false,
                );
              } catch (e) {
                Navigator.of(context).pop(); // remove loader
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Logout failed: $e")),
                );
              }
            },

          ),
          // ⚙️ Settings icon (non-functional placeholder)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.settings_outlined),
          ),
        ],
      ),

      // 🔁 Render selected page from bottom navigation
      body: pages[_selectedIndex],

      // 🔽 Bottom navigation bar using Google Nav Bar
      bottomNavigationBar: GNav(
        onTabChange: (index) async {
          // ➕ If user taps 'New Note', open popup dialog
          if (index == 1) {
            await showDialog(
              context: context,
              builder: (_) => NotePopup(),
            );
          } else {
            // 🔁 Switch tabs
            setState(() => _selectedIndex = index);
          }
        },
        color: Colors.white,
        backgroundColor: Colors.black,
        activeColor: Colors.white,
        tabBackgroundColor: Colors.grey.shade800,
        gap: 15,
        tabs: const [
          GButton(icon: Icons.home_outlined, text: "Home"),
          GButton(icon: Icons.add_box_outlined, text: "New Note"),
          GButton(icon: Icons.calendar_month_outlined, text: 'Calender'),
          GButton(icon: Icons.account_circle_outlined, text: 'Profile'),
        ],
      ),
    );
  }

  // 🏡 Builds the main content of Home tab (notes list with search/filter)
  Widget buildHomeContent() {
    // 🔥 Get notes reference from Firestore, ordered by latest
    final notesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('timestamp', descending: true);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔍 Search field
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search notes...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onChanged: (val) => setState(() => searchText = val.toLowerCase()),
            ),
          ),

          // 🔖 Horizontal scrollable category filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: categories.map((category) {
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      category[0].toUpperCase() + category.substring(1),
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => selectedCategory = category);
                    },
                    selectedColor: Colors.amber[400],
                    backgroundColor: Colors.grey.shade800,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // 📝 Section title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'My Notes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // 📋 List of notes (filtered by search/category)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: notesRef.snapshots(),
              builder: (context, snapshot) {
                // 🕒 Show loading spinner while fetching
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                // 🧠 Filter notes based on search and selected category
                final notes = snapshot.data!.docs.where((doc) {
                  final title = doc['title']?.toLowerCase() ?? '';
                  final category = doc['category']?.toLowerCase() ?? '';

                  final matchesSearch = title.contains(searchText);
                  final matchesCategory =
                      selectedCategory == 'All' || category == selectedCategory.toLowerCase();

                  return matchesSearch && matchesCategory;
                }).toList();

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ❌ No matching notes
                if (!snapshot.hasData || notes.isEmpty) {
                  return const Center(
                    child: Text(
                      'No notes found.\nTry adding some!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                // ✅ Display notes in a grid format
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: notes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two columns
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8, // Aspect ratio of note tiles
                  ),
                  itemBuilder: (context, index) => NoteTile(note: notes[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
