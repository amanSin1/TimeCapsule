
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/pages/signup_page.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("W E L C O M E", style: TextStyle(fontStyle: FontStyle.italic),),
        centerTitle: true,
        backgroundColor: Colors.grey, // Change the background color
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          children: [
            TextField(
              controller: email,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter email',
                hintStyle: TextStyle(color: Colors.white), // Hint text color
                border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: const BorderSide(color: Colors.white)
                  // Rounded corners
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(19.0),
                  borderSide: BorderSide(color: Colors.teal), // Border color when enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.teal, width: 2.0), // Border color on focus
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            TextField(
              controller: password,
              style: TextStyle(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter password',
                hintStyle: TextStyle(color: Colors.white), // Hint text color
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide(color: Colors.white)// Rounded corners
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(19.0),
                  borderSide: BorderSide(color: Colors.teal), // Border color when enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.teal, width: 2.0), // Border color on focus
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: signIn,
                style: ElevatedButton.styleFrom(

                  backgroundColor: Colors.teal, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0), // Button padding
                ),
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 16.0,color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(const SignupPage()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700], // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0), // Button padding
                ),
                child: Text(
                  "Register now",
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => Get.to(const Forgot()),
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal, textStyle: TextStyle(fontSize: 16.0),
              ),
              child: Text("Forget password",),
            ),
          ],
        ),
      ),
    );
  }
}