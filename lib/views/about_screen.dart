import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Trekify'),
        backgroundColor: Colors.teal,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey.shade50, // Consistent background color
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Title
            _buildAppHeader(),
            const SizedBox(height: 24),
            
            // App Description
            _buildAppDescription(),
            const SizedBox(height: 24),
            
            // Features Section
            _buildFeaturesSection(),
            const SizedBox(height: 24),
            
            // Version Info
            _buildVersionInfo(),
            const SizedBox(height: 24),
            
            // Contact Section
            _buildContactSection(),
            const SizedBox(height: 24),
            
            // Social Links
            _buildSocialLinks(),
            const SizedBox(height: 24),
            
            // Legal Links
            _buildLegalLinks(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.terrain,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Trekify',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your Ultimate Trekking Companion',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppDescription() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Trekify',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Trekify is your comprehensive trekking companion designed to help you discover, plan, and track your outdoor adventures. Whether you\'re a seasoned trekker or just starting your journey, Trekify provides everything you need to explore the beautiful trails and mountains.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Our mission is to connect trekkers with nature, provide detailed information about trekking destinations, and help you create unforgettable memories in the great outdoors.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Key Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              icon: Icons.explore,
              title: 'Discover Treks',
              description: 'Explore hundreds of trekking destinations with detailed information',
            ),
            _buildFeatureItem(
              icon: Icons.favorite,
              title: 'Wishlist',
              description: 'Save your favorite treks for future planning',
            ),
            _buildFeatureItem(
              icon: Icons.list_alt,
              title: 'Itinerary Planning',
              description: 'Plan your trekking adventures with our itinerary feature',
            ),
            _buildFeatureItem(
              icon: Icons.location_on,
              title: 'Progress Tracking',
              description: 'Track your trekking progress and visited states',
            ),
            _buildFeatureItem(
              icon: Icons.reviews,
              title: 'Reviews & Ratings',
              description: 'Read and share experiences with the trekking community',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.teal, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('Version', '1.0.0'),
            const Divider(),
            _buildInfoRow('Build Number', '2024.1.0'),
            const Divider(),
            _buildInfoRow('Release Date', 'January 2024'),
            const Divider(),
            _buildInfoRow('Platform', 'Android & iOS'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              icon: Icons.email,
              title: 'Email',
              value: 'support@trekify.com',
              onTap: () => _launchEmail(),
            ),
            _buildContactItem(
              icon: Icons.phone,
              title: 'Phone',
              value: '+1 (555) 123-4567',
              onTap: () => _launchPhone(),
            ),
            _buildContactItem(
              icon: Icons.web,
              title: 'Website',
              value: 'www.trekify.com',
              onTap: () => _launchWebsite(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSocialLinks() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Follow Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialButton(
                  icon: Icons.facebook,
                  label: 'Facebook',
                  color: Colors.blue,
                  onTap: () => _launchSocial('facebook'),
                ),
                _buildSocialButton(
                  icon: Icons.camera_alt,
                  label: 'Instagram',
                  color: Colors.purple,
                  onTap: () => _launchSocial('instagram'),
                ),
                _buildSocialButton(
                  icon: Icons.flutter_dash,
                  label: 'Twitter',
                  color: Colors.lightBlue,
                  onTap: () => _launchSocial('twitter'),
                ),
                _buildSocialButton(
                  icon: Icons.play_circle,
                  label: 'YouTube',
                  color: Colors.red,
                  onTap: () => _launchSocial('youtube'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalLinks() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Legal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.privacy_tip, color: Colors.teal),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _launchPrivacyPolicy(),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.description, color: Colors.teal),
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _launchTermsOfService(),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.copyright, color: Colors.teal),
              title: const Text('Copyright'),
              subtitle: const Text('© 2024 Trekify. All rights reserved.'),
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }

  // Action methods
  void _launchEmail() {
    Get.snackbar('Info', 'Email support will be available soon');
  }

  void _launchPhone() {
    Get.snackbar('Info', 'Phone support will be available soon');
  }

  void _launchWebsite() {
    Get.snackbar('Info', 'Website will be available soon');
  }

  void _launchSocial(String platform) {
    Get.snackbar('Info', '$platform page will be available soon');
  }

  void _launchPrivacyPolicy() {
    Get.snackbar('Info', 'Privacy policy will be available soon');
  }

  void _launchTermsOfService() {
    Get.snackbar('Info', 'Terms of service will be available soon');
  }
}
