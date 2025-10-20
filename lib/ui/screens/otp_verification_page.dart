import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ryal_mobile/extension/localization_ext.dart';
import 'package:ryal_mobile/injection.dart';
import 'package:ryal_mobile/main.dart';
import 'package:ryal_mobile/route/app_router.dart';
import 'package:ryal_mobile/state/register/register_cubit.dart';
import 'package:ryal_mobile/ui/components/buttons/app_button.dart';
import 'package:ryal_mobile/ui/components/unfocuser.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';
import 'package:ryal_mobile/ui/resources/app_text_styles.dart';
import 'package:ryal_mobile/ui/widgets/appbar.dart';

@RoutePage()
class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
final bool isLogin;
final bool ? isForgotMpin;
  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.isLogin,
    this.isForgotMpin,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  int countdown = 59;
  Timer? timer;
  bool showResendButton = false;
  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();
late final RegisterCubit registerCubit;
  @override
  void initState() {
    super.initState();
    registerCubit=getIt<RegisterCubit>();
    startTimer();
    // Auto focus the text field to show keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      otpFocusNode.requestFocus();
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (countdown == 0) {
        setState(() {
          showResendButton = true;
          timer.cancel();
        });
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

void resendOTP() {
  // Clear both cubit state and local state
  registerCubit.onOtpChanged(''); // This will now reset all verification flags
  
  setState(() {
    countdown = 59;
    showResendButton = false;
    otpController.clear();
  });
  startTimer();
  otpFocusNode.requestFocus();

  if(widget.isLogin){
    registerCubit.login(phoneNumber: widget.phoneNumber);
  } else {
    registerCubit.validateAndSubmit();
  }
}
  String formatOTPDisplay(String otp) {
    // Create the display format: XXX-XXX or ------- for empty
    String formatted = '';

    if (otp.isEmpty) {
      return '- - - - - -';
    }

    for (int i = 0; i < 6; i++) {
      if (i < otp.length) {
        formatted += otp[i];
      } else {
        formatted += '-';
      }

      if (i == 2) {
        formatted += ' - ';
      } else if (i < 5) {
        formatted += ' ';
      }
    }

    return formatted;
  }

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use BlocProvider.value for existing cubit instances
    return BlocConsumer<RegisterCubit, RegisterState>(
         bloc: registerCubit,
      listener: (context, state) {
    if (widget.isForgotMpin == true && state.otpVerifySuccess && !state.isSubmitting) {
    debugPrint('🔄 Navigating to SetMpin (forgot mPIN flow)');
    appRouter.push(SetMpinRoute(isFirstSetup: false));
  } 
  else if (widget.isLogin && state.loginOtpApiVerified && !state.isSubmitting) {
    debugPrint('✅ Login OTP verified, checking user setup status...');
    debugPrint('   isKycVerified: ${state.isKycVerified}');
    debugPrint('   ismpinSet: ${state.ismpinSet}');
    debugPrint('   isBiometricSetup: ${state.isBiometricSetup}');
    
    if (!state.isKycVerified) {
      debugPrint('🔄 Navigating to KYC Verification');
      appRouter.replace(const KycVerificationRoute());
    } else if (!state.ismpinSet) {
      debugPrint('🔄 Navigating to Set mPIN');
      appRouter.replace(SetMpinRoute(isFirstSetup: true));
    } else if (!state.isBiometricSetup) {
      debugPrint('🔄 Navigating to Biometric Setup');
      appRouter.replace(BiometricVerificationRoute());
    } else {
      debugPrint('🔄 All setup complete, navigating to Dashboard');
      appRouter.replace(TempDashboardRoute());
    }
  } 
  else if (state.registerOtpApiVerified && !state.isSubmitting) {
    debugPrint('🔄 Registration OTP verified, navigating to success screen');
    appRouter.replace(const RegisterSuccessRoute());
  } 
  else if (state.errorMessage?.isNotEmpty == true && !state.isSubmitting) {
    debugPrint('❌ OTP verification failed: ${state.errorMessage}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(state.errorMessage!),
        backgroundColor: Colors.red,
      ),
    );
  }
},
      builder: (context, state) {
        return Scaffold(
            appBar: TransparentAppBar(
              showBackButton: true,
              preferredSize: const Size.fromHeight(60),
             
            ),
          body: Unfocuser(
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Text(
                          context.l10n.one_time_password,
                          style: AppTextStyles.primary.n24w600.blueText,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${context.l10n.we_sent_one_time_code_to} ${widget.phoneNumber}",
                          style: AppTextStyles.primary.n14w400.blueText,
                        ),
                      ],
                    ),
                  ),
    
                  SizedBox(height: 10),
    
                  // OTP Input with Stack to overlay invisible TextField
                  Stack(
                    children: [
                      // Visual OTP Display
                      GestureDetector(
                        onTap: () => otpFocusNode.requestFocus(),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 24),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: AppColors.otpContainerColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.otpBorder,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              formatOTPDisplay(state.otpCode),
                              style: AppTextStyles.primary.n32w500.copyWith(color: AppColors.otpTextColor),
                            ),
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
                            LengthLimitingTextInputFormatter(6),
                          ],
                          style: TextStyle(color: Colors.transparent),
                          cursorColor: Colors.transparent,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                          ),
                          onChanged: (value) {
                         
                            
               registerCubit.onOtpChanged(value);
                          },
                        ),
                      ),
                    ],
                  ),
    
                  SizedBox(height: 20),
              
                  // Timer and Resend
                  if (!showResendButton)
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.primary.n14w400.blueText,
                        children: [
                          const TextSpan(text: 'OTP expires in: '),
                          TextSpan(
                            text: '$countdown secs',
                            style: AppTextStyles.primary.n16w600.timerGreen,
                          ),
                        ],
                      ),
                    )
                  else
                    TextButton(
                      onPressed: resendOTP,
                      child: Text(
                       context.l10n.resend,
                        style: AppTextStyles.primary.n16w700.primaryBlueText
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
    
                  Spacer(),
    
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: AppButton(
                      title: "Verify",
                      isActive: state.otpCode.length == 6,
                    buttonColor: AppColors.primaryBlueButton,
                      onPressed: state.otpCode.length == 6
                          ? () {
if(widget.isForgotMpin==true){
  registerCubit.verifyOtp(phoneNumber: widget.phoneNumber)  ;
  }
                            else if(widget.isLogin){
                              registerCubit.verifyLoginrOtp(phoneNumber: widget.phoneNumber);
                            }else {
                            registerCubit.verifyRegisterOtp(phoneNumber: widget.phoneNumber);
                            }}
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}