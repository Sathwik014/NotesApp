import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Screens/note_editor.dart';
import 'package:intl/intl.dart';

class NoteTile extends StatelessWidget {
  final QueryDocumentSnapshot note;
  NoteTile({required this.note});

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

  final Map<String, IconData> categoryIcons = {
    'work': Icons.work,
    'study': Icons.book,
    'fitness': Icons.fitness_center,
    'coding': Icons.code,
    'to-do': Icons.check_circle,
  };

  @override
  Widget build(BuildContext context) {
    final color = tileColors[Random().nextInt(tileColors.length)];
    final data = note.data() as Map<String, dynamic>;

    final String category = (data['category'] ?? 'work').toString().toLowerCase().trim();
    final icon = categoryIcons[category] ?? Icons.note;
    final bool isPinned = data['pinned'] ?? false;

    final Timestamp? timestamp = data['timestamp'];
    final String formattedTime = timestamp != null
        ? DateFormat('MMM d, h:mm a').format(timestamp.toDate())
        : 'Unknown time';

    return GestureDetector(
      onTap: () {
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
            // Top row: title and delete button
            Row(
              children: [
                Expanded(
                  child: Text(
                    data['title'] ?? '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[900]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey[900]),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Confirm Delete'),
                        content: Text('Delete "${data['title']}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(data['userId'])
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

            // Content
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

            // Category row
            Row(
              children: [
                Icon(icon, size: 12, color: Colors.black),
                SizedBox(width: 4),
                Text(
                  category[0].toUpperCase() + category.substring(1),
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10, color: Colors.black),
                ),
                Spacer(),
                Text(
                  formattedTime,
                  style: TextStyle(fontSize: 10, color: Colors.black),
                ),
                if (isPinned)
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0,right: 2.0),
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
