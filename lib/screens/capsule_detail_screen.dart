import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/capsule_detail_controller.dart';
import '../widgets/music_player_widget.dart';
class CapsuleDetailScreen extends StatelessWidget {
  final CapsuleDetailController controller;

  CapsuleDetailScreen({super.key, required Map<String, dynamic> capsuleData})
      : controller = Get.put(CapsuleDetailController(capsuleData));

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
                  controller.editCapsule();
                  break;
                case 'Delete':
                  controller.deleteCapsule();
                  break;
                case 'Share':
                  controller.shareCapsule();
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
        child: Obx(
              () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  controller.capsuleData['title'] ?? 'No Title',
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
                  'By ${controller.capsuleData['username'] ?? 'Unknown User'} on ${controller.capsuleData['timestamp'] != null ? controller.capsuleData['timestamp'].toDate().toLocal().toString() : 'No Date Available'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Body Content
              Text(
                controller.capsuleData['body'] ?? 'No Content',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),

              // Image
              if (controller.capsuleData['imageUrl'] != null)
                Center(
                  child: Image.network(
                    controller.capsuleData['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16.0),

              // Music Player
              if (controller.capsuleData['musicUrl'] != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Audio:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    MusicPlayerWidget(musicUrl: controller.capsuleData['musicUrl']),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
