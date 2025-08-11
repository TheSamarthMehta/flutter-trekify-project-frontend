// lib/widgets/animated_progress_bar.dart
import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatefulWidget {
  final double percentage;
  final Widget child;

  const AnimatedProgressBar({
    super.key,
    required this.percentage,
    required this.child,
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layer 1: The child with dark text (always visible as the base)
        widget.child,

        // Layer 2: The clipped area for the fill effect
        ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: widget.percentage,
            child: Stack(
              children: [
                // The base color of the progress bar
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal, Colors.teal.shade300],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),

                // ✅ CORRECTED: The shimmer effect, layered on top of the base color
                AnimatedBuilder(
                  animation: _shimmerAnimation,
                  builder: (context, _) {
                    return ShaderMask(
                      blendMode: BlendMode.srcATop,
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: const [
                            Colors.transparent,
                            Colors.white54,
                            Colors.transparent,
                          ],
                          stops: const [0.4, 0.5, 0.6],
                          transform: _SlideGradientTransform(percent: _shimmerAnimation.value),
                        ).createShader(bounds);
                      },
                      // The child of the ShaderMask is what the shimmer is applied onto.
                      child: Container(color: Colors.white),
                    );
                  },
                ),

                // Layer 3: The child with white text, visible only in the filled area
                Theme(
                  data: Theme.of(context).copyWith(
                    textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: Colors.white,
                      displayColor: Colors.white,
                    ),
                    iconTheme: const IconThemeData(color: Colors.white),
                  ),
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Helper class to move the gradient for the shimmer effect
class _SlideGradientTransform extends GradientTransform {
  final double percent;
  const _SlideGradientTransform({required this.percent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * percent, 0.0, 0.0);
  }
}