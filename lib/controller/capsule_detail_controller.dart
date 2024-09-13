import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projects/screens/contacts_screen.dart';

class CapsuleDetailController extends GetxController {
  var capsuleData = <String, dynamic>{}.obs;

  CapsuleDetailController(Map<String, dynamic> initialData) {
    capsuleData.value = initialData; // Initialize with the provided data
  }

  void editCapsule() {
    // Handle the edit logic here

    Get.to(() => ContactsScreen());
    print('Edit capsule');
  }

  void deleteCapsule() {
    // Handle the delete logic here
    print('Delete capsule');
  }

  void shareCapsule() {
    // Handle the share logic here
    print('Share capsule');
  }
}
