import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Upload image file to Firebase Storage
  Future<String> uploadImage(File imageFile) async {
    try {
      // Get current user ID
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Create a unique filename using timestamp
      final String fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}.${path.extension(imageFile.path)}';

      // Reference to the file location in Firebase Storage
      final Reference ref = _storage
          .ref()
          .child('profile_images')
          .child(userId)
          .child(fileName);

      // Upload the file
      final UploadTask uploadTask = ref.putFile(imageFile);

      // Wait for the upload to complete and get the download URL
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image: $e');
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
