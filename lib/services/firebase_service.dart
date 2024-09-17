import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch the username of the current user
  static Future<String?> fetchUsername() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc = await _firestore.collection('Users').doc(user.uid).get();
        if (userDoc.exists) {
          return userDoc['username'];
        }
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
    return null;
  }

  // Upload the capsule data with the username
  static Future<void> uploadCapsule({
    required String title,
    required String body,
    required File? imageFile,
    required File? musicFile,
    DateTime? revealDate,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final username = await fetchUsername();
    if (username == null) {
      throw Exception('Unable to fetch username');
    }

    try {
      // Upload the image to Firebase Storage (if present) and get the URL
      String? imageUrl;
      if (imageFile != null) {
        final storageRef = FirebaseStorage.instance.ref().child('capsules/${user.uid}/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = await storageRef.putFile(imageFile);
        imageUrl = await uploadTask.ref.getDownloadURL();
      }

      // Upload the music file to Firebase Storage (if present) and get the URL
      String? musicUrl;
      if (musicFile != null) {
        final musicStorageRef = FirebaseStorage.instance.ref().child('capsules/${user.uid}/music/${DateTime.now().millisecondsSinceEpoch}');
        final musicUploadTask = await musicStorageRef.putFile(musicFile);
        musicUrl = await musicUploadTask.ref.getDownloadURL();
      }

      // Prepare data to store in Firestore
      Map<String, dynamic> capsuleData = {
        'userId': user.uid,
        'username': username,
        'title': title,
        'body': body,
        'timestamp': FieldValue.serverTimestamp(),
        'revealDate': revealDate != null ? Timestamp.fromDate(revealDate) : null,
      };

      // Conditionally add the imageUrl and musicUrl to Firestore if they are not null
      if (imageUrl != null) {
        capsuleData['imageUrl'] = imageUrl;
      }
      if (musicUrl != null) {
        capsuleData['musicUrl'] = musicUrl;
      }

      // Store capsule data in Firestore
      await _firestore.collection('capsules').add(capsuleData);
    } catch (e) {
      throw Exception('Error uploading capsule: $e');
    }
  }

}
