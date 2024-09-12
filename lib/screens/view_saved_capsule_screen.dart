import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'capsule_detail_screen.dart';

class ViewSavedCapsuleScreen extends StatelessWidget {
  ViewSavedCapsuleScreen({super.key});

  final User? user = FirebaseAuth.instance.currentUser; // Get the current user

  @override
  Widget build(BuildContext context) {
    final String? userId = user?.uid; // Get the user ID
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Capsules'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('capsules')
            .where('userId', isEqualTo: userId) // Filter by userId
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No saved capsules found.'));
          }

          final capsules = snapshot.data!.docs;

          return ListView.builder(
            itemCount: capsules.length,
            itemBuilder: (context, index) {
              final capsule = capsules[index];
              final title = capsule['title'];
              final timestamp = capsule['timestamp']?.toDate();

              return ListTile(
                title: Text(title),
                subtitle: Text(timestamp != null
                    ? 'Created on: ${timestamp.toLocal()}'
                    : 'No date available'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  // Convert the QueryDocumentSnapshot to Map<String, dynamic>
                  final capsuleData = capsule.data() as Map<String, dynamic>;

                  // Navigate to the detailed view screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CapsuleDetailScreen(capsuleData: capsuleData),
                    ),
                  );

                  print('Capsule ID: ${capsule.id}');
                },
              );
            },
          );
        },
      ),
    );
  }
}