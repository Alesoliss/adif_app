import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotoScreen extends StatelessWidget {
  const AddPhotoScreen({super.key});

  Future<void> _pickFromCamera(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (image != null) {
      Get.back(result: image.path);
    }
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      Get.back(result: image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar foto'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.photo_camera_rounded, size: 28),
              label: const Text('Tomar fotografía'),
              onPressed: () => _pickFromCamera(context),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.photo_library_rounded, size: 28),
              label: const Text('Elegir de galería'),
              onPressed: () => _pickFromGallery(context),
            ),
          ],
        ),
      ),
    );
  }
}
