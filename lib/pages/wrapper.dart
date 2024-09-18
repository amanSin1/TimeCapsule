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
    checkIfNewUser(); // Added to check if user is new
  }

  Future<void> checkIfNewUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isNewUser = prefs.getBool('isNewUser') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (isNewUser) {
              return OnboardingScreen(); // Navigate to onboarding if user is new
            } else {
              return HomeScreen(); // Navigate to HomeScreen if user is returning
            }
          } else {
            return const LoginPage(); // If user is not logged in
          }
        },
      ),
    );
  }
}
