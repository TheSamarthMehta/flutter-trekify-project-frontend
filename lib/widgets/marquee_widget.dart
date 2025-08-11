import 'package:flutter/material.dart';

/// A widget that automatically scrolls its text content horizontally
/// if the text overflows the available width. Otherwise, it displays static text.
class MarqueeWidget extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration scrollDuration;
  final Duration pauseDuration;

  const MarqueeWidget({
    super.key,
    required this.text,
    this.style,
    this.scrollDuration = const Duration(seconds: 8),
    // ✅ EDITED: Changed pause duration to 1 second as requested.
    this.pauseDuration = const Duration(seconds: 1),
  });

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  late ScrollController _scrollController;
  bool _isOverflowing = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflowAndAnimate());
  }

  @override
  void didUpdateWidget(MarqueeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      // If text changes, restart the logic
      _scrollController.jumpTo(0.0);
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflowAndAnimate());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _checkOverflowAndAnimate() {
    if (!mounted) return;

    final textSpan = TextSpan(text: widget.text, style: widget.style);
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.infinity);

    final box = context.findRenderObject() as RenderBox;

    if (textPainter.width > box.size.width) {
      if (!_isOverflowing) {
        setState(() {
          _isOverflowing = true;
        });
      }
      // Start the animation loop only if it's overflowing
      _startMarquee();
    } else {
      if (_isOverflowing) {
        setState(() {
          _isOverflowing = false;
        });
      }
    }
  }

  // ✅ EDITED: The animation logic is now cleaner and more precise.
  void _startMarquee() async {
    // Initial delay to ensure everything is laid out before starting.
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted || !_isOverflowing) return;

    while (mounted && _isOverflowing) {
      // 1. Animate from the start to the very end.
      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: widget.scrollDuration,
          curve: Curves.linear,
        );
      }
      if (!mounted || !_isOverflowing) return;

      // 2. Immediately jump back to the start. This makes the "stop" happen at the beginning.
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }

      // 3. Pause at the start before the next cycle begins.
      await Future.delayed(widget.pauseDuration);
      if (!mounted || !_isOverflowing) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final originalStyle = widget.style ?? DefaultTextStyle.of(context).style;
    final consistentStyle = originalStyle.copyWith(height: 1.5);

    if (!_isOverflowing) {
      return Text(
        widget.text,
        style: consistentStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    // Use a simple Row with two Text widgets for a seamless loop
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      physics: const NeverScrollableScrollPhysics(), // Disable manual scrolling
      child: Row(
        children: [
          Text(widget.text, style: consistentStyle),
          const SizedBox(width: 60), // Space between the repeated text
          Text(widget.text, style: consistentStyle),
        ],
      ),
    );
  }
}
