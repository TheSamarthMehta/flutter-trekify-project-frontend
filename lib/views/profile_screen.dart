// lib/views/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      drawer: CustomDrawer(),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(authController),
            _buildUserInfo(authController),
            const SizedBox(height: 20),
            _buildStatsCard(),
            const SizedBox(height: 20),
            _buildOptionsList(authController),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AuthController authController) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        Positioned(
          top: 100,
          child: CircleAvatar(
            radius: 52,
            backgroundColor: Colors.white,
            child: Obx(() => CircleAvatar(
              radius: 50,
              backgroundImage: authController.user.value?['avatar'] != null
                  ? NetworkImage(authController.user.value!['avatar']!)
                  : null,
              child: authController.user.value?['avatar'] == null
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(AuthController authController) {
    return Container(
      padding: const EdgeInsets.only(top: 60),
      child: Obx(() => Column(
        children: [
          Text(
            authController.getCurrentUserName(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            authController.getCurrentUserEmail(),
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      )),
    );
  }

  Widget _buildStatsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Obx(() {
            final visitedStates = trekController.allTreks
                .where((trek) => statesController.exploredTreks.contains(trek.trekName))
                .map((trek) => trek.state)
                .toSet()
                .toList();

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => _showStatDetailsDialog(
                    context,
                    'My Treks',
                    itineraryController.itineraryTreks.map((t) => t.trekName).toList(),
                    '⛰️',
                  ),
                  child: _buildStatItem(
                    "My Treks",
                    itineraryController.itineraryTreks.length.toString(),
                    '⛰️',
                  ),
                ),
                GestureDetector(
                  onTap: () => _showStatDetailsDialog(
                    context,
                    'My Wishlist',
                    wishlistController.wishlistItems.map((t) => t.trekName).toList(),
                    '❤️',
                  ),
                  child: _buildStatItem(
                    "Wishlists",
                    wishlistController.wishlistItems.length.toString(),
                    '❤️',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showStatDetailsDialog(
                      context,
                      'States Visited',
                      visitedStates,
                      '🗺️',
                    );
                  },
                  child: _buildStatItem(
                    "States Visited",
                    visitedStates.length.toString(),
                    '🗺️',
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String emoji) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildOptionsList(AuthController authController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            _buildOptionItem(Icons.person_outline, "Edit Profile", () {
              Get.toNamed('/edit-profile');
            }),
            const Divider(height: 1, indent: 16, endIndent: 16),
                         _buildOptionItem(Icons.settings_outlined, "Settings", () {
               Get.toNamed('/settings');
             }),
             const Divider(height: 1, indent: 16, endIndent: 16),
             _buildOptionItem(Icons.logout, "Log Out", () {
               Get.defaultDialog(
                 title: "Log Out",
                 middleText: "Are you sure you want to log out?",
                 textConfirm: "Yes",
                 textCancel: "No",
                 confirmTextColor: Colors.white,
                 onConfirm: () => authController.signOut(),
               );
             }, color: Colors.red),
             const Divider(height: 1, indent: 16, endIndent: 16),
             _buildOptionItem(Icons.clear_all, "Clear Session (Test)", () {
               Get.defaultDialog(
                 title: "Clear Session",
                 middleText: "This will clear your session data and force you to login again. Useful for testing auto-logout functionality.",
                 textConfirm: "Clear",
                 textCancel: "Cancel",
                 confirmTextColor: Colors.white,
                 onConfirm: () {
                   authController.forceClearSession();
                   Get.back();
                   Get.snackbar(
                     '🧪 Session Cleared',
                     'Your session has been cleared. You will see the login screen on next app launch.',
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
                 },
               );
             }, color: Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(
      IconData icon,
      String title,
      VoidCallback onTap, {
        Color? color,
      }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.teal),
      title: Text(title, style: TextStyle(color: color, fontSize: 16)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: color ?? Colors.grey[400],
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
