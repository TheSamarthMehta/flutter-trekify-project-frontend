// lib/views/setting_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RxBool notificationsEnabled = true.obs;
    final RxBool darkModeEnabled = false.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: [
          // General Settings Section
          _buildSectionHeader('General'),
          Obx(() => SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable a dark theme for the app'),
            secondary: const Icon(Icons.dark_mode_outlined),
            value: darkModeEnabled.value,
            onChanged: (val) => darkModeEnabled.value = val,
          )),
          Obx(() => SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive updates and alerts'),
            secondary: const Icon(Icons.notifications_outlined),
            value: notificationsEnabled.value,
            onChanged: (val) => notificationsEnabled.value = val,
          )),

          const Divider(),

          // Account Settings Section
          _buildSectionHeader('Account'),
          _buildOptionTile(
            'Delete Account',
            Icons.delete_outline,
            Colors.red,
                () {
              Get.defaultDialog(
                title: "Delete Account",
                middleText: "Are you sure you want to permanently delete your account? This action cannot be undone.",
                textConfirm: "DELETE",
                textCancel: "Cancel",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () { /* Add delete account logic */ },
              );
            },
          ),

          const Divider(),

          // About Section
          _buildSectionHeader('About'),
          _buildOptionTile('Privacy Policy', Icons.privacy_tip_outlined, null, () {}),
          _buildOptionTile('Terms of Service', Icons.gavel_outlined, null, () {}),
          ListTile(
            title: const Text('App Version'),
            leading: const Icon(Icons.info_outline),
            trailing: const Text('1.0.0'),
          ),
        ],
      ),
    );
  }

  // Helper widget for section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.teal.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  // Helper widget for standard option tiles
  Widget _buildOptionTile(String title, IconData icon, Color? color, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: TextStyle(color: color)),
      leading: Icon(icon, color: color),
      onTap: onTap,
    );
  }
}
