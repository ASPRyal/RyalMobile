import 'package:flutter/material.dart';

class Unfocuser extends StatelessWidget {
  const Unfocuser({
    super.key,
    required this.child,
    this.onTap,
  });

  final Widget child;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // Changed from opaque
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
        if (onTap != null) {
          // ignore: prefer_null_aware_method_calls
          onTap!();
        }
      },
      child: child,
    );
  }
}
