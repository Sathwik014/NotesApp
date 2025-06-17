import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Screens/note_editor.dart';
import 'package:intl/intl.dart';

/// 🗒️ NoteTile displays an individual note in the grid view on HomePage.
class NoteTile extends StatelessWidget {
  final QueryDocumentSnapshot note;

  NoteTile({required this.note});

  /// 🎨 List of random background colors for notes
  final List<Color> tileColors = [
    Colors.orange.shade100,
    Colors.blue.shade100,
    Colors.pink.shade100,
    Colors.green.shade100,
    Colors.purple.shade100,
    Colors.teal.shade100,
    Colors.amber.shade100,
    Colors.cyan.shade100,
    Colors.indigo.shade100,
    Colors.lime.shade100,
    Colors.red.shade100,
    Colors.deepPurple.shade100,
  ];

  /// 🏷️ Category icons based on note type
  final Map<String, IconData> categoryIcons = {
    'work': Icons.work,
    'study': Icons.book,
    'fitness': Icons.fitness_center,
    'coding': Icons.code,
    'to-do': Icons.check_circle,
  };

  @override
  Widget build(BuildContext context) {
    // 🎨 Random background color for this tile
    final color = tileColors[Random().nextInt(tileColors.length)];

    // 📄 Get data from the Firestore document
    final data = note.data() as Map<String, dynamic>;

    // 🏷️ Extract and normalize category
    final String category = (data['category'] ?? 'work').toString().toLowerCase().trim();
    final icon = categoryIcons[category] ?? Icons.note;

    // 📌 Check if note is pinned
    final bool isPinned = data['pinned'] ?? false;

    // 🕓 Format the timestamp
    final Timestamp? timestamp = data['timestamp'];
    final String formattedTime = timestamp != null
        ? DateFormat('MMM d, h:mm a').format(timestamp.toDate())
        : 'Unknown time';

    return GestureDetector(
      onTap: () {
        /// 👉 Navigate to NoteEditor when tile is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NoteEditor(note: note),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔝 Top row: Title and Delete Button
            Row(
              children: [
                // 📝 Note title
                Expanded(
                  child: Text(
                    data['title'] ?? '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[900]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // 🗑️ Delete icon
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey[900]),
                  onPressed: () {
                    // 🧾 Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Confirm Delete'),
                        content: Text('Delete "${data['title']}"?'),
                        actions: [
                          // ❌ Cancel
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Cancel"),
                          ),
                          // ✅ Confirm Delete
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context); // Close dialog
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(data['userId']) // 🔒 User-specific note
                                  .collection('notes')
                                  .doc(note.id)
                                  .delete();
                            },
                            child: Text("Delete", style: TextStyle(color: Colors.red)),
                          )
                        ],
                      ),
                    );
                  },
                )
              ],
            ),

            SizedBox(height: 6),

            /// 📄 Note content
            Expanded(
              child: Text(
                data['content'] ?? '',
                style: TextStyle(fontSize: 14, color: Colors.grey[900]),
                overflow: TextOverflow.fade,
                maxLines: 4,
                softWrap: true,
              ),
            ),

            SizedBox(height: 6),

            /// 🔖 Category and Timestamp Row
            Row(
              children: [
                Icon(icon, size: 12, color: Colors.black),
                SizedBox(width: 4),
                // 🏷️ Category label
                Text(
                  category[0].toUpperCase() + category.substring(1),
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10, color: Colors.black),
                ),
                Spacer(),
                // 🕓 Timestamp
                Text(
                  formattedTime,
                  style: TextStyle(fontSize: 10, color: Colors.black),
                ),
                // 📌 Pinned icon (if note is pinned)
                if (isPinned)
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 2.0),
                    child: Icon(Icons.push_pin, size: 14, color: Colors.black),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
