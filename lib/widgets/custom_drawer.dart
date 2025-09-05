// lib/widgets/custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/app_drawer_controller.dart';
import '../utils/network_utils.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Home',
      'icon': Icons.home_rounded,
      'description': 'Discover adventures',
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'States',
      'icon': Icons.map_rounded,
      'description': 'Explore destinations',
      'color': const Color(0xFF3B82F6),
    },
    {
      'title': 'Treks',
      'icon': Icons.terrain_rounded,
      'description': 'Find your trail',
      'color': const Color(0xFF8B5CF6),
    },
    {
      'title': 'Wishlist',
      'icon': Icons.favorite_rounded,
      'description': 'Saved adventures',
      'color': const Color(0xFFEF4444),
    },
    {
      'title': 'Profile',
      'icon': Icons.person_rounded,
      'description': 'Your account',
      'color': const Color(0xFFF59E0B),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final drawerController = Get.find<AppDrawerController>();

    return Drawer(
      backgroundColor: Colors.transparent, // Make drawer background transparent
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // White background
        ),
        child: Column(
          children: [
            // Enhanced Header Section - extends to top
            _buildHeaderSection(),
            
            const SizedBox(height: 16), // Space after header
            
            // User Profile Section
            _buildUserProfileSection(),
            
            const SizedBox(height: 20), // Space after user profile
            
            // Menu Items
            Expanded(
              child: GetBuilder<AppDrawerController>(
                builder: (controller) {
                                       return SingleChildScrollView(
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: List.generate(menuItems.length, (index) {
                        final isSelected = controller.selectedIndex.value == index;
                        final item = menuItems[index];

                        return _buildMenuItem(
                          context: context,
                          item: item,
                          isSelected: isSelected,
                          onTap: () => controller.selectPageFromDrawer(index),
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16), // Space before footer
            
            // Footer Section
            _buildFooterSection(),
          ],
        ),
      ),
    );
  }

    Widget _buildHeaderSection() {
    return Container(
      height: 100, // Restored to a good size
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF059669), // Solid emerald green
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          // Status bar area - extend to top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(Get.context!).padding.top,
            child: Container(color: Color(0xFF059669)),
          ),
          // Centered text
          Center(
            child: Text(
              'EXPLORE ADVENTURES',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
                     // User Avatar
           Container(
             width: 36,
             height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF10B981),
                  const Color(0xFF059669),
                ],
              ),
                             borderRadius: BorderRadius.circular(12),
               boxShadow: [
                 BoxShadow(
                   color: const Color(0xFF10B981).withOpacity(0.3),
                   blurRadius: 6,
                   offset: const Offset(0, 3),
                 ),
               ],
             ),
             child: const Icon(
               Icons.person_rounded,
               color: Colors.white,
               size: 18,
             ),
          ),
          
                     const SizedBox(width: 10),
           
                      // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ready for your next adventure?',
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade800,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          
                     // Settings Icon
           Container(
             padding: const EdgeInsets.all(5),
             decoration: BoxDecoration(
               color: Colors.grey.shade200,
               borderRadius: BorderRadius.circular(8),
             ),
             child: Icon(
               Icons.settings_rounded,
               color: Colors.grey.shade600,
               size: 16,
             ),
           ),
        ],
      ),
    );
  }

    Widget _buildMenuItem({
    required BuildContext context,
    required Map<String, dynamic> item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8), // Increased spacing between menu items
      decoration: BoxDecoration(
        color: isSelected 
            ? item['color'].withOpacity(0.1)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected 
              ? item['color'].withOpacity(0.4)
              : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: item['color'].withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              children: [
                // Enhanced Icon Container
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? item['color']
                        : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: item['color'].withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                        spreadRadius: 0,
                      ),
                    ] : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                        spreadRadius: 0,
                      ),
                    ],
                    border: Border.all(
                      color: isSelected 
                          ? item['color'].withOpacity(0.3)
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    item['icon'],
                    color: isSelected 
                        ? Colors.white
                        : item['color'],
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 18),
                
                // Enhanced Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: GoogleFonts.poppins(
                          color: isSelected 
                              ? Colors.white
                              : Colors.grey.shade800,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['description'],
                        style: GoogleFonts.poppins(
                          color: isSelected 
                              ? Colors.white.withOpacity(0.85)
                              : Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Enhanced Selection Indicator
                if (isSelected)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: item['color'],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: item['color'].withOpacity(0.6),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          // Divider
          Container(
            height: 1,
                           decoration: BoxDecoration(
                 gradient: LinearGradient(
                   colors: [
                     Colors.transparent,
                     Colors.grey.shade300,
                     Colors.transparent,
                   ],
                 ),
               ),
          ),
          
                     const SizedBox(height: 10),
           
           // Footer Content
          Row(
            children: [
              // App Version
              Expanded(
                child: Text(
                  'Trekify v1.0.0',
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              
                             // Social/Support Icons
               Row(
                 children: [
                                       _buildFooterIcon(Icons.help_outline_rounded, 'Help'),
                    const SizedBox(width: 10),
                    _buildFooterIcon(Icons.info_outline_rounded, 'About'),
                    const SizedBox(width: 10),
                                       _buildFooterIcon(Icons.wifi_find_rounded, 'Network', onTap: () {
                      Get.back(); // Close drawer
                      NetworkUtils.showNetworkDiagnostic();
                    }),
                 ],
               ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterIcon(IconData icon, String tooltip, {VoidCallback? onTap}) {
    Widget iconWidget = Container(
      padding: const EdgeInsets.all(5),
             decoration: BoxDecoration(
         color: Colors.grey.shade200,
         borderRadius: BorderRadius.circular(6),
       ),
       child: Icon(
         icon,
         color: Colors.grey.shade600,
        size: 14,
      ),
    );

    if (onTap != null) {
      return Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: iconWidget,
          ),
        ),
      );
    }

    return Tooltip(
      message: tooltip,
      child: iconWidget,
    );
  }
}
