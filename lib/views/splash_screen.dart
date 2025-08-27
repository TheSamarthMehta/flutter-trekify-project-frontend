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

    if (mounted) setState(() => _loadingMessage = 'Loading treks...');

    final trekController = Get.find<TrekController>();
    final trekDataFuture = trekController.fetchTreks();
    final auth = Get.find<AuthController>();
    final autoLoginFuture = auth.tryAutoLogin();

    await Future.wait([minDelayFuture, trekDataFuture, autoLoginFuture]);

    if (mounted) setState(() => _loadingMessage = 'Almost ready...');

    // Add a small delay for the final message
    await Future.delayed(const Duration(milliseconds: 500));

    // Decide where to navigate based on auth state
    if (mounted) {
      if (auth.isLoggedIn.isTrue) {
        Get.offAllNamed('/');
      } else {
        Get.offAllNamed('/login');
      }
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