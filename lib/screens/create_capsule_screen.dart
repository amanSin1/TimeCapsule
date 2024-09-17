import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/capsule_controller.dart'; // Your controller file

class CreateCapsuleScreen extends StatelessWidget {
  CreateCapsuleScreen({super.key});

  final CapsuleController controller = Get.put(CapsuleController()); // Initialize the controller

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Clear the controller when the user tries to navigate back
        controller.clearCapsule();
        return true; // Allows the back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Capsule'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              controller.clearCapsule(); // Clear data on manual back press
              Get.back();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                Obx(() => controller.selectedImage.value == null
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
                    : Stack(
                  children: [
                    Container(
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
                    Positioned(
                      right: 5,
                      top: 5,
                      child: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          controller.clearImage(); // Clear image
                        },
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 20.0),
                Obx(() => controller.selectedMusic.value == null
                    ? ElevatedButton.icon(
                  onPressed: controller.pickMusic,
                  icon: const Icon(Icons.music_note),
                  label: const Text('Pick a Music File'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.red,
                  ),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Selected Music: ${controller.selectedMusic.value!.path.split('/').last}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.red),
                      onPressed: () {
                        controller.clearMusic(); // Clear music file
                      },
                    ),
                  ],
                )),
                const SizedBox(height: 20.0),
                Obx(() => Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          controller.revealDate(pickedDate);
                        }
                      },
                      child: const Icon(Icons.calendar_month),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        controller.revealDate.value != null
                            ? 'Reveal Date: ${DateFormat.yMMMd().format(controller.revealDate.value!)}'
                            : 'No Date Selected',
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 20.0),
                Obx(() => controller.isLoading.value
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
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
