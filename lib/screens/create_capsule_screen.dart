import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/capsule_controller.dart';// Your controller file

class CreateCapsuleScreen extends StatelessWidget {
  CreateCapsuleScreen({super.key});

  final CapsuleController controller = Get.put(CapsuleController()); // Initialize the controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Capsule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller.titleTextController,
              maxLines: 1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter capsule title',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: controller.bodyTextController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter capsule body',
              ),
            ),
            const SizedBox(height: 20.0),
            Obx(
                  () => controller.selectedImage.value == null
                  ? Container(
                color: Colors.blueGrey[200],
                child: ElevatedButton.icon(
                  onPressed: controller.pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Pick an Image'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              )
                  : Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    controller.selectedImage.value!,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Obx(
                  () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                color: Colors.greenAccent,
                child: ElevatedButton(
                  onPressed: controller.saveCapsule,
                  child: const Text('Save Capsule'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
