import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ryal_mobile/ui/resources/app_assets.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';

class LangIconWidget extends StatelessWidget {
  const LangIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
       padding: const EdgeInsets.all(8), // space inside the container
      decoration: BoxDecoration(
        color: AppColors.greyIconContainerBg, // grey background
        borderRadius: BorderRadius.circular(12),
         border: Border.all( // 👈 add this
        color: AppColors.greyIconContainerBorder, // or any color you like
        width: 1,           // thickness = 1px
      ),
         // rounded rectangle
      ),
      child: SvgPicture.asset(
        AppAssets.icLanguage,
        colorFilter: const ColorFilter.mode(AppColors.primaryBlueButton, BlendMode.srcIn), // optional for coloring
        width: 24,
        height: 24,
      ),
    );
  }
}