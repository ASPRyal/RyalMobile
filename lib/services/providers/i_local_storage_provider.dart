
abstract class ILocalStorageProvider {
  const ILocalStorageProvider();


  Future<void> saveLangCode(String code);
  Future<String?> getLangCode();
   Future<void> saveUserData({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required String phone,
  });
   Future<void> saveUserProfile({
    required String name,
    required String email,
    required String phoneNumber,
    required String userType,
   String? qid,
    String? mcitNumber,
    required String nationality,
    required String lang,
    required bool isActive,
    required bool isEmailVerified,
    required bool isPhoneVerified,
    required bool isKycVerified,
    required bool isBiometricVerified,
    required bool isMpin,
    required String kycStatus,
  });
  
  Future<Map<String, dynamic>?> getUserProfile();
  Future<String?> getUserId();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<String?> getPhone();
  
  //Future<void> clearUserData();
  Future<void> setBiometricEnabled(bool enabled);
Future<bool> isBiometricEnabled();
  Future<bool> isFirstInstall();
  Future<void> markAppAsInstalled();
  Future<void> clearAllData();
  
}
