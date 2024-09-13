import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/screens/AddContactsScreen.dart';
import 'package:projects/screens/view_saved_capsule_screen.dart';
import 'create_capsule_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase Auth
     // Get.offAllNamed('/login'); // Redirect to the login screen
      // You can use Navigator.of(context).pushReplacementNamed('/login') if using named routes
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Capsule'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddContactsScreen()),
              );
            },
            tooltip: 'Add to Contacts', // Tooltip text to show on hover
            icon: const Icon(Icons.person_add), // Icon for Add to Contacts
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
              child: const Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('S E T T I N G S'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Add your navigation logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.save),
              title: const Text('S A V E D  C A P S U L E S'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewSavedCapsuleScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('S I G N  O U T'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _signOut(context); // Call the sign-out method
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Welcome to Time Capsule!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Create Capsule Screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateCapsuleScreen()),
          );
        },
        tooltip: 'Create New Capsule',
        child: const Icon(Icons.create),
      ),
    );
  }
}
