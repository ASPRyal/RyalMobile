import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ryal_mobile/extension/localization_ext.dart';
import 'package:ryal_mobile/injection.dart';
import 'package:ryal_mobile/main.dart';
import 'package:ryal_mobile/route/app_router.dart';
import 'package:ryal_mobile/state/register/register_cubit.dart';
import 'package:ryal_mobile/services/providers/i_local_storage_provider.dart';
import 'package:ryal_mobile/ui/components/buttons/app_button.dart';
import 'package:ryal_mobile/ui/components/unfocuser.dart';
import 'package:ryal_mobile/ui/resources/app_assets.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';
import 'package:ryal_mobile/ui/resources/app_text_styles.dart';
import 'package:ryal_mobile/ui/utils/name_formatter.dart';
import 'package:ryal_mobile/ui/widgets/appbar.dart';
import 'package:ryal_mobile/ui/widgets/language_selection.dart';
import 'package:ryal_mobile/ui/widgets/phone_confirmation_widget.dart';

@RoutePage()
class MpinBioLoginScreen extends StatefulWidget {
  const MpinBioLoginScreen({
    super.key,
  });

  @override
  State<MpinBioLoginScreen> createState() => _MpinBioLoginScreenState();
}

class _MpinBioLoginScreenState extends State<MpinBioLoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final TextEditingController mpinController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();
  final ILocalStorageProvider _storageProvider = getIt<ILocalStorageProvider>();
  late final RegisterCubit registerCubit;
  
  // Changed from late final to regular variables with defaults
  String name = 'User';
  String phoneNumber = '';
  bool isBiometricStored = false;
  
  String currentMpin = '';
  bool _shouldShowBiometric = false;
  bool _isCheckingBiometric = true;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    registerCubit = getIt<RegisterCubit>();
    
    // Load user data from storage first
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      debugPrint("📖 Loading user data from storage...");
      
      final profile = await _storageProvider.getUserProfile();
      
      if (profile != null) {
        setState(() {
          name = profile['name'] ?? 'User';
          phoneNumber = profile['phone_number'] ?? '';
          isBiometricStored = profile['is_biometric_verified'] ?? false;
          _isLoadingData = false;
        });
        
        debugPrint("✅ User data loaded:");
        debugPrint("   Name: $name");
        debugPrint("   Phone: $phoneNumber");
        debugPrint("   Biometric: $isBiometricStored");
        
        // Now verify biometric status
        await _verifyBiometricStatus();
      } else {
        debugPrint("⚠️ No profile found in storage - user needs to login");
        setState(() {
          name = 'User';
          phoneNumber = '';
          isBiometricStored = false;
          _isCheckingBiometric = false;
          _isLoadingData = false;
        });
        
        // Navigate to login if no profile
        if (mounted) {
          appRouter.replaceAll([const AuthSelectionRoute()]);
        }
      }
    } catch (e) {
      debugPrint("❌ Error loading user data: $e");
      setState(() {
        name = 'User';
        phoneNumber = '';
        isBiometricStored = false;
        _isCheckingBiometric = false;
        _isLoadingData = false;
      });
      
      // Navigate to login on error
      if (mounted) {
        appRouter.replaceAll([const AuthSelectionRoute()]);
      }
    }
  }

  void _showPhoneConfirmationDialog(String phoneNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PhoneConfirmationDialog(
          phoneNumber: phoneNumber,
          onConfirm: () {
            registerCubit.sendOtp(phoneNumber: phoneNumber);
            appRouter.pop();
          },
        );
      },
    );
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      debugPrint("🔐 Starting biometric authentication...");
      
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();
      
      debugPrint("✓ canCheckBiometrics: $canCheckBiometrics");
      debugPrint("✓ isDeviceSupported: $isDeviceSupported");

      if (!canCheckBiometrics || !isDeviceSupported) {
        debugPrint("❌ Biometrics not available on this device");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometrics not available. Please use mPIN to login.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
      debugPrint("✓ Available biometrics: $availableBiometrics");
      
      if (availableBiometrics.isEmpty) {
        debugPrint("❌ No biometrics enrolled on this device");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enroll Face ID or Touch ID in your device settings first.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      debugPrint("🔓 Attempting biometric authentication...");
      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Use your biometrics to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      debugPrint("Authentication result: $didAuthenticate");

      if (didAuthenticate && mounted) {
        debugPrint("✅ Biometric authentication successful!");
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Text('Logging in...'),
              ],
            ),
            duration: Duration(seconds: 2),
          ),
        );
        
        debugPrint("🔄 Attempting to login using refresh token...");
        
        try {
          await registerCubit.loginUsingRefreshToken();
          debugPrint("✅ Login successful via refresh token");
            appRouter.replaceAll([const TempDashboardRoute()]);
        } catch (e) {
          debugPrint("❌ Login failed: $e");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login failed. Please use mPIN.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        debugPrint("❌ Biometric authentication failed or cancelled");
      }
    } on PlatformException catch (e) {
      debugPrint("❌ Biometric auth PlatformException:");
      debugPrint("   Code: ${e.code}");
      debugPrint("   Message: ${e.message}");
      
      if (mounted) {
        String message = 'Biometric authentication failed. Please use mPIN.';
        
        if (e.code == 'NotEnrolled') {
          message = 'Please enroll Face ID or Touch ID in your device settings first.';
        } else if (e.code == 'LockedOut') {
          message = 'Too many failed attempts. Please try again later or use mPIN.';
        }
        
        if (e.code != 'UserCancel' && e.code != 'AuthenticationCanceled') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("❌ Unexpected error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please use mPIN.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleMpinLogin({required String currentMpin}) {
    if (currentMpin.length == 4) {
      registerCubit.mpinLogin(mpin: currentMpin);
      debugPrint('Logging in with mPIN: $currentMpin');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a 4-digit mPIN'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleForgotMpin() {
    _showPhoneConfirmationDialog(phoneNumber);
  }

  Future<void> _verifyBiometricStatus() async {
    try {
      debugPrint("🔍 Checking biometric status...");
      debugPrint("📱 Local storage says biometric stored: $isBiometricStored");
      
      final profile = await _storageProvider.getUserProfile();
      
      if (profile != null) {
        final backendBiometricStatus =profile['is_biometric_verified'] == true;
        
        debugPrint("🔍 Backend says biometric verified: $backendBiometricStatus");
        
        setState(() {
          _shouldShowBiometric =isBiometricStored && backendBiometricStatus;
          _isCheckingBiometric = false;
        });
        
        if (isBiometricStored && !backendBiometricStatus) {
          debugPrint("⚠️ WARNING: Local storage has biometric=true but backend has biometric=false");
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Biometric setup incomplete. Please use mPIN or re-enroll biometrics.'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
        
        if (_shouldShowBiometric) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              _authenticateWithBiometrics();
            }
          });
        }
      } else {
        debugPrint("⚠️ No profile found in storage");
        setState(() {
          _shouldShowBiometric = false;
          _isCheckingBiometric = false;
        });
      }
    } catch (e) {
      debugPrint("❌ Error verifying biometric status: $e");
      setState(() {
        _shouldShowBiometric = isBiometricStored;
        _isCheckingBiometric = false;
      });
    }
  }

  Widget _buildPinDots(String pin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        bool isFilled = index < pin.length;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
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
                    color: AppColors.searchBarBorder.withOpacity(0.3),
                    fontWeight: FontWeight.w300,
                  ),
                ),
        );
      }),
    );
  }

  @override
  void dispose() {
    mpinController.dispose();
    otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while loading user data
    if (_isLoadingData) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return BlocProvider<RegisterCubit>(
      create: (context) => registerCubit,
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.isSubmitting == false && state.otpSendSuccess == true) {
            appRouter.push(
              OTPVerificationRoute(
                phoneNumber: phoneNumber,
                isLogin: false,
                isForgotMpin: true,
              ),
            );
          }
          
          if (state.mpinSuccess && !state.isSubmitting) {
            debugPrint('✅ Login successful - navigating to dashboard');
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login successful!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
            
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                appRouter.replaceAll([const TempDashboardRoute()]);
            
              }
            });
          } else if (state.errorMessage?.isNotEmpty == true && !state.isSubmitting) {
            debugPrint('❌ Error: ${state.errorMessage}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
            setState(() {
              currentMpin = '';
              mpinController.clear();
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: TransparentAppBar(
              showBackButton: false,
              preferredSize: const Size.fromHeight(60),
              action: LanguageSelectorWidget(),
            ),
            backgroundColor: Colors.white,
           body: Unfocuser(
  child: SafeArea(
    child: SingleChildScrollView(  // Wrap with SingleChildScrollView
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 
                       MediaQuery.of(context).padding.top - 
                       MediaQuery.of(context).padding.bottom - 
                       108, // Subtract appbar height + padding
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome ${NameFormatter.capitalizeName(name)}!",
                  style: AppTextStyles.primary.n24w700.blueText,
                ),
                const SizedBox(height: 8),
                Text(
                  "Please enter your 4 digits mPIN",
                  style: AppTextStyles.primary.n14w400.blueText,
                ),
                const SizedBox(height: 48),

                // PIN Input Section
                GestureDetector(
                  onTap: () {
                    if (mounted) {
                      otpFocusNode.requestFocus();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      color: AppColors.otpContainerColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.otpBorder,
                      ),
                    ),
                    child: Center(
                      child: _buildPinDots(currentMpin),
                    ),
                  ),
                ),

                // Hidden TextField
                Transform.translate(
                  offset: const Offset(0, -10000),
                  child: SizedBox(
                    width: 1,
                    height: 1,
                    child: TextField(
                      controller: mpinController,
                      focusNode: otpFocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      style: const TextStyle(
                        color: Colors.transparent,
                        fontSize: 1,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {
                        setState(() {
                          currentMpin = value;
                        });
                      },
                      onSubmitted: (value) {
                        if (value.length == 4) {
                          _handleMpinLogin(currentMpin: currentMpin);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                
                // Login Button
                AppButton(
                  title: context.l10n.login,
                  isActive: currentMpin.length == 4,
                  onPressed: () {
                    _handleMpinLogin(currentMpin: currentMpin);
                  },
                  buttonColor: AppColors.primaryBlueButton,
                ),
                
                // Forgot mPIN
                TextButton(
                  onPressed: _handleForgotMpin,
                  child: Text(
                    "Forgot mPin?",
                    style: AppTextStyles.primary.n16w500.primaryBlueText,
                  ),
                ),
                
                const SizedBox(height: 24),  // Reduced from 55
                
                // Biometric Icon with loading state
                if (_isCheckingBiometric)
                  const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else if (_shouldShowBiometric)
                  Center(
                    child: GestureDetector(
                      onTap: _authenticateWithBiometrics,
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            AppAssets.icBiometric,
                          ),
                          // const SizedBox(height: 8),
                          // Text(
                          //   'Use Biometrics',
                          //   style: AppTextStyles.primary.n14w400.blueText,
                          // ),
                        ],
                      ),
                    ),
                  ),

                const Spacer(),
                
                // Create Account Link
                AppButton(
                  title: "Log in with a different account",
                  isActive: true,
                  onPressed: () {
             
                       appRouter.push(
LoginRoute()
        );
                  },
                  buttonColor: AppColors.white,
                  borderColor: AppColors.whiteButtonBorder,
                  textStyle: AppTextStyles.primary.n16w700.black,
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      appRouter.push(const RegistrationRoute());
                    },
                    child: Text(
                      context.l10n.new_here_create_an_account,
                      style: AppTextStyles.primary.n16w500.primaryBlueText,
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    ),
  ),
),
          );
        },
      ),
    );
  }
}