import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';
import 'package:ryal_mobile/ui/resources/app_dimens.dart';
import 'package:ryal_mobile/ui/resources/app_text_styles.dart';

class AppButton extends StatefulWidget {
  final bool? isActive;
  final VoidCallback? onPressed;
  final String title;
  final Color? buttonColor;
  final Color? customInactiveButtonColor;
  final TextStyle? textStyle;
  final double? width;
  final bool? isCircled;
  final String? svgIcon;
  final Color? borderColor;
  final bool? isRect;

  const AppButton({
    super.key,
    this.isActive = true,
    this.onPressed,
    required this.title,
    this.buttonColor,
    this.customInactiveButtonColor,
    this.textStyle,
    this.width,
    this.isCircled = false,
    this.svgIcon,
    this.isRect = true,
    this.borderColor,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final inactiveColor = widget.customInactiveButtonColor != null
        ? widget.customInactiveButtonColor!
        : AppColors.disabledButton;
    
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: AppColors.transparent,
        //rectangular border
        shape: widget.isCircled != null && widget.isCircled!
            ? CircleBorder(
                side: BorderSide(
                  color: widget.borderColor ?? Colors.transparent,
                ),
              )
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: _getBorderColor(inactiveColor),
                ),
              ),
        backgroundColor: widget.isActive! ? widget.buttonColor : inactiveColor,
        minimumSize: Size(
          widget.width ?? double.infinity,
          AppDimens.buttonHeight,
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.svgIcon != null)
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: SvgPicture.asset(widget.svgIcon!),
            ),
          Text(
            widget.title,
            style: widget.textStyle ??
                AppTextStyles.primary.n16w700.white,
          ),
        ],
      ),
    );
  }

  Color _getBorderColor(Color inactiveColor) {
    // If a custom border color is specified, use it
    if (widget.borderColor != null) {
      return widget.borderColor!;
    }
    
    // If button is active, use the button color as border
    if (widget.isActive == true) {
      return widget.buttonColor ?? Colors.transparent;
    }
    
    // If button is disabled, make border transparent
    return Colors.transparent;
  }
}