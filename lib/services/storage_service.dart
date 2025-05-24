import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Process and upload image file to Firebase Storage
  Future<String> uploadImage(File imageFile) async {
    try {
      // Get current user ID
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Process the image
      final File processedImage = await _processImage(imageFile);

      // Create a unique filename using timestamp
      final String fileName =
          'listing_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Reference to the file location in Firebase Storage
      final Reference ref = _storage
          .ref()
          .child('listing_images')
          .child(userId)
          .child(fileName);

      // Upload the file
      final UploadTask uploadTask = ref.putFile(processedImage);

      // Wait for the upload to complete and get the download URL
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image: $e');
    }
  }

  // Process image: compress and convert to JPEG
  Future<File> _processImage(File file) async {
    try {
      // Get temporary directory
      final tempDir = await path_provider.getTemporaryDirectory();
      final targetPath =
          '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Compress and convert image
      final result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        quality: 85, // Adjust quality (0-100)
        format: CompressFormat.jpeg,
      );

      if (result == null) {
        throw Exception('Failed to compress image');
      }

      return File(result.path);
    } catch (e) {
      print('Error processing image: $e');
      throw Exception('Failed to process image: $e');
    }
  }

  // Delete image from Firebase Storage by URL
  Future<bool> deleteImage(String imageUrl) async {
    try {
      // Check if the URL is from Firebase Storage
      if (!imageUrl.contains('firebasestorage')) {
        // If it's not a Firebase Storage URL, it might be a default image
        return true;
      }

      // Create a reference from the URL
      final Reference ref = _storage.refFromURL(imageUrl);

      // Delete the file
      await ref.delete();
      return true;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }
}
