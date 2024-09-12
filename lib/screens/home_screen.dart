import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projects/screens/view_saved_capsule_screen.dart';
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
            message: 'Create New Capsule', // Text to show on hover
            child: IconButton(
              onPressed: () {
                // Navigate to the Create Capsule Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateCapsuleScreen()),
                );
              },
              icon: const Icon(Icons.create),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to the Settings screen
                Navigator.pop(context); // Close the drawer
                // Add your navigation logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.save),
              title: const Text('View Saved Capsules'),
              onTap: () {
                // Navigate to the View Saved Capsules screen
                Navigator.pop(context); // Close the drawer
                // Add your navigation logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  ViewSavedCapsuleScreen(), // Corrected function syntax
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Welcome to Time Capsule!'),
      ),
    );
  }
}
