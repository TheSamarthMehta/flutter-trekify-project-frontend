// lib/views/onboarding_screen.dart
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trekify/controllers/onboarding_controller.dart';
import 'package:trekify/models/onboarding_info.dart';
import 'package:trekify/widgets/onboarding_progress_indicator.dart';
import 'package:trekify/widgets/video_player_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.find<OnboardingController>();

    return Scaffold(
      body: Obx(() {
        if (controller.onboardingPages.isEmpty) {
          return const Center(
            child: Text(
              "Could not load onboarding content.\nPlease restart the app.",
              textAlign: TextAlign.center,
            ),
          );
        }

        return PageView.builder(
          controller: controller.pageController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.onboardingPages.length,
          itemBuilder: (context, index) {
            final page = controller.onboardingPages[index];
            return _buildPage(
              context,
              controller,
              page,
              index,
              controller.onboardingPages.length,
            );
          },
        );
      }),
    );
  }

  Widget _buildPage(
      BuildContext context,
      OnboardingController controller,
      OnboardingInfo page,
      int index,
      int pageCount,
      ) {
    final Widget background = page.isVideo
        ? VideoPlayerWidget(videoPath: page.path, isNetwork: true)
        : Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(page.path),
          fit: BoxFit.cover,
        ),
      ),
    );

    return Stack(
      children: [
        background,
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Container(
            color: Colors.black.withOpacity(0.4),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 40.0),
                child: Column(
                  children: [
                    const Spacer(),
                    _AnimatedContent(
                      child: Column(
                        children: [
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(blurRadius: 10, color: Colors.black54)
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            page.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    // ✅ EDITED: The widget is now called without any parameters.
                    const OnboardingProgressIndicator(),
                    const SizedBox(height: 20),
                    _buildBottomControls(controller, index, pageCount),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls(
      OnboardingController controller, int index, int pageCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: controller.completeOnboarding,
          child: const Text('SKIP', style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: () {
            if (index < pageCount - 1) {
              controller.pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            } else {
              controller.completeOnboarding();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(index < pageCount - 1 ? 'NEXT' : 'GET STARTED'),
        ),
      ],
    );
  }
}

/// A helper widget to animate the text content when a new page appears.
class _AnimatedContent extends StatefulWidget {
  final Widget child;
  const _AnimatedContent({required this.child});

  @override
  State<_AnimatedContent> createState() => _AnimatedContentState();
}

class _AnimatedContentState extends State<_AnimatedContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
