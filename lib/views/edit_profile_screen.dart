// lib/views/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trekify/controllers/auth_controller.dart';
import 'package:trekify/utils/snackbar_helper.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _nameController.text = authController.getCurrentUserName();
    _emailController.text = authController.getCurrentUserEmail();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Update the user profile
      authController.updateUserProfile(_nameController.text.trim());
      
      // Show success message
      SnackbarHelper.showSuccess(
        'Profile Updated',
        'Your profile has been updated successfully!',
      );
      
      // Navigate back
      Get.back();
    } catch (e) {
      SnackbarHelper.showError(
        'Update Failed',
        'Failed to update profile. Please try again.',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.teal,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Picture Section
              _buildProfilePictureSection(),
              const SizedBox(height: 24),
              
              // Profile Form
              _buildProfileForm(),
              const SizedBox(height: 24),
              
              // Update Button
              _buildUpdateButton(),
              const SizedBox(height: 16),
              
              // Additional Options
              _buildAdditionalOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.teal.shade100,
                child: Obx(() => CircleAvatar(
                  radius: 58,
                  backgroundImage: authController.user.value?['avatar'] != null
                      ? NetworkImage(authController.user.value!['avatar']!)
                      : null,
                  child: authController.user.value?['avatar'] == null
                      ? Icon(Icons.person, size: 60, color: Colors.teal.shade600)
                      : null,
                )),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              SnackbarHelper.showInfo(
                'Coming Soon',
                'Profile picture upload feature will be available soon!',
              );
            },
            icon: const Icon(Icons.photo_camera),
            label: const Text('Change Photo'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Enter a valid email address';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              enabled: false, // Email cannot be changed
            ),
            const SizedBox(height: 8),
            Text(
              'Email cannot be changed for security reasons',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Update Profile',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _buildAdditionalOptions() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.lock_outline, color: Colors.teal),
            title: const Text('Change Password'),
            subtitle: const Text('Update your account password'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              SnackbarHelper.showInfo(
                'Coming Soon',
                'Password change feature will be available soon!',
              );
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.phone_outlined, color: Colors.teal),
            title: const Text('Add Phone Number'),
            subtitle: const Text('Link your phone number for security'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              SnackbarHelper.showInfo(
                'Coming Soon',
                'Phone number verification will be available soon!',
              );
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
            subtitle: const Text('Permanently delete your account'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showDeleteAccountDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back();
              SnackbarHelper.showInfo(
                'Coming Soon',
                'Account deletion feature will be available soon!',
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
