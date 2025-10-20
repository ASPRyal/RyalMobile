import 'package:flutter/material.dart';
import 'package:ryal_mobile/ui/components/icons/svg_icon_component.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';

class KycIconWidget extends StatelessWidget {
   final String iconPath;
  const KycIconWidget({
    super.key,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12), // Adjust padding as needed
      decoration: BoxDecoration(
        color: AppColors.otpBorder, // Light blue color
        shape: BoxShape.circle,
      ),
      child: SvgIconComponent(iconPath: iconPath, size: 24),
    );
  }
}