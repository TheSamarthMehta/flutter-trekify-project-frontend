import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Team'),
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
            // Team Header
            _buildTeamHeader(),
            const SizedBox(height: 24),
            
            // Lead Developer
            _buildLeadDeveloper(),
            const SizedBox(height: 24),
            
            // Development Team
            _buildDevelopmentTeam(),
            const SizedBox(height: 24),
            
            // Technologies Used
            _buildTechnologiesSection(),
            const SizedBox(height: 24),
            
            // Development Timeline
            _buildTimelineSection(),
            const SizedBox(height: 24),
            
            // Contact Information
            _buildContactSection(),
            const SizedBox(height: 24),
            
            // GitHub & Portfolio
            _buildPortfolioSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.code,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Trekify Development Team',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Passionate developers creating amazing experiences',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLeadDeveloper() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Lead Developer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal.shade100,
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Samarth Patel',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Full Stack Developer & UI/UX Designer',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Passionate about creating user-friendly applications and exploring new technologies. Specializes in Flutter development and modern web technologies.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialButton(
                  icon: Icons.email,
                  label: 'Email',
                  color: Colors.blue,
                  onTap: () => _launchEmail('samarth@trekify.com'),
                ),
                _buildSocialButton(
                  icon: Icons.link,
                  label: 'LinkedIn',
                  color: Colors.lightBlue,
                  onTap: () => _launchLinkedIn(),
                ),
                _buildSocialButton(
                  icon: Icons.code,
                  label: 'GitHub',
                  color: Colors.black87,
                  onTap: () => _launchGitHub(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevelopmentTeam() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Development Team',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            _buildTeamMember(
              name: 'Niyati Sapariya',
              role: 'Backend Developer',
              description: 'Expert in Node.js, Express, and MongoDB. Handles server-side logic and database management.',
              icon: Icons.storage,
            ),
            const Divider(height: 24),
            _buildTeamMember(
              name: 'Priya Sharma',
              role: 'UI/UX Designer',
              description: 'Creates beautiful and intuitive user interfaces. Specializes in user experience design.',
              icon: Icons.design_services,
            ),
            const Divider(height: 24),
            _buildTeamMember(
              name: 'Rahul Kumar',
              role: 'Mobile Developer',
              description: 'Flutter expert with experience in cross-platform mobile development.',
              icon: Icons.phone_android,
            ),
            const Divider(height: 24),
            _buildTeamMember(
              name: 'Anjali Singh',
              role: 'QA Engineer',
              description: 'Ensures app quality through comprehensive testing and bug reporting.',
              icon: Icons.bug_report,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
    required String description,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.teal, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                role,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTechnologiesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Technologies Used',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildTechChip('Flutter', Icons.flutter_dash, Colors.blue),
                _buildTechChip('Dart', Icons.code, Colors.blue.shade700),
                _buildTechChip('GetX', Icons.get_app, Colors.purple),
                _buildTechChip('Node.js', Icons.code, Colors.green),
                _buildTechChip('MongoDB', Icons.storage, Colors.green.shade600),
                _buildTechChip('Express.js', Icons.api, Colors.grey.shade700),
                _buildTechChip('REST API', Icons.http, Colors.orange),
                _buildTechChip('Git', Icons.source, Colors.orange.shade700),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Development Timeline',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            _buildTimelineItem(
              date: 'January 2024',
              title: 'Project Initiation',
              description: 'Started planning and designing the Trekify application',
              icon: Icons.rocket_launch,
            ),
            _buildTimelineItem(
              date: 'February 2024',
              title: 'Development Phase',
              description: 'Began coding the core features and UI components',
              icon: Icons.code,
            ),
            _buildTimelineItem(
              date: 'March 2024',
              title: 'Testing & Refinement',
              description: 'Comprehensive testing and bug fixes',
              icon: Icons.bug_report,
            ),
            _buildTimelineItem(
              date: 'April 2024',
              title: 'Launch Preparation',
              description: 'Final polish and preparation for app store release',
              icon: Icons.publish,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String date,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
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
              'Contact Information',
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
              value: 'dev@trekify.com',
              onTap: () => _launchEmail('dev@trekify.com'),
            ),
            _buildContactItem(
              icon: Icons.phone,
              title: 'Phone',
              value: '+1 (555) 987-6543',
              onTap: () => _launchPhone(),
            ),
            _buildContactItem(
              icon: Icons.location_on,
              title: 'Location',
              value: 'Ahmedabad, Gujarat, India',
              onTap: () => _launchLocation(),
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

  Widget _buildPortfolioSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Portfolio & Links',
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
                _buildPortfolioButton(
                  icon: Icons.code,
                  label: 'GitHub',
                  color: Colors.black87,
                  onTap: () => _launchGitHub(),
                ),
                _buildPortfolioButton(
                  icon: Icons.link,
                  label: 'LinkedIn',
                  color: Colors.lightBlue,
                  onTap: () => _launchLinkedIn(),
                ),
                _buildPortfolioButton(
                  icon: Icons.web,
                  label: 'Portfolio',
                  color: Colors.purple,
                  onTap: () => _launchPortfolio(),
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioButton({
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
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Action methods
  void _launchEmail(String email) {
    Get.snackbar('Info', 'Email $email will be available soon');
  }

  void _launchPhone() {
    Get.snackbar('Info', 'Phone support will be available soon');
  }

  void _launchLocation() {
    Get.snackbar('Info', 'Location details will be available soon');
  }

  void _launchGitHub() {
    Get.snackbar('Info', 'GitHub repository will be available soon');
  }

  void _launchLinkedIn() {
    Get.snackbar('Info', 'LinkedIn profile will be available soon');
  }

  void _launchPortfolio() {
    Get.snackbar('Info', 'Portfolio website will be available soon');
  }
}
