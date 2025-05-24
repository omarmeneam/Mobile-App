import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_colors.dart';
import '../../viewmodels/profile_viewmodel.dart';
import 'profile_screen.dart'; // Add this import

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize form with user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
      if (viewModel.user == null) {
        viewModel.loadUserProfile();
      } else {
        viewModel.initializeWithUser(viewModel.user!);
      }
    });
  }

  // Widget to display the selected image or current user avatar
  Widget _buildAvatarWidget(ProfileViewModel viewModel) {
    // If a new image file is selected, display it
    if (viewModel.avatarFile != null) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: FileImage(viewModel.avatarFile!),
      );
    }
    // Otherwise display the existing avatar
    return ProfileScreen.buildAvatar(viewModel.user!.avatar);
  }

  // Simple method to pick image from gallery
  void _pickImage() async {
    try {
      final viewModel = Provider.of<ProfileViewModel>(context, listen: false);

      // Pick image directly from gallery
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      // If image was selected, update the viewModel
      if (pickedFile != null) {
        setState(() {
          viewModel.avatarFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
      final success = await viewModel.updateProfile();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              viewModel.error.isEmpty
                  ? 'Failed to update profile'
                  : viewModel.error,
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading && viewModel.user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (viewModel.error.isNotEmpty && viewModel.user == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text(viewModel.error)),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
            actions: [
              if (viewModel.isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar with tap to change
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        _buildAvatarWidget(viewModel),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Show clear button if a new image is selected
                  if (viewModel.avatarFile != null)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          viewModel.avatarFile = null;
                        });
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Clear selected image'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),

                  const SizedBox(height: 16),

                  // Name Field
                  TextFormField(
                    initialValue: viewModel.name,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        viewModel.name = value;
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    initialValue: viewModel.email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Simple email validation
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        viewModel.email = value;
                      }
                    },
                    readOnly: true, // Prevents editing
                    enabled: false, // Disables user interaction
                  ),
                  const SizedBox(height: 16),

                  // Phone Field
                  TextFormField(
                    initialValue: viewModel.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    onSaved: (value) {
                      if (value != null) {
                        viewModel.phone = value;
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading ? null : _saveChanges,
                      child: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
