import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/contacts_controller.dart';

class ContactsScreen extends StatelessWidget {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final ContactsController controller = Get.put(ContactsController());

  final Map<String, dynamic> capsuleData;

  ContactsScreen({Key? key, required this.capsuleData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share to'),
        actions: [
          Obx(() {
            return IconButton(
              icon: const Icon(Icons.send),
              onPressed: controller.selectedContacts.isEmpty
                  ? null
                  : () async {
                // Send the capsule to selected contacts
                await _sendCapsuleToSelectedContacts(context);
                Get.snackbar('Success', 'Capsule shared successfully!');
                Navigator.pop(context);
              },
            );
          }),
        ],
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
              final contactId = contact.id;
              final contactName = contact['name'];

              return Obx(
                    () => ListTile(
                  leading: Checkbox(
                    value: controller.isContactSelected(contactId),
                    onChanged: (bool? isSelected) {
                      controller.toggleContact(contactId);
                    },
                  ),
                  title: Text(contactName),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _sendCapsuleToSelectedContacts(BuildContext context) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Iterate over selected contacts
    for (String contactId in controller.selectedContacts) {
      // Create a reference for the capsule in the contact's receivedCapsules collection
      DocumentReference capsuleRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(contactId)
          .collection('receivedCapsules')
          .doc();

      // Extract the fields from capsuleData
      String title = capsuleData['title'] ?? 'Untitled Capsule';
      String body = capsuleData['body'] ?? 'No body content available';
      String? imageUrl = capsuleData['imageUrl'];
      String? musicUrl = capsuleData['musicUrl'];

      // Set the capsule data in Firestore for the contact
      batch.set(capsuleRef, {
        'title': title,
        'body': body,
        'senderId': currentUserId,
        'timestamp': FieldValue.serverTimestamp(),
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (musicUrl != null) 'musicUrl': musicUrl,
        // Add any other fields you want to include from capsuleData
      });
    }

    // Commit the batch write to Firestore
    await batch.commit();
  }

}
