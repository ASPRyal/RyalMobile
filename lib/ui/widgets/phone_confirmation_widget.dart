import 'package:flutter/material.dart';
import 'package:ryal_mobile/extension/localization_ext.dart';
import 'package:ryal_mobile/main.dart';
import 'package:ryal_mobile/ui/components/buttons/two_actions_button_component.dart';
import 'package:ryal_mobile/ui/resources/app_text_styles.dart';

class PhoneConfirmationDialog extends StatelessWidget {
  final String phoneNumber;
  final VoidCallback onConfirm;

  const PhoneConfirmationDialog({super.key, required this.phoneNumber, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              phoneNumber,
              style: AppTextStyles.primary.n24w700
            ),
            SizedBox(height: 16),
            Text(
              'Is this the correct number? We\'ll send you a one-time passcode (OTP).',
              textAlign: TextAlign.center,
              style: AppTextStyles.primary.n16w400.blueText1,
            ),
            SizedBox(height: 24),
             TwoActionRowButtonsComponent(
                  leftButtonTap: () {
                   appRouter.pop();
                  },
                  rightButtonTap: () {
onConfirm();
                  },
                  isWhiteButton: true,
                  leftButtonTitle: context.l10n.go_back,
                  rightButtonTitle: context.l10n.confirm,
                )
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextButton(
            //         onPressed: () => Navigator.of(context).pop(),
            //         child: Text(
            //           'Go back',
            //           style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 16),
            //     Expanded(
            //       child: ElevatedButton(
            //         onPressed: onConfirm,
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Color(0xFF2B3A8A),
            //           padding: EdgeInsets.symmetric(vertical: 16),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(25),
            //           ),
            //         ),
            //         child: Text(
            //           'Confirm',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 16,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}