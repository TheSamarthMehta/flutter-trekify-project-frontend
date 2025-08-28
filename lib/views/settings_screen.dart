import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trekify/utils/snackbar_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _autoSaveEnabled = true;
  String _selectedLanguage = 'English';
  double _fontSize = 16.0;

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
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.teal,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Section
            _buildSectionHeader('Appearance'),
            _buildAppearanceSettings(),
            const SizedBox(height: 24),
            
            // Notifications Section
            _buildSectionHeader('Notifications'),
            _buildNotificationSettings(),
            const SizedBox(height: 24),
            
            // Privacy & Security Section
            _buildSectionHeader('Privacy & Security'),
            _buildPrivacySettings(),
            const SizedBox(height: 24),
            
            // App Settings Section
            _buildSectionHeader('App Settings'),
            _buildAppSettings(),
            const SizedBox(height: 24),
            
            // Support Section
            _buildSectionHeader('Support'),
            _buildSupportSettings(),
            const SizedBox(height: 24),
            
            // About Section
            _buildSectionHeader('About'),
            _buildAboutSettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildAppearanceSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Dark Mode Toggle
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Switch between light and dark theme'),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
              _toggleTheme(value);
            },
            secondary: Icon(
              _isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.teal,
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          
          // Font Size Slider
          ListTile(
            title: const Text('Font Size'),
            subtitle: Text('${_fontSize.round()}px'),
            leading: const Icon(Icons.text_fields, color: Colors.teal),
            trailing: SizedBox(
              width: 100,
              child: Slider(
                value: _fontSize,
                min: 12.0,
                max: 24.0,
                divisions: 12,
                label: '${_fontSize.round()}px',
                onChanged: (value) {
                  setState(() {
                    _fontSize = value;
                  });
                },
              ),
            ),
          ),
          
          // Language Selection
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_selectedLanguage),
            leading: const Icon(Icons.language, color: Colors.teal),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showLanguageDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive notifications about new treks and updates'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            secondary: const Icon(Icons.notifications, color: Colors.teal),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: const Text('Notification Sound'),
            subtitle: const Text('Play sound for notifications'),
            leading: const Icon(Icons.volume_up, color: Colors.teal),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              SnackbarHelper.showInfo(
                'Coming Soon',
                'Notification sound settings will be available soon!',
              );
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: const Text('Notification Schedule'),
            subtitle: const Text('Set quiet hours for notifications'),
            leading: const Icon(Icons.schedule, color: Colors.teal),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              SnackbarHelper.showInfo(
                'Coming Soon',
                'Notification schedule settings will be available soon!',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Location Services'),
            subtitle: const Text('Allow app to access your location'),
            value: _locationEnabled,
            onChanged: (value) {
              setState(() {
                _locationEnabled = value;
              });
            },
            secondary: const Icon(Icons.location_on, color: Colors.teal),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: const Text('Privacy Policy'),
            subtitle: const Text('Read our privacy policy'),
            leading: const Icon(Icons.privacy_tip, color: Colors.teal),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              SnackbarHelper.showInfo(
                'Privacy Policy',
                'Privacy policy will be available soon!',
              );
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: const Text('Terms of Service'),
            subtitle: const Text('Read our terms of service'),
            leading: const Icon(Icons.description, color: Colors.teal),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              SnackbarHelper.showInfo(
                'Terms of Service',
                'Terms of service will be available soon!',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Auto Save'),
            subtitle: const Text('Automatically save your progress'),
            value: _autoSaveEnabled,
            onChanged: (value) {
              setState(() {
                _autoSaveEnabled = value;
              });
            },
            secondary: const Icon(Icons.save, color: Colors.teal),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: const Text('Clear Cache'),
            subtitle: const Text('Free up storage space'),
            leading: const Icon(Icons.cleaning_services, color: Colors.teal),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showClearCacheDialog,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: const Text('Export Data'),
            subtitle: const Text('Export your trek data'),
            leading: const Icon(Icons.download, color: Colors.teal),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              SnackbarHelper.showInfo(
                'Coming Soon',
                'Data export feature will be available soon!',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            title: const Text('Help & Support'),
            subtitle: const Text('Get help and contact support'),
            leading: const Icon(Icons.help_outline, color: Colors.teal),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              SnackbarHelper.showInfo(
                'Help & Support',
                'Help and support will be available soon!',
              );
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: const Text('Report a Bug'),
            subtitle: const Text('Report issues or bugs'),
            leading: const Icon(Icons.bug_report, color: Colors.teal),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              SnackbarHelper.showInfo(
                'Report Bug',
                'Bug reporting will be available soon!',
              );
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: const Text('Rate App'),
            subtitle: const Text('Rate us on the app store'),
            leading: const Icon(Icons.star, color: Colors.teal),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              SnackbarHelper.showInfo(
                'Rate App',
                'App rating will be available soon!',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            title: const Text('About Trekify'),
            subtitle: const Text('Learn more about the app'),
            leading: const Icon(Icons.info_outline, color: Colors.teal),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.toNamed('/about');
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
            leading: const Icon(Icons.app_settings_alt, color: Colors.teal),
            enabled: false,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            title: const Text('Developer'),
            subtitle: const Text('Trekify Team'),
            leading: const Icon(Icons.person, color: Colors.teal),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.toNamed('/developer');
            },
          ),
        ],
      ),
    );
  }

  void _toggleTheme(bool isDark) {
    // Implement theme switching logic here
    if (isDark) {
      Get.changeTheme(ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.dark(primary: Colors.teal),
      ));
      SnackbarHelper.showSuccess(
        'Dark Mode',
        'Dark mode has been enabled!',
      );
    } else {
      Get.changeTheme(ThemeData.light().copyWith(
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.light(primary: Colors.teal),
      ));
      SnackbarHelper.showSuccess(
        'Light Mode',
        'Light mode has been enabled!',
      );
    }
  }

  void _showLanguageDialog() {
    final languages = ['English', 'Hindi', 'Gujarati', 'Spanish', 'French'];
    
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];
              return ListTile(
                title: Text(language),
                trailing: _selectedLanguage == language
                    ? const Icon(Icons.check, color: Colors.teal)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedLanguage = language;
                  });
                  Get.back();
                  SnackbarHelper.showSuccess(
                    'Language Changed',
                    'Language has been changed to $language!',
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cache'),
        content: const Text(
          'This will clear all cached data and free up storage space. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back();
              SnackbarHelper.showSuccess(
                'Cache Cleared',
                'Cache has been cleared successfully!',
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
