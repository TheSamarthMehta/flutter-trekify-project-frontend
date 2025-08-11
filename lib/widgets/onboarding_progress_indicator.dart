// lib/widgets/onboarding_progress_indicator.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trekify/controllers/onboarding_controller.dart';

class OnboardingProgressIndicator extends StatelessWidget {
  const OnboardingProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the controller which holds the PageController instance.
    final OnboardingController controller = Get.find<OnboardingController>();

    // The SmoothPageIndicator widget handles all the animation logic.
    // It listens to the PageController to know when to animate.
    return SmoothPageIndicator(
      controller: controller.pageController,
      // The number of dots.
      count: controller.onboardingPages.length,
      // The effect to use for the animation.
      effect: WormEffect(
        dotHeight: 10,
        dotWidth: 10,
        activeDotColor: Colors.teal,
        dotColor: Colors.white54,
        paintStyle: PaintingStyle.fill,
      ),
    );
  }
}
