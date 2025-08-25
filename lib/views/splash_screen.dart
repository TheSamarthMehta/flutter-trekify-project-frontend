import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trekify/controllers/auth_controller.dart';
import 'package:trekify/controllers/trek_controller.dart';

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

  Future<void> _initializeApp() async {
    final minDelayFuture = Future.delayed(const Duration(seconds: 2));

    if (mounted) setState(() => _loadingMessage = 'Warming up...');

    final trekController = Get.find<TrekController>();
    final trekDataFuture = trekController.fetchTreks();

    await Future.wait([minDelayFuture, trekDataFuture]);

    if (mounted) setState(() => _loadingMessage = 'Finalizing...');

    // Directly proceed to the login/auto-login flow
    final authController = Get.find<AuthController>();
    authController.tryAutoLogin();
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