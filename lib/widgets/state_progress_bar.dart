// lib/widgets/state_progress_bar.dart
import 'dart:math';
import 'package:flutter/material.dart';

class StateProgressBar extends StatefulWidget {
  final double percentage;
  final Widget child;

  const StateProgressBar({
    super.key,
    required this.percentage,
    required this.child,
  });

  @override
  State<StateProgressBar> createState() => _StateProgressBarState();
}

class _StateProgressBarState extends State<StateProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Slower, more fluid animation
    )..repeat(); // The animation loops continuously
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          // The painter creates the wave effect
          painter: LiquidProgressPainter(
            animationValue: _animationController.value,
            percentage: widget.percentage,
            color: Colors.teal,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class LiquidProgressPainter extends CustomPainter {
  final double animationValue; // This will go from 0.0 to 1.0 continuously
  final double percentage;
  final Color color;

  LiquidProgressPainter({
    required this.animationValue,
    required this.percentage,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // The height of the fill is based on the completion percentage
    final fillHeight = size.height * percentage;

    // Draw the main fill color
    final wavePaint = Paint()..color = color.withOpacity(0.4);
    final path = Path();

    // Move to the bottom left to start drawing
    path.moveTo(0, size.height);

    // Draw a line up to the starting point of the wave
    path.lineTo(0, size.height - fillHeight);

    // Create a sine wave across the width of the card
    for (double i = 0; i <= size.width; i++) {
      final y = (size.height - fillHeight) +
          // The wave's height
          (sin((i / size.width * 2 * pi) + (animationValue * 2 * pi)) * 5);
      path.lineTo(i, y);
    }

    // Complete the path to fill the area
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, wavePaint);

    // ✅ Optional: Draw a second, slightly offset wave for a nicer effect
    final wavePaint2 = Paint()..color = color.withOpacity(0.2);
    final path2 = Path();
    path2.moveTo(0, size.height);
    path2.lineTo(0, size.height - fillHeight);
    for (double i = 0; i <= size.width; i++) {
      final y = (size.height - fillHeight) +
          (sin((i / size.width * 2 * pi) + (animationValue * 2 * pi) + pi / 2) * 8);
      path2.lineTo(i, y);
    }
    path2.lineTo(size.width, size.height);
    path2.close();
    canvas.drawPath(path2, wavePaint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for the animation
  }
}