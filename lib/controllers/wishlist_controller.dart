// lib/controllers/wishlist_controller.dart
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
    _currentUserId = userId;
    final userWishlistKey = 'wishlist_$_currentUserId';
    final List<dynamic>? wishlistJson = _box.read<List<dynamic>>(userWishlistKey);
    if (wishlistJson != null) {
      wishlistItems.value = wishlistJson.map((json) => Trek.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      wishlistItems.clear(); // Ensure list is empty if no saved data exists
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
    if (_currentUserId == null) {
      Get.snackbar('Error', 'Please log in to manage your wishlist.');
      return;
    }
    if (isInWishlist(trek)) {
      wishlistItems.removeWhere((item) => item.trekName == trek.trekName);
    } else {
      wishlistItems.add(trek);
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