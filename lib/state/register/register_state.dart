part of 'register_cubit.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState({
    required String fullname,
    required String phoneNumber,
    required String email,
    required String qid,
    required String selectedCountryCode,
    required String selectedCountryPhoneCode,
    required bool termsAccepted,
    required bool isSubmitting,
    required bool isSuccess,
    required bool isLoginSuccess,
    required bool otpSendSuccess,
    required bool otpVerifySuccess,

    required bool registerOtpApiVerified,
    required bool loginOtpApiVerified,
    required String selectedNationality,
  required  String nationality,
  required  String countryCode,
   required String mcitNumber, // Add this field
    required UserType userType,
required bool mpinSuccess,
required bool isKycVerified,
required bool ismpinSet,
required bool isBiometricSetup,
required String username,
required String companyName,
required String buildingNo,
required String zone,
required String streetNo,




    required bool showErrors, // Track if errors should be displayed
    String? errorMessage, // For API error messages
    RegisterUserResponse? registerResponse, // Store API response
    required String otpCode
  }) = _RegisterState;

  factory RegisterState.initial() => RegisterState(
    username: "",
    companyName: "",
    buildingNo: "",
    zone: "",
    streetNo: "",
    

        fullname: '',
        phoneNumber: '',    
        qid: '',
        email: '',
        otpSendSuccess: false,
        isKycVerified: false,
        ismpinSet: false,     
        isBiometricSetup: false,
        
        otpVerifySuccess: false,
        nationality: '',
        mcitNumber: '',
        mpinSuccess: false,
        userType: UserType.individual,
        countryCode: '',
        selectedNationality: '',
        registerOtpApiVerified: false,
       loginOtpApiVerified: true,

        selectedCountryCode: 'QA',
        selectedCountryPhoneCode: '974',
        otpCode: '',
        termsAccepted: false,
        isLoginSuccess: false,
        isSubmitting: false,
        isSuccess: false,
        showErrors: false,
        errorMessage: null,
        registerResponse: null,
      );
}