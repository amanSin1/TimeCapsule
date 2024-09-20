import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Add smooth_page_indicator package

import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: const [
              OnboardingPage(
                title: 'Create Capsule',
                description: 'Decentralized and secure capsules to send memories into the future.',
                imagePath: 'assets/images/time1.png',
              ),
              OnboardingPage(
                title: 'Unlimited Content',
                description: 'Add as much content as you want to your capsule.',
                imagePath: 'assets/images/time2.png',
              ),
              OnboardingPage(
                title: 'Send Your Capsule',
                description: 'Send your capsule on a journey into the future.',
                imagePath: 'assets/images/time4.jpg',
                isLastPage: true,
              ),
            ],
          ),
          // Add page indicator
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: WormEffect(
                    dotHeight: 12,
                    dotWidth: 12,
                    activeDotColor: Colors.white,
                    dotColor: Colors.white24,
                  ),
                ),
                if (currentPage == 2) // Show the button only on the last page
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Save the flag to SharedPreferences
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('hasSeenOnboarding', false);

                        // Navigate to HomeScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                      child: const Text("Let's Start!",style: TextStyle(color: Colors.red),),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final bool isLastPage;

  const OnboardingPage({super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full-screen image
        Positioned.fill(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover, // Set image to cover the full screen
          ),
        ),
        // Text overlay
        Positioned.fill(
          child: Container(
            color: Colors.black54, // Dark overlay for better text visibility
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
