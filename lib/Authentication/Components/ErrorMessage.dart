import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// ⚠️ Function to display an error alert dialog with animation
/// Accepts context and an error message string to show
void displayError(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      // Rounded corner alert box
      contentPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      content: Column(
        mainAxisSize: MainAxisSize.min, // Makes dialog only as big as content
        children: [
          // 🎞️ Lottie animation for error
          Lottie.asset(
            'assets/animations/error.json',
            width: 120,
            height: 120,
            repeat: false, // Don't loop animation
          ),

          const SizedBox(height: 20),

          // 📝 Error text displayed to the user
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          // ✅ OK button to close the dialog
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(), // Closes the dialog
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[900],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    ),
  );
}
