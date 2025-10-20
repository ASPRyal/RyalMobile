import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ryal_mobile/core/app_validation_rule.dart';
import 'package:ryal_mobile/data/dto/failures/input_fields_failure.dart';
import 'package:ryal_mobile/data/dto/failures/server_failure.dart';
import 'package:ryal_mobile/data/dto/failures/uncaught_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ryal_mobile/data/dto/register_user_response.dart';
import 'package:ryal_mobile/data/dto/services/i_authentication_service.dart';
import 'package:ryal_mobile/data/dto/services/i_user_service.dart';
import 'package:ryal_mobile/services/providers/i_local_storage_provider.dart';
import 'package:ryal_mobile/ui/enums/user_type_enum.dart';

part 'register_cubit.freezed.dart';
part 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final IAuthenticationService _authService;
  final IUserService _userService;

  final ILocalStorageProvider _storageProvider;

  RegisterCubit(
    this._authService,
    this._storageProvider,
    this._userService
  ) : super(RegisterState.initial());

  // Full Name methods
  void onFullNameChange(String fullName) {
    emit(state.copyWith(
      fullname: fullName,
    ));
  }

  // Phone methods
  void onPhoneChange(String phoneNumber) {
    emit(state.copyWith(
      phoneNumber: phoneNumber,
    ));
  }

 
// Replace your loginUsingRefreshToken method with this:
Future<void> loginUsingRefreshToken() async {
  emit(state.copyWith(isSubmitting: true, errorMessage: null, mpinSuccess: false));

  try {
  debugPrint("🔄 Step 1: Getting refresh token from storage...");
    final refreshToken = await _storageProvider.getRefreshToken(); 
    
    if (refreshToken == null || refreshToken.isEmpty) {
   debugPrint("❌ No refresh token found in storage");
      throw Exception("No refresh token found. Please login again.");
    }

    debugPrint("✓ Refresh token found (length: ${refreshToken.length})");
   debugPrint("🔄 Step 2: Calling refresh token API...");

    final result = await _authService.getRefreshToken(refreshToken: refreshToken);
    
    await result.fold(
      (failure) async {
       debugPrint("❌ Refresh token API failed: ${failure.message}");
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
          mpinSuccess: false,
        ));
      },
      (newTokens) async {
        debugPrint("✅ Step 2 complete: Got new tokens");
        debugPrint("   Access token length: ${newTokens.access_token.length}");
        debugPrint("   User ID: ${newTokens.user_id}");
        
      debugPrint("🔄 Step 3: Saving new tokens to storage...");
        final phone = await _storageProvider.getPhone();
        
        await _storageProvider.saveUserData(
          userId: newTokens.user_id.toString(),
          accessToken: newTokens.access_token,
          refreshToken: newTokens.refresh_token,
          phone: phone ?? "", 
        );
        
        debugPrint("✅ Step 3 complete: New tokens saved");
        
        // Verify tokens were saved
        final savedRefreshToken = await _storageProvider.getRefreshToken();
        final savedAccessToken = await _storageProvider.getAccessToken();
       debugPrint("✓ Verified - Access token saved: ${savedAccessToken?.isNotEmpty ?? false}");
        debugPrint("✓ Verified - Refresh token saved: ${savedRefreshToken?.isNotEmpty ?? false}");
        
       debugPrint("🔄 Step 4: Fetching user profile with new access token...");
        
        // Now fetch user profile with the new access token
        final profileResult = await _userService.getUserProfile();
        
        await profileResult.fold(
          (failure) async {
            debugPrint("❌ Failed to get user profile: ${failure.message}");
            emit(state.copyWith(
              isSubmitting: false,
              errorMessage: 'Failed to load user profile. Please try again.',
              mpinSuccess: false,
            ));
          },
          (userProfile) async {
           debugPrint("✅ Step 4 complete: User profile fetched");
            debugPrint("   Name: ${userProfile.name}");
            debugPrint("   Email: ${userProfile.email}");
            debugPrint("   Biometric verified: ${userProfile.is_biometric_verified}");
          debugPrint("   mPIN set: ${userProfile.is_mpin}");
            
            debugPrint("🔄 Step 5: Saving user profile to local storage...");
            
            try {
              await _storageProvider.saveUserProfile(
                name: userProfile.name,
                email: userProfile.email,
                phoneNumber: userProfile.phone_number,
                userType: userProfile.user_type,
                qid: userProfile.qid ?? '',
                mcitNumber: userProfile.mcit_number ?? "",
                nationality: userProfile.nationality,
                lang: userProfile.lang,
                isActive: userProfile.is_active,
                isEmailVerified: userProfile.is_email_verified,
                isPhoneVerified: userProfile.is_phone_verified,
                isKycVerified: userProfile.is_kyc_verified,
                isBiometricVerified: userProfile.is_biometric_verified,
                isMpin: userProfile.is_mpin,
                kycStatus: userProfile.kyc_status,
              );
              
             debugPrint("✅ Step 5 complete: User profile saved to storage");
             debugPrint("✅✅✅ LOGIN USING REFRESH TOKEN SUCCESSFUL ✅✅✅");
              
              // Emit success state - this will trigger navigation in the BlocListener
              emit(state.copyWith(
                isSubmitting: false,
                mpinSuccess: true,  // This triggers navigation
                loginOtpApiVerified: true,
                errorMessage: null,
              ));
              
            } catch (e) {
              debugPrint("❌ Error saving profile to storage: $e");
              emit(state.copyWith(
                isSubmitting: false,
                errorMessage: 'Failed to save profile locally',
                mpinSuccess: false,
              ));
            }
          },
        );
      },
    );
    
  } catch (e) {
   debugPrint("❌ Unexpected error in loginUsingRefreshToken: $e");
    emit(state.copyWith(
      isSubmitting: false, 
      errorMessage: e.toString(),
      mpinSuccess: false,
    ));
  }
}

  // QID methods
  void onQidChange(String qidNumber) {
    emit(state.copyWith(
      qid: qidNumber,
    ));
  }

  // MCIT Number methods
  void onMcitNumberChange(String mcitNumber) {
    emit(state.copyWith(mcitNumber: mcitNumber));
  }

  // Email methods
  void onEmailChange(String email) {
    emit(state.copyWith(
      email: email,
    ));
  }

  // User Type methods
  void onUserTypeChange(UserType userType) {
    emit(state.copyWith(userType: userType));
  }

  // Terms acceptance
  void toggleTermsAcceptance() {
    emit(state.copyWith(
      termsAccepted: !state.termsAccepted,
    ));
  }

  // Country selection
  void onCountryChange(String countryCode, String phoneCode) {
    emit(state.copyWith(
      selectedCountryCode: countryCode,
      selectedCountryPhoneCode: phoneCode,
    ));
  }

  // Nationality selection
  void selectedNationality({required String nationality}) {
    emit(state.copyWith(
      selectedNationality: nationality,
    ));
  }

  // Show errors after validation attempt
  void showValidationErrors() {
    emit(state.copyWith(
      showErrors: true,
    ));
  }
// Building Number methods
void onBuildingNoChange(String buildingNo) {
  emit(state.copyWith(
    buildingNo: buildingNo,
  ));
}

// Zone methods
void onZoneChange(String zone) {
  emit(state.copyWith(
    zone: zone,
  ));
}

// Street Number methods
void onStreetNoChange(String streetNo) {
  emit(state.copyWith(
    streetNo: streetNo,
  ));
}

// Username methods
void onUsernameChange(String username) {
  emit(state.copyWith(
    username: username,
  ));
}

// Company Name methods
void onCompanyNameChange(String companyName) {
  emit(state.copyWith(
    companyName: companyName,
  ));
}
  // Check if all fields are filled (for button activation)
bool get areAllFieldsFilled {
  if (state.userType == UserType.individual) {
    // Individual user requirements
    return state.fullname.trim().isNotEmpty &&
        state.phoneNumber.trim().isNotEmpty &&
        state.qid.trim().isNotEmpty &&
        state.email.trim().isNotEmpty &&
        state.selectedNationality.trim().isNotEmpty &&
        state.termsAccepted;
  } else {
    // Corporate user requirements
    return state.username.trim().isNotEmpty &&
        state.companyName.trim().isNotEmpty &&
        state.phoneNumber.trim().isNotEmpty &&
        state.email.trim().isNotEmpty &&
        state.qid.trim().isNotEmpty &&
        state.buildingNo.trim().isNotEmpty &&
        state.zone.trim().isNotEmpty &&
        state.streetNo.trim().isNotEmpty &&
        state.termsAccepted;
  }
}

  // Check if all fields are valid (for actual submission)
bool get areAllFieldsValid {
  if (state.userType == UserType.individual) {
    // Individual user validation
    return state.fullname.trim().isNotEmpty &&
        state.phoneNumber.trim().isNotEmpty &&
        AppValidationRule.phoneValidator(state.phoneNumber.trim()) &&
        state.qid.trim().isNotEmpty &&
        AppValidationRule.qidValidator(state.qid.trim()) &&
        state.email.trim().isNotEmpty &&
        AppValidationRule.emailValidator(state.email.trim()) &&
        state.selectedNationality.trim().isNotEmpty &&
        state.termsAccepted;
  } else {
    // Corporate user validation
    return state.username.trim().isNotEmpty &&
        state.companyName.trim().isNotEmpty &&
        state.phoneNumber.trim().isNotEmpty &&
        AppValidationRule.phoneValidator(state.phoneNumber.trim()) &&
        state.email.trim().isNotEmpty &&
        AppValidationRule.emailValidator(state.email.trim()) &&
        state.qid.trim().isNotEmpty &&
        AppValidationRule.qidValidator(state.qid.trim()) &&
        state.buildingNo.trim().isNotEmpty &&
        state.zone.trim().isNotEmpty &&
        state.streetNo.trim().isNotEmpty &&
        state.termsAccepted;
  }}

  // Get error text for full name
  String? getFullNameError() {
    if (!state.showErrors) return null;
    if (state.fullname.trim().isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  // Get error text for phone
  String? getPhoneError() {
    if (!state.showErrors) return null;
    if (state.phoneNumber.trim().isEmpty) {
      return 'Please enter your phone number';
    } else if (!AppValidationRule.phoneValidator(state.phoneNumber.trim())) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  // Get error text for QID
  String? getQidError() {
    if (!state.showErrors) return null;
    if (state.qid.trim().isEmpty) {
      return 'Please enter your QID number';
    } else if (!AppValidationRule.qidValidator(state.qid.trim())) {
      return 'Please enter a valid QID number';
    }
    return null;
  }

  // Get error text for MCIT
  String? getMcitError() {
    if (!state.showErrors) return null;
    if (state.userType == UserType.corporate) {
      if (state.mcitNumber.trim().isEmpty) {
        return 'Please enter your MCIT number';
      } else if (!AppValidationRule.mcitValidator(state.mcitNumber.trim())) {
        return 'Please enter a valid MCIT number';
      }
    }
    return null;
  }

  // Get error text for email
  String? getEmailError() {
    if (!state.showErrors) return null;
    if (state.email.trim().isEmpty) {
      return 'Please enter your email';
    } else if (!AppValidationRule.emailValidator(state.email.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }




  // Check if field has error
  bool hasError(String fieldType) {
    if (!state.showErrors) return false;
    
    switch (fieldType) {
      case 'fullname':
        return state.fullname.trim().isEmpty;
      case 'phone':
        return state.phoneNumber.trim().isEmpty || 
               !AppValidationRule.phoneValidator(state.phoneNumber.trim());
      case 'qid':
        return state.qid.trim().isEmpty || 
               !AppValidationRule.qidValidator(state.qid.trim());
      case 'mcit':
        if (state.userType == UserType.corporate) {
          return state.mcitNumber.trim().isEmpty || 
                 !AppValidationRule.mcitValidator(state.mcitNumber.trim());
        }
        return false;
      case 'email':
        return state.email.trim().isEmpty || 
               !AppValidationRule.emailValidator(state.email.trim());
      default:
        return false;
    }
  }


void onOtpChanged(String otp) {
  emit(state.copyWith(
    otpCode: otp,
    // Reset verification flags when OTP changes
    loginOtpApiVerified: false,
    registerOtpApiVerified: false,
    errorMessage: null,
  ));
}
  // Validation and submission with Service Layer
  Future<void> validateAndSubmit() async {
    // First show errors
    emit(state.copyWith(showErrors: true));

    if (!areAllFieldsValid) {
      return;
    }

    if (!state.termsAccepted) {
      return;
    }
    
    final fullPhoneNumber = '+${state.selectedCountryPhoneCode}${state.phoneNumber.trim()}';

emit(state.copyWith(isSubmitting: true, errorMessage: null));

    // Prepare registration data based on user type
    final result = await _authService.register(
      fullName:state.userType == UserType.individual ? state.fullname.trim(): state.username.trim(),
      email: state.email.trim(),
      phoneNumber: fullPhoneNumber,
      qidNumber: state.qid.trim(),
      userType: state.userType == UserType.individual ? 'individual' : 'corporate',
      mcitNumber: state.userType == UserType.corporate ? state.companyName : null,
      nationality: state.selectedNationality
    );
    
    debugPrint('Registration Data:');
    debugPrint('Phone: $fullPhoneNumber');
    debugPrint('UserType: ${state.userType == UserType.individual ? "individual" : "corporate"}');
    debugPrint('QID: ${state.qid.trim()}');
    if (state.userType == UserType.corporate) {
      debugPrint('MCIT: ${state.mcitNumber.trim()}');
    }
    
    result.fold(
      (failure) {
        String errorMessage = 'Registration failed. Please try again.';
        
        // Handle different failure types
        if (failure is UncaughtFailure) {
          errorMessage = failure.message;
        } else if (failure is ServerFailure) {
          errorMessage = 'Server error. Please try again later.';
        } else if (failure is InputFieldsFailure) {
          errorMessage = 'Please check your information and try again.';
        }
        
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          errorMessage: errorMessage,
        ));
      },
      (response) {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          registerResponse: response,
        ));
      },
    );
  }

  void clearErrors() {
    emit(state.copyWith(
      errorMessage: null,
      registerOtpApiVerified: false,
      isSubmitting: false,
    ));
  }

  Future<void> verifyRegisterOtp({required String phoneNumber}) async {
    emit(state.copyWith(isSubmitting: true, registerOtpApiVerified: false));

    final result = await _authService.verifyRegisterOtp(
      phoneNumber: phoneNumber,
      otp: state.otpCode,
    );

    result.fold(
      (failure) {
        String errorMessage = 'Registration failed. Please try again.';
        
        // Handle different failure types
        if (failure is UncaughtFailure) {
          errorMessage = failure.message;
        } else if (failure is ServerFailure) {
          errorMessage = 'Server error. Please try again later.';
        } else if (failure is InputFieldsFailure) {
          errorMessage = 'Please check your information and try again.';
        }
        
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          errorMessage: errorMessage,
        ));
      },
      (response) {
        emit(state.copyWith(
          isSubmitting: false,
          registerOtpApiVerified: true,
        ));
      },
    );
  }


  Future<void> setMpin({required String mpin}) async {
  emit(state.copyWith(
    isSubmitting: true,
    mpinSuccess: false,
    errorMessage: null,
  ));

  // Get userId from storage
  final userIdString = await _storageProvider.getUserId();
  
  if (userIdString == null || userIdString.isEmpty) {
    emit(state.copyWith(
      isSubmitting: false,
      mpinSuccess: false,
      errorMessage: 'User ID not found. Please login again.',
    ));
    return;
  }

  // Convert string to int
  final userId = int.tryParse(userIdString);
  
  if (userId == null) {
    emit(state.copyWith(
      isSubmitting: false,
      mpinSuccess: false,
      errorMessage: 'Invalid user ID. Please login again.',
    ));
    return;
  }

  final result = await _userService.setMpin(
    mpin: mpin,
    userId: userId,
  );

  result.fold(
    (failure) {
      String errorMessage = 'Failed to set mPIN. Please try again.';
      
      if (failure is UncaughtFailure) {
        errorMessage = failure.message;
      } else if (failure is ServerFailure) {
        errorMessage = 'Server error. Please try again later.';
      } else if (failure is InputFieldsFailure) {
        errorMessage = 'Please check your information and try again.';
      }
      
      emit(state.copyWith(
        isSubmitting: false,
        mpinSuccess: false,
        errorMessage: errorMessage,
      ));
    },
    (response) {
      emit(state.copyWith(
        isSubmitting: false,
        mpinSuccess: true,
        errorMessage: null,
      ));
    },
  );
}


  Future<void> updateStatus({ bool? is_biometric_verified,bool? is_kyc_verified,bool? is_email_verified,bool ? is_phone_verified}) async {
  emit(state.copyWith(
    isSubmitting: true,
    errorMessage: null,
  ));

  // Get userId from storage

 

  final result = await _userService.updateStatus( 
    is_biometric_verified: is_biometric_verified,
    is_email_verified: is_email_verified,
    is_kyc_verified: is_kyc_verified,
    is_phone_verified: is_phone_verified  
  ) ;

  result.fold(
    (failure) {
      String errorMessage = 'Failed to set status. Please try again.';
      
      if (failure is UncaughtFailure) {
        errorMessage = failure.message;
      } else if (failure is ServerFailure) {
        errorMessage = 'Server error. Please try again later.';
      } else if (failure is InputFieldsFailure) {
        errorMessage = 'Please check your information and try again.';
      }
      
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: errorMessage,
      ));
    },
    (response) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: null,
      ));
    },
  );
}




Future<void> verifyLoginrOtp({required String phoneNumber}) async {
  emit(state.copyWith(
    isSubmitting: true, 
    registerOtpApiVerified: false,
    loginOtpApiVerified: false,
    errorMessage: null,
  ));

  final result = await _authService.verifyLoginOtp(
    phoneNumber: phoneNumber,
    otp: state.otpCode,
  );

  await result.fold(
    (failure) async {
      String errorMessage = 'Login failed. Please try again.';
      
      if (failure is UncaughtFailure) {
        errorMessage = failure.message;
      } else if (failure is ServerFailure) {
        errorMessage = 'Server error. Please try again later.';
      } else if (failure is InputFieldsFailure) {
        errorMessage = 'Please check your information and try again.';
      }
      
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        errorMessage: errorMessage,
      ));
    },
    (response) async {
      debugPrint('✅ Login OTP verified successfully');
      
      // Store user data after successful login OTP verification
      await _storageProvider.saveUserData(
        userId: response.user_id.toString(),
        accessToken: response.access_token,
        refreshToken: response.refresh_token,
        phone: phoneNumber,
      );
      
      debugPrint('💾 Tokens saved, now fetching user profile...');
      
      // Fetch user profile and wait for it to complete
      await getUserProfile();
      
      debugPrint('✅ Profile fetched, now emitting loginOtpApiVerified');
      
      // Only emit success AFTER profile is fetched and state is updated
      emit(state.copyWith(
        isSubmitting: false,
        loginOtpApiVerified: true,
        errorMessage: null,
      ));
    },
  );
}

Future<void> sendOtp({required String phoneNumber }) async {
  emit(state.copyWith(
    isSubmitting: true, 
    otpSendSuccess: false,

  ));

  final result = await _authService.sendOtp(phoneNumber:  phoneNumber);

  result.fold(
    (failure) {
      String errorMessage = 'Login failed. Please try again.';
      
      if (failure is UncaughtFailure) {
        errorMessage = failure.message;
      } else if (failure is ServerFailure) {
        errorMessage = 'Server error. Please try again later.';
      } else if (failure is InputFieldsFailure) {
        errorMessage = 'Please check your information and try again.';
      }
      
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        errorMessage: errorMessage,
      ));
    },
    (response) async {
     

      emit(state.copyWith(
        isSubmitting: false,
        otpSendSuccess: true,
      ));
    },
  );
}
Future<void> verifyOtp({required String phoneNumber }) async {
  emit(state.copyWith(
    isSubmitting: true, 
    otpVerifySuccess: false,
  ));

  final result = await _authService.verifyOtp(phoneNumber: phoneNumber, otp: state.otpCode);

  result.fold(
    (failure) {
      String errorMessage = 'Login failed. Please try again.';
      
      if (failure is UncaughtFailure) {
        errorMessage = failure.message;
      } else if (failure is ServerFailure) {
        errorMessage = 'Server error. Please try again later.';
      } else if (failure is InputFieldsFailure) {
        errorMessage = 'Please check your information and try again.';
      }
      
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        errorMessage: errorMessage,
      ));
    },
    (response) async {
     

      emit(state.copyWith(
        isSubmitting: false,
        otpVerifySuccess: true,
      ));
    },
  );
}
Future<void> mpinLogin({required String mpin}) async {
  emit(state.copyWith(
    isSubmitting: true,
    mpinSuccess: false,
    errorMessage: null,
  ));

  final result = await _authService.mpinLogin(mpin: mpin);

  await result.fold(
    (failure) async {
      String errorMessage = 'Login failed. Please try again.';
      
      if (failure is UncaughtFailure) {
        errorMessage = failure.message;
      } else if (failure is ServerFailure) {
        errorMessage = 'Server error. Please try again later.';
      } else if (failure is InputFieldsFailure) {
        errorMessage = 'Please check your information and try again.';
      }
      
      emit(state.copyWith(
        isSubmitting: false,
        mpinSuccess: false,
        errorMessage: errorMessage,
      ));
    },
    (response) async {
      debugPrint('✅ mPIN login API successful');
      debugPrint('   Access token length: ${response.access_token.length}');
      debugPrint('   User ID: ${response.user_id}');
      
      final phoneNumber = await _storageProvider.getPhone();
      
      debugPrint('💾 Saving tokens to storage...');
      
      // Store user data after successful mPIN login
      await _storageProvider.saveUserData(
        userId: response.user_id.toString(),
        accessToken: response.access_token,
        refreshToken: response.refresh_token,
        phone: phoneNumber ?? '',
      );
      
      debugPrint('✅ Tokens saved successfully');
      
      // Fetch and save user profile
      debugPrint('🔄 Fetching user profile...');
      final profileResult = await _userService.getUserProfile();
      
      await profileResult.fold(
        (failure) async {
          debugPrint('⚠️ Failed to fetch profile: ${failure.message}');
          // Still mark as successful login, but without profile
          emit(state.copyWith(
            isSubmitting: false,
            mpinSuccess: true,
            loginOtpApiVerified: true,
            errorMessage: null,
          ));
        },
        (userProfile) async {
          debugPrint('✅ User profile fetched');
          debugPrint('   Name: ${userProfile.name}');
          
          // Save profile to storage
          await _storageProvider.saveUserProfile(
            name: userProfile.name,
            email: userProfile.email,
            phoneNumber: userProfile.phone_number,
            userType: userProfile.user_type,
            qid: userProfile.qid ?? '',
            mcitNumber: userProfile.mcit_number ?? "",
            nationality: userProfile.nationality,
            lang: userProfile.lang,
            isActive: userProfile.is_active,
            isEmailVerified: userProfile.is_email_verified,
            isPhoneVerified: userProfile.is_phone_verified,
            isKycVerified: userProfile.is_kyc_verified,
            isBiometricVerified: true,//userProfile.is_biometric_verified,
            isMpin: userProfile.is_mpin,
            kycStatus: userProfile.kyc_status,
          );
          
          debugPrint('✅ User profile saved to storage');
          debugPrint('✅✅✅ mPIN LOGIN COMPLETE ✅✅✅');
          
          emit(state.copyWith(
            isSubmitting: false,
            mpinSuccess: true,
            loginOtpApiVerified: true,
            errorMessage: null,
          ));
        },
      );
    },
  );
}

Future<void> getUserProfile() async {
  emit(state.copyWith(isSubmitting: true));

  final result = await _userService.getUserProfile();

  result.fold(
    (failure) {
      String errorMessage = 'Failed to load profile. Please try again.';
      
      // Handle different failure types
      if (failure is UncaughtFailure) {
        errorMessage = failure.message;
      } else if (failure is ServerFailure) {
        errorMessage = 'Server error. Please try again later.';
      } else if (failure is InputFieldsFailure) {
        errorMessage = 'Please check your information and try again.';
      }
      
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: errorMessage,
      ));
    },
    (response) async {
      try {
        debugPrint('✅ API returned 200 - Got user profile response');
        debugPrint('   KYC Verified: ${response.is_kyc_verified}');
        debugPrint('   mPIN Set: ${response.is_mpin}');
        debugPrint('   Biometric Verified: ${response.is_biometric_verified}');
     
        await _storageProvider.saveUserProfile(
          name: response.name,
          email: response.email,
          phoneNumber: response.phone_number,
          userType: response.user_type,
          qid: response.qid ?? '',
          mcitNumber: response.mcit_number ?? "",
          nationality: response.nationality,
          lang: response.lang,
          isActive: response.is_active,
          isEmailVerified: response.is_email_verified,
          isPhoneVerified: response.is_phone_verified,
          isKycVerified: response.is_kyc_verified,
          isBiometricVerified: true ,//response.is_biometric_verified,
          isMpin: true ,//response.is_mpin,
          kycStatus: response.kyc_status,
        );
  
        debugPrint('✅ User profile saved to storage');
        
        // IMPORTANT: Only emit once with all the values
        emit(state.copyWith(
          isSubmitting: false,
          isBiometricSetup: response.is_biometric_verified,
          ismpinSet: response.is_mpin,
          isKycVerified: response.is_kyc_verified,
        ));
        
      } catch (e) {
        debugPrint('❌ Error saving profile to storage: $e');
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to save profile locally: $e',
        ));
      }
    },
  );
}
 Future<void> login({required String phoneNumber}) async {
  emit(state.copyWith(
    isSubmitting: true, 
    registerOtpApiVerified: false,
    errorMessage: null, // Clear previous errors
    isLoginSuccess: false,
  ));

  final result = await _authService.login(phoneNumber: phoneNumber);
  

  result.fold(
    (failure) {
      print("failed here");
      String errorMessage = 'Login failed. Please try again.';
      print(failure.message);
      // Handle different failure types with specific messages
      if (failure is UncaughtFailure) {
        // Check if the error message indicates user not found
        if (failure.message.toLowerCase().contains('not found') ||
            failure.message.toLowerCase().contains('does not exist') ||
            failure.message.toLowerCase().contains('user not found') ||
            failure.message.toLowerCase().contains('no user')) {
          errorMessage = 'This phone number is not registered. Please sign up first.';
        } else {
          errorMessage = failure.message;
        }
      } else if (failure is ServerFailure) {
        errorMessage = 'Server error. Please try again later.';
      } else if (failure is InputFieldsFailure) {
        errorMessage = 'Please check your phone number and try again.';
      }
      
      emit(state.copyWith(
        isSubmitting: false,
        isLoginSuccess: false,
        errorMessage: errorMessage,
      ));
    },
    (response) {
      emit(state.copyWith(
        isSubmitting: false,
        isLoginSuccess: true,
        registerOtpApiVerified: true,
        errorMessage: null,
      ));
    },
  );
}

  // Add logout method
  // Future<void> logout() async {
  //   await _storageProvider.clearUserData();
  //   emit(RegisterState.initial());
  // }
}