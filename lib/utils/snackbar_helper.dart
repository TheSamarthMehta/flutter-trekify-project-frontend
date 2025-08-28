import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  // Success snackbar
  static void showSuccess(String title, String message) {
    Get.snackbar(
      '✅ $title',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.teal.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      shouldIconPulse: true,
      barBlur: 10,
      overlayBlur: 0.5,
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  // Error snackbar
  static void showError(String title, String message) {
    Get.snackbar(
      '❌ $title',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.teal.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      shouldIconPulse: true,
      barBlur: 10,
      overlayBlur: 0.5,
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  // Warning snackbar
  static void showWarning(String title, String message) {
    Get.snackbar(
      '⚠️ $title',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.teal.shade400,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.warning_amber, color: Colors.white),
      shouldIconPulse: false,
      barBlur: 10,
      overlayBlur: 0.5,
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  // Info snackbar
  static void showInfo(String title, String message) {
    Get.snackbar(
      'ℹ️ $title',
      message,
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
  }

  // Login required snackbar
  static void showLoginRequired(String message) {
    Get.snackbar(
      '🔒 Login Required',
      message,
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
  }

  // Welcome snackbar
  static void showWelcome(String message) {
    Get.snackbar(
      '👋 Welcome!',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.teal.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.person_add, color: Colors.white),
      shouldIconPulse: true,
      barBlur: 10,
      overlayBlur: 0.5,
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  // Added to wishlist snackbar
  static void showAddedToWishlist(String trekName) {
    Get.snackbar(
      '❤️ Added to Wishlist',
      '$trekName has been added to your wishlist',
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

  // Removed from wishlist snackbar
  static void showRemovedFromWishlist(String trekName) {
    Get.snackbar(
      '🗑️ Removed from Wishlist',
      '$trekName has been removed from your wishlist',
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
  }

  // Added to itinerary snackbar
  static void showAddedToItinerary(String trekName) {
    Get.snackbar(
      '✅ Added to Itinerary',
      '$trekName has been added to your itinerary!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.teal.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      shouldIconPulse: true,
      barBlur: 10,
      overlayBlur: 0.5,
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  // Added to progress snackbar
  static void showAddedToProgress(String trekName) {
    Get.snackbar(
      '✅ Added to Progress',
      '$trekName has been added to your explored treks',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.teal.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      shouldIconPulse: true,
      barBlur: 10,
      overlayBlur: 0.5,
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  // Removed from progress snackbar
  static void showRemovedFromProgress(String trekName) {
    Get.snackbar(
      '🗑️ Removed from Progress',
      '$trekName has been removed from your explored treks',
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
  }
}
