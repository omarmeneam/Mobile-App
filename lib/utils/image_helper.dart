import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  static final ImagePicker _picker = ImagePicker();

  // Method to show the source selection dialog
  static Future<void> showImageSourceDialog(
    BuildContext context, {
    required Function(File) onImageSelected,
  }) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageSimple(
                    context,
                    ImageSource.camera,
                    onImageSelected,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageSimple(
                    context,
                    ImageSource.gallery,
                    onImageSelected,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Simplified image picking method without dialogs
  static Future<void> _pickImageSimple(
    BuildContext context,
    ImageSource source,
    Function(File) onImageSelected,
  ) async {
    try {
      // Show loading indicator in the scaffold
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Loading...'),
            duration: Duration(seconds: 1),
          ),
        );
      }

      // Try to pick image with a timeout
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      // Process selected image
      if (pickedFile != null && context.mounted) {
        final File file = File(pickedFile.path);
        onImageSelected(file);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Alternative direct pick method from specific source
  static Future<File?> pickImageFromSource(
    BuildContext context,
    ImageSource source,
  ) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
    return null;
  }
}
