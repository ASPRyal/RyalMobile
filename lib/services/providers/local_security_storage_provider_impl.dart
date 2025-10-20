import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:ryal_mobile/services/providers/i_local_storage_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: ILocalStorageProvider)
class LocalSecurityStorageProviderImpl extends ILocalStorageProvider {
  LocalSecurityStorageProviderImpl([
    @factoryParam FlutterSecureStorage? storage,
  ]) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  @override
  Future<String?> getLangCode() async =>
      _storage.read(key: _StorageKeys.langCode);

  @override
  Future<void> saveLangCode(String code) async {
    await _storage.write(key: _StorageKeys.langCode, value: code);
  }

  @override
  Future<void> saveUserData({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required String phone,
  }) async {
    await Future.wait([
      _storage.write(key: _StorageKeys.userId, value: userId),
      _storage.write(key: _StorageKeys.accessToken, value: accessToken),
      _storage.write(key: _StorageKeys.refreshToken, value: refreshToken),
      _storage.write(key: _StorageKeys.phone, value: phone),
    ]);
  }

  @override
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
  }) async {
    final profileData = {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'user_type': userType,
      'qid': qid ?? '',
      'mcit_number': mcitNumber ?? '',
      'nationality': nationality,
      'lang': lang,
      'is_active': isActive,
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
      'is_kyc_verified': isKycVerified,
      'is_biometric_verified': isBiometricVerified,
      'is_mpin': isMpin,
      'kyc_status': kycStatus,
    };

    await _storage.write(
      key: _StorageKeys.userProfile,
      value: jsonEncode(profileData),
    );

    debugPrint('✅ User profile saved successfully');
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile() async {
    debugPrint('📖 Reading user profile from secure storage...');
    final profileJson = await _storage.read(key: _StorageKeys.userProfile);

    if (profileJson == null) {
      debugPrint('⚠️ No profile found in storage');
      return null;
    }

    try {
      final profile = jsonDecode(profileJson) as Map<String, dynamic>;
      debugPrint('✅ Profile loaded from storage');
      return profile;
    } catch (e) {
      debugPrint('❌ Error parsing profile JSON: $e');
      return null;
    }
  }

  @override
  Future<String?> getUserId() async {
    final userId = await _storage.read(key: _StorageKeys.userId);
    debugPrint('📖 Reading user ID: ${userId ?? "null"}');
    return userId;
  }

  @override
  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: _StorageKeys.accessToken);
    debugPrint(
        '📖 Reading access token: ${token != null ? "exists (${token.length} chars)" : "null"}');
    return token;
  }

  @override
  Future<String?> getRefreshToken() async {
    final token = await _storage.read(key: _StorageKeys.refreshToken);
    debugPrint(
        '📖 Reading refresh token: ${token != null ? "exists (${token.length} chars)" : "null"}');
    return token;
  }

  @override
  Future<String?> getPhone() async {
    final phone = await _storage.read(key: _StorageKeys.phone);
    debugPrint('📖 Reading phone: ${phone ?? "null"}');
    return phone;
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    debugPrint('💾 Setting biometric enabled: $enabled');
    await _storage.write(
      key: _StorageKeys.biometricEnabled,
      value: enabled.toString(),
    );
  }

  @override
  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _StorageKeys.biometricEnabled);
    final isEnabled = value == 'true';
    debugPrint('📖 Reading biometric enabled: $isEnabled');
    return isEnabled;
  }

  /// Universal reinstall detection for both iOS and Android
  /// Strategy:
  /// - iOS: Uses UDID + SharedPreferences (Keychain persists after uninstall)
  /// - Android: Uses installation marker in SharedPreferences
  Future<bool> _checkReinstallViaSharedPreferences() async {
    try {
      debugPrint('📱 Checking for reinstall via SharedPreferences...');

      final prefs = await SharedPreferences.getInstance();
      final storedInstallMarker = prefs.getString(_StorageKeys.installMarker);
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      debugPrint('   Stored install marker: ${storedInstallMarker ?? "none"}');

      // If no marker exists in SharedPreferences, but we have secure storage data
      // This means SharedPreferences was cleared (app uninstalled) but secure storage persisted
      if (storedInstallMarker == null) {
        debugPrint('   🔄 REINSTALL DETECTED: SharedPreferences cleared but secure storage persists');
        return true;
      }

      // Parse the stored marker to check timing
      try {
        final parts = storedInstallMarker.split('_');
        if (parts.length >= 2) {
          final storedTime = int.parse(parts[0]);
          final timeDiff = currentTime - storedTime;
          
          // If more than 30 days, likely a reinstall
          const thirtyDaysMs = 30 * 24 * 60 * 60 * 1000;
          if (timeDiff > thirtyDaysMs) {
            debugPrint('   🔄 Time gap detected (${timeDiff ~/ (24 * 60 * 60 * 1000)} days)');
            return true;
          }
        }
      } catch (e) {
        debugPrint('   ⚠️ Could not parse install marker: $e');
      }

      // iOS-specific: Also check UDID
      if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        final currentUDID = iosInfo.identifierForVendor ?? 'unknown';
        final storedUDID = prefs.getString(_StorageKeys.deviceUDID);

        debugPrint('   🍎 iOS UDID check:');
        debugPrint('      Current: $currentUDID');
        debugPrint('      Stored: ${storedUDID ?? "none"}');

        if (storedUDID != null && currentUDID != storedUDID) {
          debugPrint('   🔄 UDID mismatch - device changed or reinstalled');
          return true;
        }
      }

      debugPrint('   ✓ No reinstall detected');
      return false;
    } catch (e) {
      debugPrint('❌ Error in reinstall check: $e');
      return false;
    }
  }

  /// Check if this is a fresh install or reinstall
  /// Works for both iOS and Android
  /// Strategy: SharedPreferences is cleared on uninstall for both platforms,
  /// while secure storage may persist, so we use SharedPreferences as the source of truth
  @override
  Future<bool> isFirstInstall() async {
    try {
      debugPrint('🔍 Checking for fresh install or reinstall...');

      final prefs = await SharedPreferences.getInstance();
      final installMarker = prefs.getString(_StorageKeys.installMarker);
      final appInstalled =
          await _storage.read(key: _StorageKeys.appInstalled);

      debugPrint('   Platform: ${Platform.isIOS ? "iOS" : "Android"}');
      debugPrint('   SharedPrefs install marker: ${installMarker ?? "missing"}');
      debugPrint('   Secure storage app_installed: ${appInstalled ?? "missing"}');

      // PRIMARY CHECK: If no install marker in SharedPreferences
      // This means SharedPreferences was wiped (app was uninstalled)
      if (installMarker == null) {
        // But if secure storage still has data, it's a reinstall
        if (appInstalled == 'true') {
          debugPrint('   🔄 REINSTALL DETECTED');
          debugPrint('      Reason: SharedPreferences cleared but secure storage persists');
          return true;
        }

        // No data anywhere = truly fresh install
        debugPrint('   ✨ FRESH INSTALL: No data found anywhere');
        return true;
      }

      // SECONDARY CHECK: Verify with platform-specific checks
      final isReinstalledViaPrefs = await _checkReinstallViaSharedPreferences();
      if (isReinstalledViaPrefs) {
        return true;
      }

      // All checks passed - existing installation
      debugPrint('   ✓ EXISTING INSTALLATION: Same device, same install');
      return false;
    } catch (e) {
      debugPrint('❌ Error checking first install: $e');
      return true;
    }
  }

  @override
  Future<void> markAppAsInstalled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final packageInfo = await PackageInfo.fromPlatform();
      final versionString =
          '${packageInfo.version}+${packageInfo.buildNumber}';

      // Generate unique installation marker with timestamp
      final timestamp = DateTime.now();
      final installMarker =
          '${timestamp.millisecondsSinceEpoch}_${timestamp.microsecond}';

      // Store in BOTH SharedPreferences (cleared on uninstall) and Secure Storage
      await Future.wait([
        // SharedPreferences - will be cleared on app uninstall
        prefs.setString(_StorageKeys.installMarker, installMarker),
        
        // Secure Storage - may persist after uninstall
        _storage.write(key: _StorageKeys.appInstalled, value: 'true'),
        _storage.write(key: _StorageKeys.installationId, value: installMarker),
        _storage.write(key: _StorageKeys.appVersion, value: versionString),
        _storage.write(
            key: _StorageKeys.installTimestamp,
            value: timestamp.toIso8601String()),
      ]);

      // Platform-specific markers
      if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        final udid = iosInfo.identifierForVendor ?? 'unknown';
        await prefs.setString(_StorageKeys.deviceUDID, udid);
        debugPrint('   📱 iOS: Stored UDID: $udid');
      }

      debugPrint('✅ App marked as installed');
      debugPrint('   Version: $versionString');
      debugPrint('   Install Marker: $installMarker');
      debugPrint('   Platform: ${Platform.isIOS ? "iOS" : "Android"}');
    } catch (e) {
      debugPrint('❌ Error marking app as installed: $e');
    }
  }

  @override
  Future<void> clearAllData() async {
    debugPrint('🗑️ Clearing ALL data from secure storage...');
    debugPrint('   This will delete: tokens, profile, settings, everything');

    try {
      await _storage.deleteAll();
      debugPrint('✅ All secure storage data cleared successfully');

      // iOS: Also clear SharedPreferences to reset UDID tracking
      if (Platform.isIOS) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_StorageKeys.deviceUDID);
       // await prefs.remove(_StorageKeys.firstLaunchTime);
        debugPrint('✅ iOS SharedPreferences cleared');
      }
    } catch (e) {
      debugPrint('❌ Error with deleteAll(): $e');
      debugPrint('   Attempting fallback: deleting keys individually...');

      final keysToDelete = [
        _StorageKeys.userId,
        _StorageKeys.accessToken,
        _StorageKeys.refreshToken,
        _StorageKeys.phone,
        _StorageKeys.userProfile,
        _StorageKeys.biometricEnabled,
        _StorageKeys.appInstalled,
        _StorageKeys.installationId,
        _StorageKeys.appVersion,
        _StorageKeys.installTimestamp,
        _StorageKeys.langCode,
      ];

      for (final key in keysToDelete) {
        try {
          await _storage.delete(key: key);
          debugPrint('   ✓ Deleted: $key');
        } catch (deleteError) {
          debugPrint('   ✗ Failed to delete $key: $deleteError');
        }
      }

      // Clear SharedPreferences
      if (Platform.isIOS) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_StorageKeys.deviceUDID);
     //   await prefs.remove(_StorageKeys.firstLaunchTime);
      }

      debugPrint('✅ Fallback deletion completed');
    }
  }

  /// Complete logout - clears user data but keeps app installation info
  Future<void> completeLogout() async {
    debugPrint('🗑️ Performing complete logout - clearing user data...');

    await Future.wait([
      _storage.delete(key: _StorageKeys.userId),
      _storage.delete(key: _StorageKeys.accessToken),
      _storage.delete(key: _StorageKeys.refreshToken),
      _storage.delete(key: _StorageKeys.phone),
      _storage.delete(key: _StorageKeys.userProfile),
      _storage.delete(key: _StorageKeys.biometricEnabled),
    ]);

    debugPrint(
        '✅ Complete logout - user data cleared (installation info preserved)');
  }

  /// Soft logout - for inactivity timeout
  Future<void> softLogout() async {
    debugPrint('🔄 Performing soft logout (inactivity timeout)...');
    debugPrint(
        '   All data preserved - user can re-authenticate with mPIN/biometric');
    debugPrint('✅ Soft logout complete');
  }
}

abstract class _StorageKeys {
  static const String langCode = 'langCode';
  static const String userId = 'user_id';
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String phone = 'phone';
  static const String biometricEnabled = 'biometric_enabled';
  static const String userProfile = 'user_profile';
  static const String appInstalled = 'app_installed';
  static const String installationId = 'installation_id';
  static const String appVersion = 'app_version';
  static const String installTimestamp = 'install_timestamp';
  
  // SharedPreferences keys (critical for reinstall detection - cleared on uninstall)
  static const String installMarker = 'install_marker'; // PRIMARY: Used to detect reinstall
  static const String deviceUDID = 'device_udid'; // iOS: Device identifier
}