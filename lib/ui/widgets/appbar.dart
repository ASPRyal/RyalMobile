import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';
import 'package:ryal_mobile/ui/resources/app_text_styles.dart';

class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TransparentAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.backButtonColor = AppColors.black,
    this.titleColor = AppColors.black,
    this.onTapBack,
    this.action,
    required this.preferredSize,
  });

  final String? title;
  final bool? showBackButton;
  final Color? backButtonColor;
  final Color? titleColor;
  final Function()? onTapBack;
  final Widget? action;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    return AppBar(
      // Swap padding based on direction
      leadingWidth: showBackButton == true ? 56.w : null,
      actionsPadding: EdgeInsets.only(
        left: isRTL ? 18.w : 0,
        right: isRTL ? 0 : 18.w,
      ),
      backgroundColor: AppColors.transparent,
      automaticallyImplyLeading: showBackButton ?? false,
      title: title != null
          ? Text(
              title!,
              style: AppTextStyles.primary.n16w700.copyWith(color: titleColor),
            )
          : null,
      leading: showBackButton == true
          ? Padding(
              padding: EdgeInsets.only(
                left: isRTL ? 0 : 20.w,
                right: isRTL ? 20.w : 0,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: backButtonColor),
                onPressed: onTapBack ?? () => Navigator.pop(context),
              ),
            )
          : null,
      actions: action != null ? [action!] : null,
    );
  }
}