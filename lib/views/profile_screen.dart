// lib/views/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trekify/controllers/auth_controller.dart';
import 'package:trekify/controllers/trek_controller.dart';
import 'package:trekify/widgets/custom_drawer.dart';
import '../controllers/iternary_controllers.dart';
import '../controllers/states_controller.dart';
import '../controllers/wishlist_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = Get.find<AuthController>();
  final ItineraryController itineraryController = Get.find<ItineraryController>();
  final WishlistController wishlistController = Get.find<WishlistController>();
  final StatesController statesController = Get.find<StatesController>();
  final TrekController trekController = Get.find<TrekController>();
  

  void _showStatDetailsDialog(BuildContext context, String title, List<String> items, String emoji) {
    if (items.isEmpty) {
      Get.snackbar(
        '📝 $title',
        "You haven't added any items here yet.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.teal.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.info_outline, color: Colors.white),
        shouldIconPulse: true,
        barBlur: 10,
        overlayBlur: 0.5,
        animationDuration: const Duration(milliseconds: 500),
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInBack,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text(emoji, style: const TextStyle(fontSize: 24)),
                title: Text(items[index]),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Consistent background color
      extendBodyBehindAppBar: true,
      drawer: CustomDrawer(),
      body: Column(
        children: [
          // Beautiful Header Section
          _buildProfileHeaderSection(context),
          
          // Main Content
          Expanded(
            child: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserInfo(authController),
            const SizedBox(height: 24),
            _buildStatsSection(),
            const SizedBox(height: 32),
            _buildAccountSection(authController),
            const SizedBox(height: 32),
            _buildSupportSection(),
            const SizedBox(height: 32),
            _buildLogoutSection(authController),
            const SizedBox(height: 32),
          ],
        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeaderSection(BuildContext context) {
    // Get the status bar height to ensure proper spacing
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Container(
      height: 280 + statusBarHeight, // Increased height to accommodate profile picture
      child: Stack(
        fit: StackFit.expand,
      children: [
          // Beautiful Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1E3A8A), // Deep blue
                  const Color(0xFF3B82F6), // Blue
                  const Color(0xFF059669), // Emerald
                  const Color(0xFF10B981), // Light emerald
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),
          
          // Enhanced overlay for better readability
        Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.25),
                  Colors.black.withOpacity(0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          
          // Navigation Buttons - positioned below status bar
          Positioned(
            top: statusBarHeight + 16,
            left: 24,
            child: _buildMenuButton(context),
          ),
          
          // Profile Picture - positioned in the center
          Positioned(
            top: statusBarHeight + 80,
            left: 0,
            right: 0,
            child: _buildProfilePicture(authController),
          ),
          
          // Hero Title - Fixed position at bottom
          Positioned(
            left: 28,
            bottom: 28,
            child: _buildProfileTitle(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return Builder(
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 26),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }


  Widget _buildProfilePicture(AuthController authController) {
    return Obx(() => CircleAvatar(
      radius: 60,
      backgroundColor: Colors.white,
          child: CircleAvatar(
        radius: 58,
              backgroundImage: authController.user.value?['avatar'] != null
                  ? NetworkImage(authController.user.value!['avatar']!)
                  : null,
              child: authController.user.value?['avatar'] == null
            ? const Icon(Icons.person, size: 60, color: Colors.grey)
                  : null,
      ),
    ));
  }

  Widget _buildProfileTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First line text
        Text(
          'My',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Colors.white.withOpacity(0.95),
            height: 1.1,
          ).copyWith(
            fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 0.9,
            letterSpacing: -0.5,
          ).copyWith(
            fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your account and preferences',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w400,
            height: 1.2,
          ).copyWith(
            fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(AuthController authController) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Obx(() => Column(
        children: [
          Text(
            authController.getCurrentUserName(),
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            authController.getCurrentUserEmail(),
            style: GoogleFonts.poppins(
              fontSize: 16, 
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      )),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Journey',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final visitedStates = trekController.allTreks
                .where((trek) => statesController.exploredTreks.contains(trek.trekName))
                .map((trek) => trek.state)
                .toSet()
                .toList();

            return Row(
              children: [
                Expanded(
                  child: _buildModernStatCard(
                    'Treks',
                    itineraryController.itineraryTreks.length.toString(),
                    '⛰️',
                    const Color(0xFF3B82F6),
                    () => _showStatDetailsDialog(
                    context,
                    'My Treks',
                    itineraryController.itineraryTreks.map((t) => t.trekName).toList(),
                    '⛰️',
                  ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildModernStatCard(
                    'Wishlist',
                    wishlistController.wishlistItems.length.toString(),
                    '❤️',
                    const Color(0xFFEF4444),
                    () => _showStatDetailsDialog(
                    context,
                    'My Wishlist',
                    wishlistController.wishlistItems.map((t) => t.trekName).toList(),
                    '❤️',
                  ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildModernStatCard(
                    'States',
                    visitedStates.length.toString(),
                    '🗺️',
                    const Color(0xFF059669),
                    () => _showStatDetailsDialog(
                      context,
                      'States Visited',
                      visitedStates,
                      '🗺️',
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildModernStatCard(String label, String value, String emoji, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildAccountSection(AuthController authController) {
    return _buildSection(
      'Account',
      [
        _buildModernOptionItem(
          Icons.person_outline,
          'Edit Profile',
          'Update your personal information',
          () => Get.toNamed('/edit-profile'),
        ),
      ],
    );
  }


  Widget _buildSupportSection() {
    return _buildSection(
      'Support',
      [
        _buildModernOptionItem(
          Icons.feedback_outlined,
          'Send Feedback',
          'Coming Soon',
          () => _showComingSoonDialog('Send Feedback'),
        ),
        _buildModernOptionItem(
          Icons.info_outline,
          'About Trekify',
          'App version and information',
          () => Get.toNamed('/about'),
        ),
      ],
    );
  }

  Widget _buildLogoutSection(AuthController authController) {
    return _buildSection(
      'Account Actions',
      [
        _buildModernOptionItem(
          Icons.logout,
          'Sign Out',
          'Sign out of your account',
          () => _showLogoutDialog(authController),
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildModernOptionItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
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
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(AuthController authController) {
               Get.defaultDialog(
      title: "Sign Out",
      titleStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      middleText: "Are you sure you want to sign out?",
      middleTextStyle: GoogleFonts.poppins(),
      textConfirm: "Yes, Sign Out",
      textCancel: "Cancel",
                 confirmTextColor: Colors.white,
      buttonColor: Colors.red,
                 onConfirm: () => authController.signOut(),
               );
  }





  void _showComingSoonDialog(String feature) {
    Get.defaultDialog(
      title: "🚀 Coming Soon",
      titleStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      middleText: "$feature feature is under development and will be available in a future update.",
      middleTextStyle: GoogleFonts.poppins(),
      textConfirm: "Got it",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF059669),
      onConfirm: () => Get.back(),
    );
  }
}
