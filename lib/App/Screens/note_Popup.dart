import 'package:flutter/material.dart';
import 'package:notes_app/App/Widgets/TextField.dart';
import 'note_editor.dart';

/// Popup dialog for creating a new note before navigating to the NoteEditor page
class NotePopup extends StatefulWidget {
  const NotePopup({super.key});

  @override
  State<NotePopup> createState() => _NotePopupState();
}

class _NotePopupState extends State<NotePopup> {
  // Controllers for title and description text fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Holds the selected date for the note
  DateTime selectedDate = DateTime.now();

  /// 📅 Function to show date picker and update the selectedDate
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  /// ✅ Validate and Navigate to NoteEditor with prefilled values
  void _saveAndNavigate() {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    Navigator.of(context).pop(); // Close the popup first

    // Navigate to NoteEditor with provided inputs
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteEditor(
          prefilledTitle: title,
          prefilledContent: description,
          prefilledDate: selectedDate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("New Note", style: TextStyle(fontWeight: FontWeight.bold)),

      /// 📦 Main content section of popup
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title field
            Text_Field(controller: titleController, hintText: 'Title'),
            const SizedBox(height: 20),

            // Description field
            Text_Field(controller: descriptionController, hintText: "Description"),
            const SizedBox(height: 20),

            // 📅 Date Picker
            TextButton.icon(
              style: TextButton.styleFrom(backgroundColor: Colors.blue[300]),
              onPressed: () => _selectDate(context),
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              label: Text(
                "Date: ${selectedDate.toLocal().toString().split(' ')[0]}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),

      /// 🛠️ Action Buttons
      actions: [
        // Cancel button
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel", style: TextStyle(color: Colors.white)),
        ),

        // Save & Navigate button
        ElevatedButton(
          style: TextButton.styleFrom(backgroundColor: Colors.green),
          onPressed: _saveAndNavigate,
          child: const Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
