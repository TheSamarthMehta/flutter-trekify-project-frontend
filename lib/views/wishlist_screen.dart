// lib/views/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: Colors.teal,
      ),
      drawer: CustomDrawer(),
      body: Obx(() {
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
    );
  }
}