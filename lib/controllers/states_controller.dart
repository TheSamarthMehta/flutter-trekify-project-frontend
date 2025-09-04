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
    // Initialize states with trek data
    initializeStatesWithTreks();
  }

  /// Initialize basic state data without TrekController dependency
  void _initializeBasicStates() {
    stateList.value = [];
    isLoading.value = false;
  }

  /// Initialize states with trek data when TrekController is available
  Future<void> initializeStatesWithTreks() async {
    try {
      print('🔄 Starting states initialization...');
      isLoading.value = true;
      
      // Check if TrekController has data
      print('📊 TrekController has ${_trekController.allTreks.length} treks');
      
      if (_trekController.allTreks.isEmpty) {
        print('📥 Fetching treks from API...');
        await _trekController.fetchTreks();
        print('📊 After fetch: ${_trekController.allTreks.length} treks');
      }
      
      _prepareStateList();
      
      // If no states found from API, use fallback states
      if (stateList.isEmpty) {
        print('⚠️ No states found from API, using fallback states');
        _initializeFallbackStates();
      }
      
      print('✅ States initialization completed. Total states: ${stateList.length}');
    } catch (e) {
      print('⚠️ Error initializing states with treks: $e');
      // Use fallback states if API fails
      _initializeFallbackStates();
    } finally {
      isLoading.value = false;
    }
  }

  /// Initialize fallback states if API data is not available
  void _initializeFallbackStates() {
    stateList.value = [
      StateUIModel(name: 'Himachal Pradesh', imageUrl: ''),
      StateUIModel(name: 'Uttarakhand', imageUrl: ''),
      StateUIModel(name: 'Jammu & Kashmir', imageUrl: ''),
      StateUIModel(name: 'Sikkim', imageUrl: ''),
      StateUIModel(name: 'Arunachal Pradesh', imageUrl: ''),
      StateUIModel(name: 'Meghalaya', imageUrl: ''),
      StateUIModel(name: 'Nagaland', imageUrl: ''),
      StateUIModel(name: 'Manipur', imageUrl: ''),
      StateUIModel(name: 'Mizoram', imageUrl: ''),
      StateUIModel(name: 'Tripura', imageUrl: ''),
      StateUIModel(name: 'Assam', imageUrl: ''),
      StateUIModel(name: 'West Bengal', imageUrl: ''),
      StateUIModel(name: 'Odisha', imageUrl: ''),
      StateUIModel(name: 'Jharkhand', imageUrl: ''),
      StateUIModel(name: 'Bihar', imageUrl: ''),
      StateUIModel(name: 'Uttar Pradesh', imageUrl: ''),
      StateUIModel(name: 'Madhya Pradesh', imageUrl: ''),
      StateUIModel(name: 'Chhattisgarh', imageUrl: ''),
      StateUIModel(name: 'Rajasthan', imageUrl: ''),
      StateUIModel(name: 'Gujarat', imageUrl: ''),
      StateUIModel(name: 'Maharashtra', imageUrl: ''),
      StateUIModel(name: 'Goa', imageUrl: ''),
      StateUIModel(name: 'Karnataka', imageUrl: ''),
      StateUIModel(name: 'Kerala', imageUrl: ''),
      StateUIModel(name: 'Tamil Nadu', imageUrl: ''),
      StateUIModel(name: 'Andhra Pradesh', imageUrl: ''),
      StateUIModel(name: 'Telangana', imageUrl: ''),
    ];
    print('✅ Initialized ${stateList.length} fallback states');
  }

  /// Manually refresh states data
  Future<void> refreshStates() async {
    print('🔄 Manual refresh triggered');
    await initializeStatesWithTreks();
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

  void _prepareStateList() {
    try {
      if (_trekController.allTreks.isEmpty) {
        print('⚠️ No treks available from TrekController');
        return;
      }
      
      final treks = _trekController.allTreks;
      print('📊 Found ${treks.length} treks from TrekController');
      
      final Map<String, String> statesMap = {};
      for (Trek trek in treks) {
        final stateName = trek.state?.trim() ?? '';
        if (stateName.isNotEmpty) {
          if (!statesMap.containsKey(stateName)) {
            statesMap[stateName] = trek.imageUrl ?? '';
          }
        }
      }
      
      print('🗺️ Found ${statesMap.length} unique states from trek data');
      
      if (statesMap.isNotEmpty) {
        stateList.value = statesMap.entries
            .map((entry) => StateUIModel(name: entry.key, imageUrl: entry.value))
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));
        print('✅ Successfully prepared state list with ${stateList.length} states');
      } else {
        print('⚠️ No valid states found in trek data');
      }
    } catch (e) {
      print('⚠️ Error preparing state list: $e');
      stateList.value = [];
    }
  }

  List<Trek> getTreksForState(String stateName) {
    try {
      return _trekController.allTreks
          .where((trek) => trek.state == stateName)
          .toList();
    } catch (e) {
      print('⚠️ Error getting treks for state: $e');
      return [];
    }
  }

  double getCompletionPercentage(String stateName) {
    try {
      final treksInState = getTreksForState(stateName);
      if (treksInState.isEmpty) return 0.0;
      final exploredCount = treksInState
          .where((trek) => exploredTreks.contains(trek.trekName))
          .length;
      return (exploredCount / treksInState.length);
    } catch (e) {
      print('⚠️ Error calculating completion percentage: $e');
      return 0.0;
    }
  }
}