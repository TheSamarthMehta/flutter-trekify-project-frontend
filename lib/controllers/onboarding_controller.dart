// lib/controllers/onboarding_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trekify/models/onboarding_info.dart';

class OnboardingController extends GetxController {
  final _box = GetStorage();
  final pageController = PageController();
  final currentPage = 0.obs;

  var onboardingPages = <OnboardingInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      if (pageController.page?.round() != currentPage.value) {
        currentPage.value = pageController.page!.round();
      }
    });
  }

  /// This method is called when the user taps "Get Started" or "Skip".
  void completeOnboarding() {
    // 1. Set the flag so the user never sees onboarding on this device again.
    _box.write('hasSeenOnboarding', true);

    // 2. Navigate to the login screen. This is the next logical step for a new user.
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

