// lib/views/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trekify/controllers/auth_controller.dart';
import 'package:trekify/controllers/onboarding_controller.dart';
import 'package:trekify/controllers/trek_controller.dart';
import 'package:trekify/models/onboarding_info.dart';
import 'package:trekify/services/onboarding_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _loadingMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// This function pre-loads all app data and then decides the next screen.
  Future<void> _initializeApp() async {
    // A minimum delay to ensure the splash screen is visible for good UX.
    final minDelayFuture = Future.delayed(const Duration(seconds: 2));

    if (mounted) setState(() => _loadingMessage = 'Warming up...');

    // --- Get instances of controllers and services ---
    final trekController = Get.find<TrekController>();
    final onboardingService = Get.find<OnboardingService>();
    final onboardingController = Get.put(OnboardingController());

    // --- Fetch essential data in parallel ---
    final onboardingDataFuture = onboardingService.fetchOnboardingData();
    final trekDataFuture = trekController.fetchTreks();

    final results = await Future.wait([onboardingDataFuture, trekDataFuture]);
    final onboardingData = results[0] as List<OnboardingInfo>? ?? [];

    if (onboardingData.isNotEmpty) {
      onboardingController.onboardingPages.assignAll(onboardingData);
    }

    if (mounted) setState(() => _loadingMessage = 'Pre-loading assets...');

    // --- Pre-cache all critical images ---
    List<Future<void>> imagePrecacheFutures = [];
    // (Pre-caching logic for onboarding and home screen images remains the same)
    // ...

    await Future.wait([minDelayFuture, ...imagePrecacheFutures]);

    if (mounted) setState(() => _loadingMessage = 'Finalizing...');

    // --- NEW NAVIGATION LOGIC ---
    final box = GetStorage();
    // 1. Check a simple, device-specific flag first.
    final hasSeenOnboarding = box.read<bool>('hasSeenOnboarding') ?? false;

    if (hasSeenOnboarding) {
      // 2. If they've seen it, they are an "existing user".
      //    Let the AuthController handle if they are logged in or not.
      final authController = Get.find<AuthController>();
      authController.tryAutoLogin();
    } else {
      // 3. If they've never seen it, they are a "new user".
      //    Send them to onboarding.
      Get.offAllNamed('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Trekify',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              _loadingMessage,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
