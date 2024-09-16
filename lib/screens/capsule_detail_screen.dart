import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../widgets/music_player_widget.dart';
import 'contacts_screen.dart';

class CapsuleDetailScreen extends StatefulWidget {
  final Map<String, dynamic> capsuleData;
  final String capsuleId;

   CapsuleDetailScreen({super.key, required this.capsuleData, required this.capsuleId});

  @override
  _CapsuleDetailScreenState createState() => _CapsuleDetailScreenState();
}

class _CapsuleDetailScreenState extends State<CapsuleDetailScreen> {
  late Map<String, dynamic> capsuleData; // State variable to store capsule data


  @override
  void initState() {
    super.initState();
    capsuleData = widget.capsuleData; // Initialize with the provided data
  }

  void editCapsule() {
    // Handle edit logic here
    // You might navigate to an edit page or open a dialog to edit capsule details
    print('Edit capsule');
  }

  void deleteCapsule() async {
    try {
      // Deleting the capsule from Firebase Firestore using widget.capsuleId
      await FirebaseFirestore.instance
          .collection('capsules')
          .doc(widget.capsuleId) // Access capsuleId via widget
          .delete();

      // Show snackbar on successful deletion
      Get.snackbar(
        'Deleted',
        'Capsule has been successfully deleted!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      // Show error snackbar if deletion fails
      Get.snackbar(
        'Error',
        'Failed to delete capsule: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  void shareCapsule() {
    // Handle share logic here
    Get.to(() => ContactsScreen(capsuleData: capsuleData,));
    print('Share capsule');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capsule Details'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String choice) {
              switch (choice) {
                case 'Edit':
                  editCapsule();
                  break;
                case 'Delete':
                  deleteCapsule();
                  break;
                case 'Share':
                  shareCapsule();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Edit', 'Delete', 'Share'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: const Icon(Icons.more_vert), // More icon
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                capsuleData['title'] ?? 'No Title',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            // Username and Timestamp
            Center(
              child: Text(
                'By ${capsuleData['username'] ?? 'Unknown User'} on ${capsuleData['timestamp'] != null ? capsuleData['timestamp'].toDate().toLocal().toString() : 'No Date Available'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Body Content
            Text(
              capsuleData['body'] ?? 'No Content',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Image with error handling
            if (capsuleData['imageUrl'] != null)
              Center(
                child: Image.network(
                  capsuleData['imageUrl'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            const SizedBox(height: 16.0),

            // Music Player
            if (capsuleData['musicUrl'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Audio:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  MusicPlayerWidget(musicUrl: capsuleData['musicUrl']),
                ],
              ),
          ],
        ),
      )
    );
  }
}
