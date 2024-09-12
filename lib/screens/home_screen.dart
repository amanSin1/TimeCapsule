import 'package:flutter/material.dart';
import 'create_capsule_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Capsule'),
        centerTitle: true,
        actions: [
          Tooltip(
            message: 'Create New Capsule',  // Text to show on hover
            child: IconButton(
              onPressed: () {
                // Navigate to the Create Capsule Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  CreateCapsuleScreen()),
                );
              },
              icon: const Icon(Icons.create),
            ),
          ),
        ],
      ),
    );
  }
}
