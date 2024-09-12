import 'package:flutter/material.dart';

class MusicPlayerWidget extends StatelessWidget {
  final String musicUrl;

  const MusicPlayerWidget({super.key, required this.musicUrl});

  @override
  Widget build(BuildContext context) {
    // Replace this with your preferred audio player widget
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Play Audio'),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              // Logic to play audio from URL
            },
          ),
        ],
      ),
    );
  }
}