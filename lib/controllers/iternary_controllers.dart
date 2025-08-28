// lib/controllers/itinerary_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trekify/models/trek_model.dart';

class ItineraryController extends GetxController {
  final _box = GetStorage();
  var itineraryTreks = <Trek>[].obs;
  String? _currentUserId; // Stores the current user's ID

  /// ✅ NEW: Loads itinerary for a specific user.
  /// This should be called by AuthController after login.
  void loadItineraryForUser(String userId) {
    print('🔄 Loading itinerary for user: $userId');
    _currentUserId = userId;
    final userItineraryKey = 'itinerary_$_currentUserId';
    final List<dynamic>? savedItinerary = _box.read<List<dynamic>>(userItineraryKey);
    if (savedItinerary != null) {
      itineraryTreks.value = savedItinerary.map((json) => Trek.fromJson(json as Map<String, dynamic>)).toList();
      print('✅ Loaded ${itineraryTreks.length} itinerary items for user: $userId');
    } else {
      itineraryTreks.clear();
      print('📝 No existing itinerary found for user: $userId');
    }
  }

  /// ✅ NEW: Clears data when a user logs out.
  /// Called by AuthController.
  void clearData() {
    _currentUserId = null;
    itineraryTreks.clear();
  }

  void addToItinerary(Trek trek) {
    print('🔄 Adding to itinerary: ${trek.trekName}');
    print('👤 Current user ID: $_currentUserId');
    
    if (_currentUserId == null) {
      print('❌ No user logged in');
      Get.snackbar(
        '🔒 Login Required',
        'Please log in to manage your itinerary',
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
    
    if (itineraryTreks.any((t) => t.trekName == trek.trekName)) {
      print('⚠️ Trek already in itinerary');
      Get.snackbar(
        '⚠️ Already Added',
        '${trek.trekName} is already in your itinerary',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.teal.shade400,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.info_outline, color: Colors.white),
        shouldIconPulse: false,
        barBlur: 10,
        overlayBlur: 0.5,
        animationDuration: const Duration(milliseconds: 500),
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInBack,
      );
    } else {
      itineraryTreks.add(trek);
      _saveItinerary();
      print('✅ Added to itinerary: ${trek.trekName}');
      Get.snackbar(
        '✅ Added to Itinerary',
        '${trek.trekName} has been added to your itinerary!',
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
  }

  void _saveItinerary() {
    if (_currentUserId == null) return;
    final userItineraryKey = 'itinerary_$_currentUserId';
    final List<Map<String, dynamic>> itineraryJson = itineraryTreks.map((trek) => trek.toJson()).toList();
    _box.write(userItineraryKey, itineraryJson);
  }
}