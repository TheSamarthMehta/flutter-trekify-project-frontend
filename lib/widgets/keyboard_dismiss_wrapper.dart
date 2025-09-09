// lib/widgets/keyboard_dismiss_wrapper.dart
import 'package:flutter/material.dart';

/// A reusable widget that wraps content and dismisses the keyboard when tapped outside input fields
class KeyboardDismissWrapper extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const KeyboardDismissWrapper({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside input fields
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
