import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Added for SharedPreferences

import '../screens/home_screen.dart';
import '../screens/on_boarding_screen.dart';
import 'login_page.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isNewUser = true;

  @override
  void initState() {
    super.initState();
  }

  // Function to check if the user has seen the onboarding screen
  Future<bool> checkIfNewUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isNewUser') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkIfNewUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Show a loading indicator while waiting for the SharedPreferences check
          return const Center(child: CircularProgressIndicator());
        } else {
          bool isNewUser = snapshot.data!; // Get the result of the future

          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, authSnapshot) {
              if (authSnapshot.hasData) {
                if (isNewUser) {
                  return const OnboardingScreen(); // Navigate to onboarding if the user is new
                } else {
                  return HomeScreen(); // Navigate to HomeScreen if the user has already seen onboarding
                }
              } else {
                return const LoginPage(); // If the user is not logged in
              }
            },
          );
        }
      },
    );
  }
}
