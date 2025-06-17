import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/App/Screens/profilePage.dart';
import 'package:notes_app/App/Widgets/note_tile.dart';
import 'package:notes_app/Authentication/Screens/CalenderPage.dart';
import 'note_popup.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _searchController = TextEditingController();
  String searchText = "";
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'work', 'study', 'fitness', 'coding', 'to-do'];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      buildHomeContent(),
      Container(), // Placeholder for new note
      Calender(),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Raskune App',
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: "Logout",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false); // Replace '/login'
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: pages[_selectedIndex],
        bottomNavigationBar: GNav(
          onTabChange: (index) async {
            if (index == 1) {
              await showDialog(
                context: context,
                builder: (_) => NotePopup(),);
            } else{
              setState(() => _selectedIndex = index);
            }
          },
          color: Colors.white,
          backgroundColor: Colors.black,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey.shade800,
          gap: 15,
          tabs: [
            GButton(icon: Icons.home_outlined, text: "Home"),
            GButton(icon: Icons.add_box_outlined, text: "New Note"),
            GButton(icon: Icons.calendar_month_outlined,text: 'Calender'),
            GButton(icon: Icons.account_circle_outlined, text: 'Profile'),
           ],
        ),
    );
  }
  Widget buildHomeContent() {
    final notesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('timestamp', descending: true);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search notes...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onChanged: (val) => setState(() => searchText = val.toLowerCase()),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
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
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text('My Notes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: notesRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                final notes = snapshot.data!.docs.where((doc) {
                  final title = doc['title']?.toLowerCase() ?? '';
                  final category = doc['category']?.toLowerCase() ?? '';

                  final matchesSearch = title.contains(searchText);
                  final matchesCategory = selectedCategory == 'All' || category == selectedCategory.toLowerCase();

                  return matchesSearch && matchesCategory;
                }).toList();
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || notes.isEmpty) {
                  return Center(
                    child: Text(
                      'No notes found.\nTry adding some!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }


                return GridView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: notes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
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
