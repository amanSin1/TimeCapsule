import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddContactsScreen extends StatelessWidget {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  AddContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      // If the user is not logged in or the user ID is null, show an error
      return Scaffold(
        appBar: AppBar(
          title: const Text('Add Contacts'),
        ),
        body: const Center(
          child: Text('Error: User not logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contacts'),
      ),
      body: FutureBuilder<List<String>>(
        future: _getExistingContacts(), // Get the list of already added contacts
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final existingContacts = snapshot.data ?? [];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = snapshot.data!.docs;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final userId = user.id; // Correct way to get the document ID
                  final userName = user['username'];

                  // Skip the current user and users already in contacts
                  if (userId == currentUserId || existingContacts.contains(userId)) {
                    return const SizedBox();
                  }

                  return Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      border: Border.all(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ListTile(
                      title: Text(
                        userName,
                        style: const TextStyle(fontSize: 20),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _addContact(currentUserId!, userId, userName);
                        },
                        child: const Text('Add'),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<String>> _getExistingContacts() async {
    // Fetch the list of contacts already added by the current user
    final contactSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserId)
        .collection('contacts')
        .get();

    // Extract and return the contact IDs
    return contactSnapshot.docs.map((doc) => doc.id).toList();
  }

  void _addContact(String currentUserId, String contactUserId, String contactUserName) async {
    // Reference to the contact document
    final contactDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserId)
        .collection('contacts')
        .doc(contactUserId);

    // Check if the contact already exists
    final contactDoc = await contactDocRef.get();

    if (contactDoc.exists) {
      // Contact already exists
      Get.snackbar('Info', 'Contact is already added.');
    } else {
      // Add the contact
      await contactDocRef.set({
        'name': contactUserName,
        'addedAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Success', 'Contact added successfully!');
    }
  }
}
