import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';

class BorderedButton extends StatelessWidget {
  BorderedButton({
    required this.text,
    required this.buttonColor,
    required this.textStyle,
    required this.onTap,
    this.buttonHeight,
    this.borderColor,
    this.buttonWidth,
    this.padding,
    this.isWhiteButton,
    EdgeInsetsGeometry? margin = const EdgeInsets.symmetric(horizontal: 16),
    super.key,
  }) : margin = margin!;

  final String text;
  final TextStyle textStyle;
  final Color buttonColor;
  final VoidCallback onTap;
  final EdgeInsetsGeometry margin;
  final double? buttonHeight;
  final double? buttonWidth;
  final EdgeInsetsGeometry? padding;
  final bool? isWhiteButton;

  final Color? borderColor;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          
          height: buttonHeight ?? 55.h,
          width: buttonWidth ?? double.maxFinite,
          margin: padding ?? margin,
          decoration: BoxDecoration(
            boxShadow: isWhiteButton == true
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
            color: buttonColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: borderColor ?? AppColors.disablePurple),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      );
}
