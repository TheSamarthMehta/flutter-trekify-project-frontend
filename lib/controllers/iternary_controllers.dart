// lib/controllers/itinerary_controller.dart
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
    _currentUserId = userId;
    final userItineraryKey = 'itinerary_$_currentUserId';
    final List<dynamic>? savedItinerary = _box.read<List<dynamic>>(userItineraryKey);
    if (savedItinerary != null) {
      itineraryTreks.value = savedItinerary.map((json) => Trek.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      itineraryTreks.clear();
    }
  }

  /// ✅ NEW: Clears data when a user logs out.
  /// Called by AuthController.
  void clearData() {
    _currentUserId = null;
    itineraryTreks.clear();
  }

  void addToItinerary(Trek trek) {
    if (_currentUserId == null) {
      Get.snackbar('Error', 'Please log in to manage your itinerary.');
      return;
    }
    if (itineraryTreks.any((t) => t.trekName == trek.trekName)) {
      Get.snackbar('Already Added', '${trek.trekName} is already in your itinerary.');
    } else {
      itineraryTreks.add(trek);
      _saveItinerary();
      Get.snackbar('Success', '${trek.trekName} added to your itinerary!');
    }
  }

  void _saveItinerary() {
    if (_currentUserId == null) return;
    final userItineraryKey = 'itinerary_$_currentUserId';
    final List<Map<String, dynamic>> itineraryJson = itineraryTreks.map((trek) => trek.toJson()).toList();
    _box.write(userItineraryKey, itineraryJson);
  }
}