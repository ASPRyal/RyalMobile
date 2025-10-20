import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColoredSafeArea extends StatelessWidget {
  const ColoredSafeArea._({
    this.gradient,
    this.color,
    required this.child,
    required this.systemUiOverlayStyle,
    required this.top,
    required this.bottom,
    super.key,
  });

  const ColoredSafeArea.darkOverlay({
    required Color color,
    required Widget child,
    bool top = true,
    bool bottom = true,
    Key? key,
  }) : this._(
          color: color,
          child: child,
          systemUiOverlayStyle: SystemUiOverlayStyle.dark,
          top: top,
          bottom: bottom,
          key: key,
        );

  const ColoredSafeArea.gradientOverlay({
    required List<Color> gradient,
    required Widget child,
    bool top = true,
    bool bottom = true,
    Key? key,
  }) : this._(
          gradient: gradient,
          child: child,
          systemUiOverlayStyle: SystemUiOverlayStyle.dark,
          top: top,
          bottom: bottom,
          key: key,
        );

  const ColoredSafeArea.lightOverlay({
    required Color color,
    required Widget child,
    bool top = true,
    bool bottom = true,
    Key? key,
  }) : this._(
          color: color,
          child: child,
          systemUiOverlayStyle: SystemUiOverlayStyle.light,
          top: top,
          bottom: bottom,
          key: key,
        );

  final Color? color;
  final List<Color>? gradient;
  final bool top;
  final bool bottom;
  final Widget child;
  final SystemUiOverlayStyle systemUiOverlayStyle;

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemUiOverlayStyle,
        child: gradient != null
            ? DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient!,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                   
                  ),
                ),
                child: SafeArea(
                  top: top,
                  bottom: bottom,
                  child: child,
                ),
              )
            : ColoredBox(
                color: color!,
                child: SafeArea(
                  top: top,
                  bottom: bottom,
                  child: child,
                ),
              ),
      );
}
