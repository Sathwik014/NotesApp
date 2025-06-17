import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

/// 🧾 This is the editor screen used for creating or editing a note.
class NoteEditor extends StatefulWidget {
  final DocumentSnapshot? note; // Existing note to edit (if any)
  final String? prefilledTitle; // Title prefilled from NotePopup
  final String? prefilledContent; // Content (not used now)
  final DateTime? prefilledDate; // Date from NotePopup

  NoteEditor({this.note, this.prefilledTitle, this.prefilledContent, this.prefilledDate});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  // 🔤 Text controllers for title and content input
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  // 🎯 Focus node for content TextField
  final FocusNode _contentFocus = FocusNode();

  // 🏷️ Note meta
  String _selectedCategory = 'work'; // Default category
  DateTime _noteDate = DateTime.now(); // Default to current date
  bool _isPinned = false; // Pinned toggle

  // 📂 Available categories
  final List<String> _categories = ['work', 'study', 'fitness', 'coding', 'to-do'];

  // 🖼️ Icons for each category
  final Map<String, IconData> _categoryIcons = {
    'work': Icons.work,
    'study': Icons.book,
    'fitness': Icons.fitness_center,
    'coding': Icons.code,
    'to-do': Icons.check_circle,
  };

  // 🎨 Text color state
  Color _selectedTextColor = Colors.white;

  @override
  void initState() {
    super.initState();
    // If editing an existing note
    if (widget.note != null) {
      final data = widget.note!.data() as Map<String, dynamic>;
      _titleController.text = data['title'] ?? '';
      _contentController.text = data['content'] ?? '';
      _selectedCategory = data['category'] ?? 'work';
      _noteDate = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
      _isPinned = data['pinned'] ?? false;
    } else {
      // If creating a new note with prefilled values
      _titleController.text = widget.prefilledTitle ?? '';
      _contentController.text = widget.prefilledContent ?? '';
      _noteDate = widget.prefilledDate ?? DateTime.now();
    }
  }

  /// 💾 Save the note to Firestore (create or update)
  Future<void> saveNote() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final notesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notes');

    final data = {
      'title': _titleController.text,
      'content': _contentController.text,
      'timestamp': Timestamp.fromDate(_noteDate),
      'userId': uid,
      'category': _selectedCategory,
      'pinned': _isPinned,
    };

    if (widget.note == null) {
      await notesRef.add(data); // Add new note
    } else {
      await notesRef.doc(widget.note!.id).update(data); // Update existing note
    }

    Navigator.pop(context); // Go back to previous screen
  }

  /// 🔤 Wrap selected text in markdown syntax
  void insertMarkdown(String syntax) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final selectedText = selection.textInside(text);

    final newText = syntax + selectedText + syntax;
    final updated = selection.textBefore(text) + newText + selection.textAfter(text);

    _contentController.text = updated;
    _contentController.selection = TextSelection.collapsed(
      offset: selection.start + newText.length,
    );
  }

  /// 🎨 Change text color
  void applyColorToSelectedText(Color color) {
    setState(() {
      _selectedTextColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, MMM d').format(_noteDate); // e.g. Monday, Jun 17

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? 'Edit Note' : 'New Note'),
        actions: [
          // 📌 Pin icon toggle
          IconButton(
            icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
            onPressed: () => setState(() => _isPinned = !_isPinned),
          ),
          // ✅ Save icon
          IconButton(icon: Icon(Icons.check), onPressed: saveNote),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// 🔽 Category selector & Date
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 📂 Category Dropdown
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      borderRadius: BorderRadius.circular(16),
                      dropdownColor: Colors.black,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      icon: Icon(Icons.arrow_drop_down),
                      items: _categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Row(
                            children: [
                              Icon(_categoryIcons[category], size: 20, color: Colors.grey[700]),
                              SizedBox(width: 6),
                              Text(category[0].toUpperCase() + category.substring(1)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedCategory = value!),
                    ),
                  ),
                  // 📅 Date text
                  Text(formattedDate, style: TextStyle(fontSize: 14, color: Colors.black87)),
                ],
              ),
            ),

            /// 📝 Title input
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Title'),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            /// 🧾 Content input
            Expanded(
              child: TextField(
                focusNode: _contentFocus,
                controller: _contentController,
                maxLines: null,
                expands: true,
                style: TextStyle(color: _selectedTextColor),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Write your note...',
                  border: InputBorder.none,
                ),
              ),
            ),

            /// 🧰 Markdown Toolbar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /// ✏️ Markdown options
                  PopupMenuButton<String>(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onSelected: (value) {
                      if (value == 'Bold') insertMarkdown('**');
                      if (value == 'Italic') insertMarkdown('_');
                      if (value == 'Code') insertMarkdown('`');
                      if (value == 'Heading') insertMarkdown('# ');
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(child: Text('Bold'), value: 'Bold'),
                      PopupMenuItem(child: Text('Italic'), value: 'Italic'),
                      PopupMenuItem(child: Text('Code'), value: 'Code'),
                      PopupMenuItem(child: Text('Heading'), value: 'Heading'),
                    ],
                  ),

                  /// 🎨 Text color dropdown
                  PopupMenuButton<Color>(
                    icon: Icon(Icons.color_lens, color: Colors.white),
                    onSelected: applyColorToSelectedText,
                    itemBuilder: (context) => [
                      PopupMenuItem(child: colorCircle(Colors.white), value: Colors.white),
                      PopupMenuItem(child: colorCircle(Colors.black), value: Colors.black),
                      PopupMenuItem(child: colorCircle(Colors.red.shade800), value: Colors.red.shade800),
                      PopupMenuItem(child: colorCircle(Colors.green.shade100), value: Colors.green.shade100),
                      PopupMenuItem(child: colorCircle(Colors.blue.shade800), value: Colors.blue.shade800),
                      PopupMenuItem(child: colorCircle(Colors.purple), value: Colors.purple),
                    ],
                  ),

                  // 📸 Placeholder icon buttons
                  IconButton(icon: Icon(Icons.camera_alt, color: Colors.white), onPressed: () {}),
                  IconButton(icon: Icon(Icons.copy_rounded, color: Colors.white), onPressed: () {}),
                  IconButton(icon: Icon(Icons.add_box, color: Colors.white), onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 👁️ Circle UI used to show color options
  Widget colorCircle(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
