import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ryal_mobile/injection.dart';
import 'package:ryal_mobile/main.dart';
import 'package:ryal_mobile/route/app_router.dart';
import 'package:ryal_mobile/state/register/register_cubit.dart';
import 'package:ryal_mobile/ui/components/unfocuser.dart';
import 'package:ryal_mobile/ui/resources/app_assets.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';
import 'package:ryal_mobile/ui/resources/app_text_styles.dart';
import 'package:ryal_mobile/ui/widgets/kyc_icon_widget.dart';

@RoutePage()
class SetMpinScreen extends StatefulWidget {
  final bool isFirstSetup;
  const SetMpinScreen({super.key, required this.isFirstSetup});

  @override
  State<SetMpinScreen> createState() => _SetMpinScreenState();
}

class _SetMpinScreenState extends State<SetMpinScreen>
    with TickerProviderStateMixin {
  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();
  late final RegisterCubit registerCubit;
  bool isConfirmStep = false;
  String firstPin = '';
  
  @override
  void initState() {
    super.initState();
    registerCubit = getIt<RegisterCubit>();
    // Auto focus the text field to show keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      otpFocusNode.requestFocus();
    });

  }

  Widget _buildPinDots(String pin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        bool isFilled = index < pin.length;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          width: 16,
          height: 16,
          alignment: Alignment.center,
          child: isFilled
              ? Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.searchBarBorder,
                  ),
                )
              : Text(
                  '−',
                  style: TextStyle(
                    fontSize: 24,
                    height: 1.0,
                    color: AppColors.searchBarBorder,
                    fontWeight: FontWeight.w300,
                  ),
                ),
        );
      }),
    );
  }

  @override
  void dispose() {
    otpController.dispose();
    otpFocusNode.dispose();
    super.dispose();
  }
    Widget _buildKycIconWithProgress({
    required String iconPath,
    required bool isCompleted,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: isCompleted
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green,
                    width: 2,
                  ),
                )
              : null,
          child: KycIconWidget(iconPath: iconPath),
        ),
        if (isCompleted)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      bloc: registerCubit,
      listener: (context, state) {
        if (state.mpinSuccess && !state.isSubmitting && widget.isFirstSetup) {
          debugPrint('mpin set successfully');
          appRouter.push(BiometricVerificationRoute()  );
        } 
        
      else  if (state.mpinSuccess && !state.isSubmitting && !widget.isFirstSetup) {
          debugPrint('mpin set successfully');
          appRouter.push(MpinBioLoginRoute()  );
        } 
        else if (state.errorMessage?.isNotEmpty == true &&
            !state.isSubmitting) {
          debugPrint('OTP verification failed: ${state.errorMessage}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return BlocProvider<RegisterCubit>(
          create: (context) => registerCubit,
          child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
         
        },
        builder: (context, state) {
        
              return PopScope(
                canPop: false,
                child: Scaffold(
                  
                  backgroundColor: Colors.white,
                  body: Unfocuser(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,

                              children: [
                                 _buildKycIconWithProgress(
                            iconPath: AppAssets.icKyc1,
                            isCompleted: true,
                          ),

                               _buildKycIconWithProgress(
                            iconPath: AppAssets.icKyc2,
                            isCompleted: true,
                          ),

                               _buildKycIconWithProgress(
                            iconPath: AppAssets.icKyc3,
                            isCompleted: false,
                          ),
                              //  // KycIconWidget(iconPath: AppAssets.icKyc1),
                              //   KycIconWidget(iconPath: AppAssets.icKyc2),
                              //   SizedBox(width: 12),
                              //   KycIconWidget(iconPath: AppAssets.icKyc3),
                              ],
                            ),
                            SizedBox(height: 32),
                            Text(
                              isConfirmStep
                                  ? "Confirm your mPIN"
                                  : (widget.isFirstSetup
                                        ? "Set your mPIN"
                                        : "Reset your mPIN"),
                              style: AppTextStyles.primary.n24w700.blueText,
                            ),
                            SizedBox(height: 8),
                            Text(
                              isConfirmStep
                                  ? "Please confirm your 4 digits mPIN"
                                  : "Please create a 4 digits mPIN",
                              style: AppTextStyles.primary.n14w400.blueText,
                            ),
                            SizedBox(height: 48),

                            // PIN Display with Dots
                            Stack(
                              children: [
                                // Visual PIN Display
                                GestureDetector(
                                  onTap: () => otpFocusNode.requestFocus(),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 32),
                                    decoration: BoxDecoration(
                                      color: AppColors.otpContainerColor,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColors.otpBorder,
                                      ),
                                    ),
                                    child: Center(
                                      child: _buildPinDots(state.otpCode),
                                    ),
                                  ),
                                ),

                                // Invisible TextField for keyboard input
                                Positioned.fill(
                                  child: TextField(
                                    controller: otpController,
                                    focusNode: otpFocusNode,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    style: TextStyle(color: Colors.transparent),
                                    cursorColor: Colors.transparent,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      counterText: '',
                                    ),
                                    onChanged: (value) {
                                      debugPrint(
                                        'PIN value changed: "$value" (length: ${value.length})',
                                      );
                                      registerCubit.onOtpChanged(value);

                                      // Auto-proceed when 4 digits are entered
                                      if (value.length == 4) {
                                        if (!isConfirmStep) {
                                          // First PIN entered, move to confirmation
                                          Future.delayed(
                                            Duration(milliseconds: 300),
                                            () {
                                              setState(() {
                                                firstPin = value;
                                                isConfirmStep = true;
                                                otpController.clear();
                                                registerCubit.onOtpChanged('');
                                              });
                                              otpFocusNode.requestFocus();
                                            },
                                          );
                                        } else {
                                          // Confirmation PIN entered
                                          Future.delayed(
                                            Duration(milliseconds: 500),
                                            () {
                                              if (firstPin == value) {
                                                // PINs match, proceed
                                                debugPrint('PINs match: $value');
                                                registerCubit.setMpin(mpin: value);
                                                
                                                // Call your verification method here
                                              } else {
                                                // PINs don't match
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'PINs do not match. Please try again.',
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                                setState(() {
                                                  isConfirmStep = false;
                                                  firstPin = '';
                                                  otpController.clear();
                                                  registerCubit.onOtpChanged(
                                                    '',
                                                  );
                                                });
                                                otpFocusNode.requestFocus();
                                              }
                                            },
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),

                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
