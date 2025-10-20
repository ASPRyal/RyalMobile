import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ryal_mobile/injection.dart';
import 'package:ryal_mobile/main.dart';
import 'package:ryal_mobile/route/app_router.dart';
import 'package:ryal_mobile/services/providers/i_local_storage_provider.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> 
{
  final ILocalStorageProvider _storageProvider = getIt<ILocalStorageProvider>();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    if (!mounted) return;

    try {
      debugPrint("🚀 App Initialization Started");
      
      // Wait minimum 5 seconds for splash screen animation
      await Future.delayed(const Duration(seconds: 5));
      
      if (!mounted) return;

      // ============================================
      // STEP 1: Check if this is a fresh install or reinstall
      // ============================================
      debugPrint("🔍 Checking if this is a fresh install...");
      final isFirstInstall = await _storageProvider.isFirstInstall();
      
      if (isFirstInstall) {
        debugPrint("✨ FRESH INSTALL or REINSTALL DETECTED!");
        debugPrint("   🗑️ CLEARING ALL EXISTING DATA...");
        
        // Clear EVERYTHING from secure storage
        await _storageProvider.clearAllData();
        
        // Verify data was cleared
        final verifyToken = await _storageProvider.getAccessToken();
        final verifyProfile = await _storageProvider.getUserProfile();
        
        debugPrint("   📊 Verification after clear:");
        debugPrint("      Token exists: ${verifyToken != null}");
        debugPrint("      Profile exists: ${verifyProfile != null}");
        
        if (verifyToken == null && verifyProfile == null) {
          debugPrint("   ✅ All data successfully cleared");
        } else {
          debugPrint("   ⚠️ Warning: Some data may still exist");
        }
        
        // Mark app as installed (creates new installation ID)
        await _storageProvider.markAppAsInstalled();
        
        debugPrint("   🎯 Navigating to auth selection for new user");
        _navigateToLogin();
        return;
      }
      
      debugPrint("✓ Existing installation, checking stored credentials...");

      // ============================================
      // STEP 2: Check for existing credentials (existing users)
      // ============================================
      final accessToken = await _storageProvider.getAccessToken();
      final refreshToken = await _storageProvider.getRefreshToken();
      
      debugPrint("   Access token exists: ${accessToken?.isNotEmpty ?? false}");
      debugPrint("   Refresh token exists: ${refreshToken?.isNotEmpty ?? false}");

      // If we have EITHER token, check the stored profile
      if ((accessToken != null && accessToken.isNotEmpty) || 
          (refreshToken != null && refreshToken.isNotEmpty)) {
        
        debugPrint("✓ User has credentials, checking profile...");
        
        // Get profile from local storage
        final profile = await _storageProvider.getUserProfile();
        
        if (profile != null) {
          debugPrint("✓ Profile found in storage");
          debugPrint("   Name: ${profile['name']}");
          debugPrint("   Email: ${profile['email']}");
          debugPrint("   Phone: ${profile['phone_number']}");
          debugPrint("   Biometric verified: ${profile['is_biometric_verified']}");
          debugPrint("   mPIN set: ${profile['is_mpin']}");
          
          // Navigate based on stored profile
          _navigateBasedOnProfile(profile);
        } else {
          debugPrint("⚠️ No profile in storage despite having tokens");
          debugPrint("   This indicates corrupted data - clearing everything");
          await _storageProvider.clearAllData();
          await _storageProvider.markAppAsInstalled();
          _navigateToLogin();
        }
      } else {
        debugPrint("❌ No credentials found, navigating to auth selection");
        _navigateToLogin();
      }
    } 
    catch (e, stackTrace) {
      debugPrint('❌ Initialization error: $e');
      debugPrint('Stack trace: $stackTrace');
      
      // On error, clear everything and start fresh
      try {
        debugPrint('🗑️ Clearing all data due to error...');
        await _storageProvider.clearAllData();
        await _storageProvider.markAppAsInstalled();
        debugPrint('✅ Data cleared after error');
      } catch (clearError) {
        debugPrint('❌ Error clearing data: $clearError');
      }
      
      if (!mounted) return;
      _navigateToLogin();
    }
  }

  void _navigateBasedOnProfile(Map<String, dynamic> profile) {
    debugPrint("🧭 Determining navigation based on profile...");
    
    final isMpinSet = profile['is_mpin'] == true;

    if (isMpinSet) {
      // User has mPIN set up, go to mPIN login screen
      debugPrint("✓ User has mPIN, navigating to mPIN login");
      appRouter.replaceAll([
        const MpinBioLoginRoute()
      ]);
    } else {
      // User hasn't completed onboarding, go to auth selection
      debugPrint("⚠️ User hasn't set mPIN, navigating to auth selection");
      appRouter.replaceAll([const LoginRoute()]);
    }
  }

  void _navigateToLogin() {
    debugPrint('🔐 Navigating to auth selection...');
    appRouter.replaceAll([const AuthSelectionRoute()]);
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Lottie.asset(
        'assets/json/splash.json',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        repeat: false,
        animate: true,
      ),
    );
  }
}