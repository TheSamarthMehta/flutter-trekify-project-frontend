// lib/controllers/states_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trekify/controllers/trek_controller.dart';
import 'package:trekify/models/trek_model.dart';

class StateUIModel {
  final String name;
  final String imageUrl;
  StateUIModel({required this.name, required this.imageUrl});
}

class StatesController extends GetxController {
  final TrekController _trekController = Get.find<TrekController>();
  final _box = GetStorage();
  String? _currentUserId;

  var stateList = <StateUIModel>[].obs;
  var isLoading = true.obs;
  var exploredTreks = <String>{}.obs; // Tracks user's progress

  @override
  void onInit() {
    super.onInit();
    // General state info is not user-specific, so it can load on init
    _initializeStates();
  }

  /// ✅ NEW: Loads explored treks for a specific user.
  /// Called by AuthController after login.
  void loadExploredTreksForUser(String userId) {
    print('🔄 Loading explored treks for user: $userId');
    _currentUserId = userId;
    final userExploredKey = 'exploredTreks_$_currentUserId';
    final List<dynamic>? savedTreks = _box.read<List<dynamic>>(userExploredKey);
    if (savedTreks != null) {
      exploredTreks.value = savedTreks.cast<String>().toSet();
      print('✅ Loaded ${exploredTreks.length} explored treks for user: $userId');
    } else {
      exploredTreks.clear();
      print('📝 No existing explored treks found for user: $userId');
    }
  }

  /// ✅ NEW: Clears user-specific progress on logout.
  /// Called by AuthController.
  void clearData() {
    _currentUserId = null;
    exploredTreks.clear();
  }

  void toggleExploredTrek(String trekName) {
    print('🔄 Toggle explored trek: $trekName');
    print('👤 Current user ID: $_currentUserId');
    
    if (_currentUserId == null) {
      print('❌ No user logged in');
      Get.snackbar(
        '🔒 Login Required',
        'Please log in to track your progress',
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
    
    if (exploredTreks.contains(trekName)) {
      exploredTreks.remove(trekName);
      print('🗑️ Removed from explored: $trekName');
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
    } else {
      exploredTreks.add(trekName);
      print('✅ Added to explored: $trekName');
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
    _saveExploredTreks();
    exploredTreks.refresh(); // Important for updating UIs observing this set
  }

  void _saveExploredTreks() {
    if (_currentUserId == null) return;
    final userExploredKey = 'exploredTreks_$_currentUserId';
    _box.write(userExploredKey, exploredTreks.toList());
  }

  // --- Other methods like _initializeStates, getTreksForState, getCompletionPercentage remain the same ---

  Future<void> _initializeStates() async {
    isLoading.value = true;
    await _trekController.fetchTreks();
    _prepareStateList();
    isLoading.value = false;
  }

  void _prepareStateList() {
    if (_trekController.allTreks.isEmpty) {
      stateList.value = [];
      return;
    }
    final treks = _trekController.allTreks;
    final Map<String, String> statesMap = {};
    for (Trek trek in treks) {
      final stateName = trek.state.trim();
      if (stateName.isNotEmpty && !statesMap.containsKey(stateName) && trek.imageUrl.isNotEmpty) {
        statesMap[stateName] = trek.imageUrl;
      }
    }
    stateList.value = statesMap.entries
        .map((entry) => StateUIModel(name: entry.key, imageUrl: entry.value))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  List<Trek> getTreksForState(String stateName) {
    return _trekController.allTreks
        .where((trek) => trek.state == stateName)
        .toList();
  }

  double getCompletionPercentage(String stateName) {
    final treksInState = getTreksForState(stateName);
    if (treksInState.isEmpty) return 0.0;
    final exploredCount = treksInState
        .where((trek) => exploredTreks.contains(trek.trekName))
        .length;
    return (exploredCount / treksInState.length);
  }
}