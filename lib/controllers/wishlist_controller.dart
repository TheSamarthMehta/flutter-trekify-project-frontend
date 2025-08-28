// lib/controllers/wishlist_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trekify/models/trek_model.dart';

class WishlistController extends GetxController {
  var wishlistItems = <Trek>[].obs;
  final _box = GetStorage();
  String? _currentUserId; // Stores the current user's ID

  /// ✅ NEW: Loads the wishlist for a specific user.
  /// This should be called by AuthController after a user logs in.
  void loadWishlistForUser(String userId) {
    print('🔄 Loading wishlist for user: $userId');
    _currentUserId = userId;
    final userWishlistKey = 'wishlist_$_currentUserId';
    final List<dynamic>? wishlistJson = _box.read<List<dynamic>>(userWishlistKey);
    if (wishlistJson != null) {
      wishlistItems.value = wishlistJson.map((json) => Trek.fromJson(json as Map<String, dynamic>)).toList();
      print('✅ Loaded ${wishlistItems.length} items for user: $userId');
    } else {
      wishlistItems.clear(); // Ensure list is empty if no saved data exists
      print('📝 No existing wishlist found for user: $userId');
    }
  }

  /// ✅ NEW: Clears data when a user logs out.
  /// Called by AuthController.
  void clearData() {
    _currentUserId = null;
    wishlistItems.clear();
  }

  // Check if a trek is in the wishlist
  bool isInWishlist(Trek trek) {
    return wishlistItems.any((item) => item.trekName == trek.trekName);
  }

  // Toggle trek's wishlist status
  void toggleWishlist(Trek trek) {
    print('🔄 Toggle wishlist for trek: ${trek.trekName}');
    print('👤 Current user ID: $_currentUserId');
    
    if (_currentUserId == null) {
      print('❌ No user logged in');
      Get.snackbar(
        '🔒 Login Required',
        'Please log in to manage your wishlist',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.teal.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.lock, color: Colors.white),
        shouldIconPulse: true,
        barBlur: 10,
        overlayBlur: 0.5,
        animationDuration: const Duration(milliseconds: 500),
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInBack,
      );
      return;
    }
    
    if (isInWishlist(trek)) {
      wishlistItems.removeWhere((item) => item.trekName == trek.trekName);
      print('🗑️ Removed from wishlist: ${trek.trekName}');
      Get.snackbar(
        '🗑️ Removed from Wishlist',
        '${trek.trekName} has been removed from your wishlist',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.teal.shade400,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
        shouldIconPulse: false,
        barBlur: 10,
        overlayBlur: 0.5,
        animationDuration: const Duration(milliseconds: 500),
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInBack,
      );
    } else {
      wishlistItems.add(trek);
      print('❤️ Added to wishlist: ${trek.trekName}');
      Get.snackbar(
        '❤️ Added to Wishlist',
        '${trek.trekName} has been added to your wishlist',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.teal.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.favorite, color: Colors.white),
        shouldIconPulse: true,
        barBlur: 10,
        overlayBlur: 0.5,
        animationDuration: const Duration(milliseconds: 500),
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInBack,
      );
    }
    _saveWishlist(); // Save changes to storage
  }

  // Save the current wishlist to the device using a user-specific key
  void _saveWishlist() {
    if (_currentUserId == null) return; // Don't save if no user
    final userWishlistKey = 'wishlist_$_currentUserId';
    final List<Map<String, dynamic>> wishlistJson = wishlistItems.map((trek) => trek.toJson()).toList();
    _box.write(userWishlistKey, wishlistJson);
  }
}