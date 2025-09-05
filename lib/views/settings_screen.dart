import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trekify/utils/snackbar_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    // Load saved settings from storage (you can implement this with GetStorage)
    // For now, using default values
  }

  void _saveSettings() {
    // Save settings to storage (you can implement this with GetStorage)
    SnackbarHelper.showSuccess(
      'Settings Saved',
      'Your settings have been saved successfully!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF059669),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GENERAL Section
            _buildSectionHeader('GENERAL'),
            _buildGeneralSection(),
            const SizedBox(height: 32),
            
            // ACCOUNT Section
            _buildSectionHeader('ACCOUNT'),
            _buildAccountSection(),
            const SizedBox(height: 32),
            
            // ABOUT Section
            _buildSectionHeader('ABOUT'),
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF059669),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildGeneralSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Appearance - Only Dark/Light Mode
          _buildSettingItem(
            icon: Icons.palette,
            title: 'Appearance',
            subtitle: 'Light and Dark Mode',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: _showAppearanceDialog,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          
          // Push Notifications
          _buildSettingItem(
            icon: Icons.notifications,
            title: 'Push Notifications',
            subtitle: 'Receive updates and alerts',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                SnackbarHelper.showSuccess(
                  'Notifications',
                  _notificationsEnabled ? 'Notifications enabled!' : 'Notifications disabled!',
                );
              },
              activeColor: const Color(0xFF059669),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Delete Account
          _buildSettingItem(
            icon: Icons.delete,
            title: 'Delete Account',
            subtitle: null,
            trailing: null,
            isDestructive: true,
            onTap: _showDeleteAccountDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Privacy Policy
          _buildSettingItem(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            subtitle: null,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              SnackbarHelper.showInfo(
                'Privacy Policy',
                'Privacy policy will be available soon!',
              );
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          
          // Terms of Service
          _buildSettingItem(
            icon: Icons.description,
            title: 'Terms of Service',
            subtitle: null,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              SnackbarHelper.showInfo(
                'Terms of Service',
                'Terms of service will be available soon!',
              );
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          
          // App Version
          _buildSettingItem(
            icon: Icons.info,
            title: 'App Version',
            subtitle: null,
            trailing: Text(
              '1.0.0',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            onTap: null,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isDestructive ? Colors.red : const Color(0xFF059669)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : const Color(0xFF059669),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? Colors.red : Colors.grey.shade800,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  void _toggleTheme(bool isDark) {
    // Implement theme switching logic here
    if (isDark) {
      Get.changeTheme(ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF059669),
        colorScheme: const ColorScheme.dark(primary: Color(0xFF059669)),
      ));
      SnackbarHelper.showSuccess(
        'Dark Mode',
        'Dark mode has been enabled!',
      );
    } else {
      Get.changeTheme(ThemeData.light().copyWith(
        primaryColor: const Color(0xFF059669),
        colorScheme: const ColorScheme.light(primary: Color(0xFF059669)),
      ));
      SnackbarHelper.showSuccess(
        'Light Mode',
        'Light mode has been enabled!',
      );
    }
  }

  void _showAppearanceDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Appearance',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Light Mode Option
            _buildThemeOption(
              icon: Icons.light_mode,
              title: 'Light Mode',
              subtitle: 'Default light theme',
              isSelected: !_isDarkMode,
              onTap: () {
                setState(() {
                  _isDarkMode = false;
                });
                _toggleTheme(false);
                Get.back();
              },
            ),
            const SizedBox(height: 12),
            
            // Dark Mode Option
            _buildThemeOption(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: 'Dark theme for better viewing',
              isSelected: _isDarkMode,
              onTap: () {
                setState(() {
                  _isDarkMode = true;
                });
                _toggleTheme(true);
                Get.back();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF059669).withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF059669) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF059669) : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFF059669) : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF059669),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Account',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back();
              SnackbarHelper.showError(
                'Account Deletion',
                'Account deletion feature will be available soon!',
              );
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}