import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

import '../widgets/capsule_item.dart';

class RecievedCapsuleDetailScreen extends StatefulWidget {
  final dynamic capsule;
  final String senderName;
  RecievedCapsuleDetailScreen({required this.capsule, required this.senderName});

  @override
  _RecievedCapsuleDetailScreenState createState() => _RecievedCapsuleDetailScreenState();
}

class _RecievedCapsuleDetailScreenState extends State<RecievedCapsuleDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _rotateAnimation;
  late ConfettiController _confettiController;
  late ConfettiController _tapConfettiController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _bounceAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _tapConfettiController = ConfettiController(duration: const Duration(seconds: 1));

    _controller.forward();
    _confettiController.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    _tapConfettiController.dispose();
    super.dispose();
  }

  void _onTapConfetti() {
    _tapConfettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capsule Details')),
      body: GestureDetector(
        onTap: () {
          _controller.reset();
          _controller.forward();
          _onTapConfetti();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 50,
              colors: [Colors.red, Colors.blue, Colors.green, Colors.orange],
            ),
            ConfettiWidget(
              confettiController: _tapConfettiController,
              blastDirection: -pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              colors: [Colors.pink, Colors.yellow, Colors.cyan],
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: _bounceAnimation.value,
                      child: Transform.rotate(
                        angle: _rotateAnimation.value * 6.3,
                        child: Icon(Icons.card_giftcard, size: 100, color: Colors.purpleAccent),
                      ),
                    ),
                    const SizedBox(height: 30),
                    AnimatedOpacity(
                      opacity: _bounceAnimation.value,
                      duration: const Duration(seconds: 2),
                      child: SlideTransition(
                        position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(_controller),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                "Congratulations! You've unlocked a capsule!",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to the CapsuleDetailsPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CapsuleItem(capsule: widget.capsule, senderName: widget.senderName,),
                                  ),
                                );
                              },
                              child: Text(
                                "View Details",
                                style: TextStyle(
                                  color: Colors.white, // Text color
                                  fontWeight: FontWeight.bold, // Bold text
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red, // Text color
                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // Button padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0), // Rounded corners
                                ),
                                side: BorderSide(color: Colors.redAccent, width: 2), // Border color and width
                              ).copyWith(
                                elevation: ButtonStyleButton.allOrNull(10.0), // Shadow elevation
                              ),
                            ),


                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
