// lib/controllers/trek_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trekify/models/trek_model.dart';
import 'package:trekify/services/trek_service.dart';
import 'dart:developer' as developer;
import 'package:collection/collection.dart';

class TrekController extends GetxController {
  final TrekService _trekService = Get.find<TrekService>();

  var isLoading = false.obs;
  var allTreks = <Trek>[].obs;
  var filteredTreks = <Trek>[].obs;
  var errorMessage = Rxn<String>();

  // Applied filters
  var selectedDifficulties = <String>{}.obs;
  var selectedSeasons = <String>{}.obs;
  var selectedTypes = <String>{}.obs;
  var selectedAgeGroups = <String>{}.obs;
  var selectedDistances = <String>{}.obs;
  var selectedStates = <String>{}.obs;

  // Temporary filters for the drawer
  var tempSelectedDifficulties = <String>{}.obs;
  var tempSelectedSeasons = <String>{}.obs;
  var tempSelectedTypes = <String>{}.obs;
  var tempSelectedAgeGroups = <String>{}.obs;
  var tempSelectedDistances = <String>{}.obs;
  var tempSelectedStates = <String>{}.obs;


  var searchQuery = ''.obs;

  List<String> get uniqueStates {
    if (allTreks.isEmpty) return [];
    final states = allTreks.map((trek) => trek.state).toSet();
    final sortedList = states.toList()..sort();
    return sortedList;
  }

  List<String> get uniqueAgeGroups {
    if (allTreks.isEmpty) return [];
    final ageGroups = allTreks
        .map((trek) => trek.ageGroup)
        .where((ageGroup) =>
    ageGroup.isNotEmpty &&
        !ageGroup.toLowerCase().contains('km') &&
        ageGroup != 'N/A')
        .toSet();
    final sortedList = ageGroups.toList()..sort();
    return sortedList;
  }

  String get activeFilterTitle {
    if (searchQuery.isNotEmpty) {
      return "Search Results";
    }
    if (selectedDifficulties.isNotEmpty || selectedSeasons.isNotEmpty || selectedTypes.isNotEmpty || selectedAgeGroups.isNotEmpty || selectedDistances.isNotEmpty) {
      return "Filtered Treks";
    }
    return "All Treks";
  }

  // ✅ EDITED: Renamed method and removed the initial check to allow pre-loading.
  Future<void> fetchTreks() async {
    isLoading(true);
    errorMessage.value = null;
    
    try {
      developer.log('Starting to fetch treks...', name: 'TrekController');
      
      final result = await _trekService.fetchTreks();
      
      if (result['success'] == true) {
        final treks = result['data'] as List<Trek>;
        allTreks.assignAll(treks);
        applyFilters();
        developer.log('Successfully loaded ${treks.length} treks', name: 'TrekController');
      } else {
        errorMessage.value = result['error'];
        developer.log('Error fetching treks: ${errorMessage.value}', name: 'TrekController');
        
        // Show user-friendly error message
        _showErrorSnackbar(result['error']);
      }
    } catch (e) {
      developer.log('Exception in fetchTreks: $e', name: 'TrekController');
      errorMessage.value = 'An unexpected error occurred. Please try again.';
      _showErrorSnackbar('An unexpected error occurred. Please try again.');
    } finally {
      isLoading(false);
    }
  }

  /// Show error message to user
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Connection Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error_outline, color: Colors.red),
    );
  }

  /// Retry fetching treks
  Future<void> retryFetchTreks() async {
    developer.log('Retrying to fetch treks...', name: 'TrekController');
    await fetchTreks();
  }

  void applyQuickFilter({String? difficulty, String? season, String? type, String? state}) {
    clearAllFilters();
    if (difficulty != null) selectedDifficulties.add(difficulty);
    if (season != null) selectedSeasons.add(season);
    if (type != null) selectedTypes.add(type);
    if (state != null) selectedStates.add(state);
    applyFilters();
  }

  void onFilterDrawerOpen() {
    tempSelectedDifficulties.assignAll(selectedDifficulties);
    tempSelectedSeasons.assignAll(selectedSeasons);
    tempSelectedTypes.assignAll(selectedTypes);
    tempSelectedAgeGroups.assignAll(selectedAgeGroups);
    tempSelectedDistances.assignAll(selectedDistances);
    tempSelectedStates.assignAll(selectedStates);
  }

  void toggleTempFilter(RxSet<String> tempFilterSet, String value) {
    if (tempFilterSet.contains(value)) {
      tempFilterSet.remove(value);
    } else {
      tempFilterSet.add(value);
    }
  }

  void applyFiltersFromTemp() {
    selectedDifficulties.assignAll(tempSelectedDifficulties);
    selectedSeasons.assignAll(tempSelectedSeasons);
    selectedTypes.assignAll(tempSelectedTypes);
    selectedAgeGroups.assignAll(tempSelectedAgeGroups);
    selectedDistances.assignAll(tempSelectedDistances);
    selectedStates.assignAll(tempSelectedStates);
    applyFilters();
    Get.back();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void applyFilters() {
    if (allTreks.isEmpty) {
      filteredTreks.assignAll([]);
      return;
    }
    List<Trek> _filtered = allTreks.where((trek) {
      final stateMatch = selectedStates.isEmpty || selectedStates.contains(trek.state);
      final difficultyMatch = selectedDifficulties.isEmpty || selectedDifficulties.any((selected) => trek.difficulty.toLowerCase().contains(selected.toLowerCase()));
      final seasonMatch = selectedSeasons.isEmpty || selectedSeasons.any((selected) =>
          trek.season.toLowerCase().contains(selected.toLowerCase()));
      final typeMatch = selectedTypes.isEmpty || selectedTypes.any((selected) =>
          trek.type.toLowerCase().contains(selected.toLowerCase()));
      final ageGroupMatch = selectedAgeGroups.isEmpty || _checkAgeGroup(trek.ageGroup, selectedAgeGroups);
      final distanceMatch = selectedDistances.isEmpty || _checkDistance(trek.totalDistance, selectedDistances);

      final searchMatch = searchQuery.isEmpty ||
          trek.trekName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          trek.state.toLowerCase().contains(searchQuery.value.toLowerCase());

      return stateMatch && difficultyMatch && seasonMatch && typeMatch && searchMatch && ageGroupMatch && distanceMatch;
    }).toList();
    filteredTreks.assignAll(_filtered);
  }

  bool _checkAgeGroup(String trekAgeGroupStr, Set<String> selectedRanges) {
    final trekAgeNumbers = RegExp(r'\d+')
        .allMatches(trekAgeGroupStr)
        .map((m) => int.tryParse(m.group(0) ?? ''))
        .where((n) => n != null)
        .cast<int>()
        .toList();

    if (trekAgeNumbers.length < 2) return false;

    final int trekMinAge = trekAgeNumbers[0];
    final int trekMaxAge = trekAgeNumbers[1];

    for (var range in selectedRanges) {
      int filterMinAge;
      int filterMaxAge;

      final filterAgeNumbers = RegExp(r'\d+')
          .allMatches(range)
          .map((m) => int.tryParse(m.group(0) ?? ''))
          .where((n) => n != null)
          .cast<int>()
          .toList();

      if (filterAgeNumbers.isEmpty) continue;

      filterMinAge = filterAgeNumbers[0];
      if (range.contains('+')) {
        filterMaxAge = 150;
      } else if (filterAgeNumbers.length > 1) {
        filterMaxAge = filterAgeNumbers[1];
      } else {
        filterMaxAge = filterMinAge;
      }

      if (trekMinAge <= filterMaxAge && trekMaxAge >= filterMinAge) {
        return true;
      }
    }

    return false;
  }

  bool _checkDistance(String trekDistanceStr, Set<String> selectedRanges) {
    final distanceNumbers = RegExp(r'\d+\.?\d*')
        .allMatches(trekDistanceStr)
        .map((m) => double.tryParse(m.group(0) ?? ''))
        .where((n) => n != null)
        .cast<double>()
        .toList();

    if (distanceNumbers.isEmpty) return false;

    final double trekMinDistance = distanceNumbers.first;
    final double trekMaxDistance = distanceNumbers.length > 1 ? distanceNumbers.last : trekMinDistance;

    for (var range in selectedRanges) {
      double filterMinDistance;
      double filterMaxDistance;

      if (range == '0-10 km') {
        filterMinDistance = 0;
        filterMaxDistance = 10;
      } else if (range == '11-20 km') {
        filterMinDistance = 11;
        filterMaxDistance = 20;
      } else if (range == '20+ km') {
        filterMinDistance = 20.1;
        filterMaxDistance = 1000;
      } else {
        continue;
      }

      if (trekMinDistance <= filterMaxDistance && trekMaxDistance >= filterMinDistance) {
        return true;
      }
    }

    return false;
  }

  void clearTempFilters() {
    tempSelectedDifficulties.clear();
    tempSelectedSeasons.clear();
    tempSelectedTypes.clear();
    tempSelectedAgeGroups.clear();
    tempSelectedDistances.clear();
    tempSelectedStates.clear();
  }

  void clearAllFilters() {
    selectedDifficulties.clear();
    selectedSeasons.clear();
    selectedTypes.clear();
    selectedAgeGroups.clear();
    selectedDistances.clear();
    selectedStates.clear();
    clearTempFilters();
    searchQuery.value = '';
    applyFilters();
  }

  void handleDrawerClose() {
    const equality = DeepCollectionEquality();
    bool filtersChanged = !equality.equals(selectedDifficulties, tempSelectedDifficulties) ||
        !equality.equals(selectedSeasons, tempSelectedSeasons) ||
        !equality.equals(selectedTypes, tempSelectedTypes) ||
        !equality.equals(selectedAgeGroups, tempSelectedAgeGroups) ||
        !equality.equals(selectedDistances, tempSelectedDistances);

    if (filtersChanged) {
      Get.snackbar(
        'Filters Not Applied',
        'Your filter changes have not been saved. Tap "Apply" to see the results.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    }
  }
}