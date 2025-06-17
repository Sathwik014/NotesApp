import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 🔍 Search delegate for finding notes by title
class NoteSearch extends SearchDelegate {
  final Query notesRef;

  // Constructor accepting the Firestore notes query
  NoteSearch(this.notesRef);

  /// 📄 Suggestions based on user input
  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: notesRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        // Filter notes where title contains search query
        final results = snapshot.data!.docs.where((doc) {
          final title = doc['title']?.toLowerCase() ?? '';
          return title.contains(query.toLowerCase());
        }).toList();

        // Render filtered list
        return ListView(
          children: results.map((doc) {
            return ListTile(
              title: Text(doc['title']),
              subtitle: Text(doc['content']),
            );
          }).toList(),
        );
      },
    );
  }

  /// ✅ Show suggestions as results too
  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  /// ❌ Clear search bar
  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')
  ];

  /// 🔙 Back arrow in search bar
  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );
}
