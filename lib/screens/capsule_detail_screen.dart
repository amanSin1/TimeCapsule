import 'package:flutter/material.dart';

import '../widgets/music_player_widget.dart';

class CapsuleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> capsuleData; // Contains all the details of the capsule

  CapsuleDetailScreen({super.key, required this.capsuleData});

  @override
  Widget build(BuildContext context) {
    final title = capsuleData['title'] ?? 'No Title';
    final body = capsuleData['body'] ?? 'No Content';
    final imageUrl = capsuleData['imageUrl'];
    final musicUrl = capsuleData['musicUrl'];
    final username = capsuleData['username'] ?? 'Unknown User';
    final timestamp = capsuleData['timestamp'] != null
        ? capsuleData['timestamp'].toDate().toLocal().toString()
        : 'No Date Available';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Capsule Details'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String choice) {
              switch (choice) {
                case 'Edit':
                // Handle edit logic here
                  print('Edit capsule');
                  break;
                case 'Delete':
                // Handle delete logic here
                  print('Delete capsule');
                  break;
                case 'Share':
                // Handle share logic here
                  print('Share capsule');
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
                title,
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
                'By $username on $timestamp',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Body Content
            Text(
              body,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Image
            if (imageUrl != null)
              Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16.0),

            // Music Player
            if (musicUrl != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Audio:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  MusicPlayerWidget(musicUrl: musicUrl), // Your music player widget
                ],
              ),
          ],
        ),
      ),
    );
  }
}


