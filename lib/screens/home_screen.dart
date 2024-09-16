import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:projects/screens/AddContactsScreen.dart';
import 'package:projects/screens/recieved_capsule_detail_screen.dart';
import 'package:projects/screens/view_saved_capsule_screen.dart';
import 'create_capsule_screen.dart';

class HomeScreen extends StatelessWidget {

  HomeScreen({super.key});

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

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  Future<String?> getCurrentUserName() async {
    // Get the current user document from Firestore
    final userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    // Check if the document exists and return the username, otherwise return null
    if (userDoc.exists) {
      return userDoc.data()?['username'];
    }
    return null; // Return null if the user does not exist
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String?>(
          future: getCurrentUserName(), // Fetch username
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...'); // While loading, show 'Loading...'
            }

            if (snapshot.hasError) {
              return const Text('Error'); // If there is an error, show 'Error'
            }

            final String? userName = snapshot.data; // Get the fetched username

            // Show username if available, otherwise show 'User'
            return Text(userName != null ? '👋, $userName!' : 'User',style: TextStyle(fontWeight:FontWeight.bold),);
          },
        ),
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
                   // color: Colors.white,
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
              final title = capsule['title'];

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

                  return Container(
                    padding: EdgeInsets.all(3),
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(

                      border: Border.all(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: (){},
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 24,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24, // Adjust the size as needed
                          ),
                        ),

                      ),
                      title: Text(senderName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      subtitle: Text(title),
                      trailing: Text(_formatTimestamp(timestamp)),
                      onTap: () {
                        _handleCapsuleTap(context, doc, revealDate,senderName);
                      },
                    ),
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
      BuildContext context, DocumentSnapshot capsule, DateTime? revealDate, String senderName) {
    DateTime currentDate = DateTime.now();

    // Check if the current date is after or equal to the reveal date
    if (revealDate == null ||
        currentDate.isAfter(revealDate) ||
        currentDate.isAtSameMomentAs(revealDate)) {
      // Navigate to the detail screen to show the capsule's content
      Get.to(() =>
          RecievedCapsuleDetailScreen(capsule: capsule, senderName: senderName,));
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