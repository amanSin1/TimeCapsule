import 'package:Time_Capsule/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'forgot.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      Get.snackbar("Success", "You have successfully signed in!",
          snackPosition: SnackPosition.BOTTOM);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = "The email address is not valid.";
          break;
        case 'user-disabled':
          message = "The user has been disabled.";
          break;
        case 'user-not-found':
          message = "No user found for that email.";
          break;
        case 'wrong-password':
          message = "Incorrect password.";
          break;
        default:
          message = "An unexpected error occurred. Please try again.";
      }
      Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "An unknown error occurred. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: isDarkMode ? Colors.black12 : Colors.white,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: isDarkMode ? Colors.black12 : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Descriptive Text
            Text(
              'Welcome to Time Capsule! Sign in to explore your memories and create new ones.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: isDarkMode ? Colors.white70 : Colors.black87,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20),

            // Email TextField
            TextField(
              controller: email,
              decoration: InputDecoration(
                hintText: 'Enter email',
                hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.teal, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),

            // Password TextField
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter password',
                hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.teal, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Register Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Get.to(const SignupPage()),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.teal, shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                 // backgroundColor: isDarkMode ? Colors.grey[800] : Colors.teal[100], // Background color for TextButton
                ),
                child: Text(
                  "New user? Register now",
                  style: TextStyle(fontSize: 16.0, color: Colors.teal),
                ),
              ),
            ),


            // Forgot Password Button
            TextButton(
              onPressed: () => Get.to(const Forgot()),
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal,
                textStyle: TextStyle(fontSize: 16.0),
              ),
              child: Text("Forgot password"),
            ),
          ],
        ),
      ),
    );
  }
}
