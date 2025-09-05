// lib/views/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trekify/controllers/wishlist_controller.dart';
import 'package:trekify/widgets/custom_drawer.dart';
import 'package:trekify/widgets/trek_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the WishlistController instance
    final WishlistController controller = Get.find<WishlistController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Consistent background color
      extendBodyBehindAppBar: true,
      drawer: CustomDrawer(),
      body: Column(
        children: [
          // Beautiful Header Section
          _buildWishlistHeader(context),
          
          // Main Content
          Expanded(
            child: Obx(() {
              // If the wishlist is empty, show the placeholder UI
              if (controller.wishlistItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border_rounded,
                        size: 100,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Your Wishlist is Empty',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the heart on any trek to save it here.',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }

              // If the wishlist has items, display them in a list
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 32),
                itemCount: controller.wishlistItems.length,
                itemBuilder: (context, index) {
                  final trek = controller.wishlistItems[index];
                  // Use a Dismissible to allow swipe-to-remove functionality
                  return Dismissible(
                    key: Key(trek.trekName),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      controller.toggleWishlist(trek);
                    },
                    background: Container(
                      color: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                      ),
                    ),
                    child: TrekCard(trek: trek),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistHeader(BuildContext context) {
    // Get the status bar height to ensure proper spacing
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Container(
      height: 200 + statusBarHeight, // Add status bar height to total height
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
          
          // Hero Title - Fixed position
          Positioned(
            left: 28,
            bottom: 28,
            child: _buildWishlistTitle(),
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


  Widget _buildWishlistTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First line text
        Text(
          'Your',
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
          'Wishlist',
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
          'Save your favorite treks for later',
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
}