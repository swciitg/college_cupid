import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  final VoidCallback onCancel;

  const WaitingScreen({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              "Finding a match...",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            const Text("Please wait while we look for someone compatible."),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }
}
