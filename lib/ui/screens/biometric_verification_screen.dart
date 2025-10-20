import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ryal_mobile/injection.dart';
import 'package:ryal_mobile/main.dart';
import 'package:ryal_mobile/route/app_router.dart';
import 'package:ryal_mobile/services/providers/i_local_storage_provider.dart';
import 'package:ryal_mobile/state/register/register_cubit.dart';
import 'package:ryal_mobile/ui/components/buttons/app_button.dart';
import 'package:ryal_mobile/ui/resources/app_assets.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';
import 'package:ryal_mobile/ui/resources/app_text_styles.dart';

@RoutePage()
class BiometricVerificationScreen extends StatefulWidget {
  const BiometricVerificationScreen({super.key});

  @override
  State<BiometricVerificationScreen> createState() =>
      _BiometricVerificationScreenState();
}

class _BiometricVerificationScreenState
    extends State<BiometricVerificationScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final ILocalStorageProvider _storageProvider = getIt<ILocalStorageProvider>();
  bool _isAuthenticating = false;

  Future<void> _enableBiometric() async {
    setState(() {
      _isAuthenticating = true;
    });

    try {
      // Check if device supports biometrics
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometric authentication is not available'),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() {
          _isAuthenticating = false;
        });
        return;
      }

      // Authenticate with biometrics
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to enable Face ID',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (didAuthenticate) {
        // Save biometric enabled status to local storage
        await _storageProvider.setBiometricEnabled(true);
await getIt<RegisterCubit>().updateStatus(is_biometric_verified: true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Face ID enabled successfully'),
              backgroundColor: Colors.green,
            ),
          );
debugPrint("didAuthenticate")  ;
          appRouter.replace(const TempDashboardRoute());
          // Navigate to home or next screen
      //    context.router.replace(const HomeRoute());
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  Future<void> _skipBiometric() async {
    await _storageProvider.setBiometricEnabled(false);
    if (mounted) {
      debugPrint("kjandkjad");
      appRouter.replace(const TempDashboardRoute());
     // context.router.replace(const HomeRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     
      body: Stack(
        children: [
           Positioned.fill(
        child: Image.asset(
          "assets/png/bg2.png",
         // AppAssets.bg,
          fit: BoxFit.cover,
        ),
      ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
            
                  // Face ID Icon
                                  
                  const SizedBox(height: 60),
                                  
            
                   Center(
                     child: Image.asset(
                                        AppAssets.biometric,
                                        height: 300,
                                        width: 300,
                                      ),
                   ),
            
                                  
                  
            
                  const SizedBox(height: 16),
            
                  // Title
                  Text(
                    'Access the app with ease',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.primary.n24w700.primaryBlueText
                  ),
            
            
                  // Description
                 
            
                  const Spacer(flex: 3),
             Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlueButton.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    
                    child: Text(
                      'Face ID is stored securely on your\ndevice and never shared.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.primary.n14w400.copyWith(
                        color: AppColors.primaryBlueButton,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
            
                  // Enable Face ID Button
                  AppButton(
                    title: _isAuthenticating ? 'Authenticating...' : 'Enable Face ID',
                    isActive: !_isAuthenticating,
                    buttonColor: AppColors.primaryBlueButton,
                    onPressed: _isAuthenticating ? null : _enableBiometric,
                  ),
            
                  const SizedBox(height: 16),
            
                  // Not Now Button
                  TextButton(
                    onPressed: _isAuthenticating ? null : _skipBiometric,
                    child: Text(
                      'Not Now',
                      style: AppTextStyles.primary.n16w600.copyWith(
                        color: AppColors.primaryBlueButton,
                      ),
                    ),
                  ),
            
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}