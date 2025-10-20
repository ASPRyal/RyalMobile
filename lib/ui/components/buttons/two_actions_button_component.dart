import 'package:flutter/material.dart';
import 'package:ryal_mobile/ui/components/buttons/bordered_button.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';
import 'package:ryal_mobile/ui/resources/app_text_styles.dart';

class TwoActionRowButtonsComponent extends StatelessWidget {
  const TwoActionRowButtonsComponent({
    required this.leftButtonTap,
    required this.rightButtonTap,
    required this.leftButtonTitle,
    required this.rightButtonTitle,
    this.leftButtonColor,
    this.rightButtonColor,
    this.leftButtonTextStyle,
    this.rightButtonTextStyle,
    this.borderColor,
    this.isWhiteButton,
    this.isLeftButtonActive,
    super.key,
  });

  final String leftButtonTitle;
  final String rightButtonTitle;
  final bool? isLeftButtonActive;

  final VoidCallback leftButtonTap;
  final VoidCallback rightButtonTap;
  final Color? leftButtonColor;
  final Color? rightButtonColor;
  final TextStyle? leftButtonTextStyle;
  final TextStyle? rightButtonTextStyle;
  final Color? borderColor;
  final bool? isWhiteButton;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            flex: 164,
            child: BorderedButton(
              margin: EdgeInsets.zero,
              text: leftButtonTitle,
              buttonColor: leftButtonColor ?? AppColors.white,
              textStyle:
                  leftButtonTextStyle ?? AppTextStyles.primary.n16w700.black,
              onTap: leftButtonTap,
              borderColor: borderColor ?? AppColors.whiteButtonBorder,
              isWhiteButton: isWhiteButton ?? false,

            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 164,
            child: BorderedButton(
              
              margin: EdgeInsets.zero,
              text: rightButtonTitle,
              buttonColor: rightButtonColor ?? AppColors.primaryBlueButton,
              textStyle:
                  rightButtonTextStyle ?? AppTextStyles.primary.n16w700.white,
              onTap: rightButtonTap,
              borderColor: AppColors.blueButtonBorder,
            ),
          ),
        ],
      );
}
