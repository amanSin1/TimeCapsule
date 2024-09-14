import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projects/screens/AddContactsScreen.dart';
import 'package:projects/screens/view_saved_capsule_screen.dart';
import 'capsule_detail_screen.dart';
import 'create_capsule_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase Auth
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out: $e');
    }
  }

  Future<String> _getSenderName(String senderId) async {
    try {
      final userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(senderId).get();
      return userDoc.data()?['username'] ?? 'Unknown Sender';
    } catch (e) {
      return 'Error fetching sender';
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('receivedCapsules')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No received capsules'));
          }

          final capsules = snapshot.data!.docs;

          return ListView.builder(
            itemCount: capsules.length,
            itemBuilder: (context, index) {
              final doc = capsules[index];
              final capsule = doc.data() as Map<String, dynamic>;
              final senderId = capsule['senderId'] as String;
              final timestamp = capsule['timestamp'] as Timestamp;
              final revealDate = (capsule['revealDate'] as Timestamp?)?.toDate();

              return FutureBuilder<String>(
                future: _getSenderName(senderId),
                builder: (context, senderSnapshot) {
                  if (senderSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading sender...'),
                    );
                  }

                  if (senderSnapshot.hasError) {
                    return ListTile(
                      title: const Text('Error loading sender'),
                      subtitle: Text(_formatTimestamp(timestamp)),
                    );
                  }

                  final senderName = senderSnapshot.data ?? 'Unknown Sender';

                  return ListTile(
                    title: Text(senderName),
                    subtitle: Text(_formatTimestamp(timestamp)),
                    onTap: () {
                      _handleCapsuleTap(context, doc, revealDate);
                    },
                  );
                },
              );
            },
          );
        },
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

  void _handleCapsuleTap(
      BuildContext context, DocumentSnapshot capsule, DateTime? revealDate) {
    DateTime currentDate = DateTime.now();

    // Check if the current date is after or equal to the reveal date
    if (revealDate == null ||
        currentDate.isAfter(revealDate) ||
        currentDate.isAtSameMomentAs(revealDate)) {
      // Navigate to the detail screen to show the capsule's content
      Get.to(() =>
          CapsuleDetailScreen(capsuleData: capsule.data() as Map<String, dynamic>));
    } else {
      // Show a snackbar or dialog saying the capsule is not yet revealed
      Get.snackbar(
        'Capsule Locked',
        'This capsule will be revealed on ${DateFormat.yMMMd().format(revealDate)}.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3), // Ensure duration is set
      );
    }
  }
}
