// capsule_controller.dart

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart'; // Your Firebase service file

class CapsuleController extends GetxController {
  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController bodyTextController = TextEditingController();

  var selectedImage = Rxn<File>(); // Reactive variable for the image
  var selectedMusic = Rxn<File>(); // Selected music file
  var isLoading = false.obs; // Reactive variable for loading state

  final ImagePicker _picker = ImagePicker();

  // Method to pick an image
  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Error picking image: $e');
    }
  }

  // Method to pick music
  Future<void> pickMusic() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.single.path != null  && selectedMusic.value == null) {
      selectedMusic.value = File(result.files.single.path!);
    }
  }

  // Method to save the capsule
  Future<void> saveCapsule() async {
    if (titleTextController.text.isEmpty && selectedImage.value == null) {
      Get.snackbar('Error', 'Please enter some text or pick an image');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'User is not logged in');
      return;
    }

    isLoading.value = true;

    try {
      await FirebaseService.uploadCapsule(
        title: titleTextController.text,
        body: bodyTextController.text,
        imageFile: selectedImage.value,
        musicFile: selectedMusic.value, // Save music file as well
      );

      Get.snackbar('Success', 'Capsule saved successfully!');
      titleTextController.clear();
      bodyTextController.clear();
      selectedImage.value = null;
      selectedMusic.value = null;
    } catch (e) {
      Get.snackbar('Error', 'Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
