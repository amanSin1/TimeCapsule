import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {

  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Contacts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUserId)
            .collection('contacts')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final contacts = snapshot.data!.docs;

          if (contacts.isEmpty) {
            return const Center(child: Text('No contacts added yet.'));
          }

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              final contactName = contact['name'];

              return ListTile(
                title: Text(contactName),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _removeContact(currentUserId!, contact.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _removeContact(String currentUserId, String contactUserId) {
    // Remove the selected contact from the current user's contact list
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('contacts')
        .doc(contactUserId)
        .delete();

    print('Contact removed');
  }
}