import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteSearch extends SearchDelegate {
  final Query notesRef;

  NoteSearch(this.notesRef);

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: notesRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        final results = snapshot.data!.docs.where((doc) {
          final title = doc['title']?.toLowerCase() ?? '';
          return title.contains(query.toLowerCase());
        }).toList();

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

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );
}
