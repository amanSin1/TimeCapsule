import 'package:flutter/material.dart';
import 'image_view.dart';
import 'music_player_widget.dart';

class CapsuleItem extends StatelessWidget {
  final dynamic capsule;
  final String senderName;

  const CapsuleItem({super.key, required this.capsule, required this.senderName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("D  E  T  A  I  L  S"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with Fade Animation
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(seconds: 3),
              child: Center(
                child: Text(
                  capsule['title'] ?? 'No Title',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Username and Timestamp with Slide Animation
            AnimatedSlide(
              offset: Offset(0, 0),
              duration: const Duration(seconds: 3),
              child: Center(
                child: Text(
                  'By $senderName on ${capsule['timestamp'] != null ? capsule['timestamp'].toDate().toLocal().toString() : 'No Date Available'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Body Content with Scale and Fade Animation
            AnimatedContainer(
              duration: const Duration(seconds: 3),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(vertical: 16.0), // Added padding for visual effect
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(seconds: 3),
                child: AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(seconds: 3),
                  child: Text(
                    capsule['body'] ?? 'No Content',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Image with Interactive Viewer and Hero Animation
            if (capsule['imageUrl'] != null)
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewPage(imageUrl: capsule['imageUrl']),
                    ),
                  ),
                  child: Hero(
                    tag: 'capsule-image-${capsule['timestamp']}',
                    child: Material(
                      color: Colors.transparent,
                      child: Image.network(
                        capsule['imageUrl'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16.0),

            // Music Player
            if (capsule['musicUrl'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Audio:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  MusicPlayerWidget(musicUrl: capsule['musicUrl']),
                ],
              ),
            const SizedBox(height: 16.0),

            // Cool Button with Ripple Effect and Animated Color

          ],
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const AnimatedButton({required this.onPressed, required this.child, Key? key}) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _colorAnimation = ColorTween(begin: Colors.red, end: Colors.deepOrange).animate(_controller);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _colorAnimation.value,
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onPressed: widget.onPressed,
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
