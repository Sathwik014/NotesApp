import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void displayError(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lottie animation
          Lottie.asset('assets/animations/error.json', width: 120, height: 120,
            repeat: false,
          ),
          const SizedBox(height: 20),
          // Error message
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
          // Close button
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[900],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("OK",style: TextStyle(color: Colors.white),),
          )
        ],
      ),
    ),
  );
}
