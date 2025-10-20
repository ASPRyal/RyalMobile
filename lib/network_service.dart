import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:ryal_mobile/data/api/authentication_api.dart';
import 'package:ryal_mobile/data/dto/refresh_token_body.dart';
import 'package:ryal_mobile/main.dart';
import 'package:ryal_mobile/route/app_router.dart';
import 'package:ryal_mobile/services/providers/i_local_storage_provider.dart';

@lazySingleton
class NetworkService {
  final ILocalStorageProvider _storageProvider;
  Dio? _dio;
  bool _isRefreshing = false;
  final List<Completer<void>> _refreshCompleters = [];
  
  // Lifecycle management properties
  DateTime? _lastInteractionTime;
  Timer? _inactivityTimer;
  final _logoutController = StreamController<void>.broadcast();
  
  // CRITICAL: Configurable timeouts
  // 3 minutes of inactivity = redirect to mPIN screen (soft logout)
  // DON'T clear tokens, just navigate to mPIN screen for re-authentication
  static const Duration inactivityTimeout = Duration(minutes: 3); // 3 minutes of inactivity
  static const Duration backgroundTimeout = Duration(minutes: 5); // 5 minutes in background
  
  // ADDED: Flag to enable/disable auto-logout (useful for debugging)
  static const bool enableAutoLogout = true; // Set to false during development if needed
  
  NetworkService(this._storageProvider) {
    if (enableAutoLogout) {
      _startInactivityMonitoring();
    } else {
      debugPrint('⚠️ Auto-logout is DISABLED - this should only be used during development!');
    }
  }

  Dio get dio => _dio ?? _initDio();
  
  /// Stream to listen for logout events
  Stream<void> get onLogout => _logoutController.stream;

  Dio _initDio() {
    final dio = Dio();
    
    // Set base URL
    dio.options.baseUrl = 'http://86.62.209.62:8000/';
    dio.options.headers = {"Content-Type": "application/json"};
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    
    dio.interceptors.addAll([
      QueuedInterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    ]);

    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ));
    }
    
    _dio = dio;
    return dio;
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Update last interaction time on each request
    _updateLastInteraction();
    
    // Skip auth for public endpoints
    if (_isPublicEndpoint(options.path)) {
      handler.next(options);
      return;
    }

    // Add auth token for protected endpoints
    final token = await _storageProvider.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 - Unauthorized (Token expired)
    if (error.response?.statusCode == 401 && 
        !_isPublicEndpoint(error.requestOptions.path)) {
      
      debugPrint("⚠️ Got 401 Unauthorized");
      debugPrint("   Endpoint: ${error.requestOptions.path}");
      
      // If already refreshing, wait for that refresh to complete
      if (_isRefreshing) {
        debugPrint("   Already refreshing token, waiting...");
        final completer = Completer<void>();
        _refreshCompleters.add(completer);
        
        try {
          await completer.future.timeout(const Duration(seconds: 10));
          
          // Try the request again with the new token
          final token = await _storageProvider.getAccessToken();
          if (token != null && token.isNotEmpty) {
            final options = error.requestOptions;
            options.headers['Authorization'] = 'Bearer $token';
            
            try {
              final response = await _dio!.fetch(options);
              return handler.resolve(response);
            } catch (e) {
              debugPrint("   ❌ Retry failed after waiting: $e");
              return handler.next(error);
            }
          }
        } catch (e) {
          debugPrint("   ❌ Timeout waiting for refresh: $e");
        }
        
        return handler.next(error);
      }
      
      _isRefreshing = true;
      
      try {
        // Try to refresh the token
        final refreshToken = await _storageProvider.getRefreshToken();
        
        debugPrint("   Refresh token available: ${refreshToken?.isNotEmpty ?? false}");
        
        if (refreshToken != null && refreshToken.isNotEmpty) {
          try {
            debugPrint("   Attempting to refresh access token...");
            
            // Attempt to refresh the access token
            final newTokens = await _refreshAccessToken(refreshToken);
            
            if (newTokens != null) {
              debugPrint("   ✅ Token refreshed successfully");
              debugPrint("   New access token length: ${newTokens['access_token']?.length}");
              
              // Complete all waiting requests
              for (var completer in _refreshCompleters) {
                if (!completer.isCompleted) {
                  completer.complete();
                }
              }
              _refreshCompleters.clear();
              
              // Retry the original request with new token
              final options = error.requestOptions;
              options.headers['Authorization'] = 'Bearer ${newTokens['access_token']}';
              
              try {
                debugPrint("   Retrying original request...");
                final response = await _dio!.fetch(options);
                _isRefreshing = false;
                debugPrint("   ✅ Original request successful");
                return handler.resolve(response);
              } catch (e) {
                debugPrint("   ❌ Retry failed: $e");
                _isRefreshing = false;
                return handler.next(error);
              }
            } else {
              debugPrint("   ❌ Token refresh returned null");
              _isRefreshing = false;
              
              // Complete waiting requests with failure
              for (var completer in _refreshCompleters) {
                if (!completer.isCompleted) {
                  completer.completeError('Token refresh failed');
                }
              }
              _refreshCompleters.clear();
              
              return handler.next(error);
            }
          } catch (e) {
            debugPrint('   ❌ Token refresh failed: $e');
            _isRefreshing = false;
            
            // Complete waiting requests with failure
            for (var completer in _refreshCompleters) {
              if (!completer.isCompleted) {
                completer.completeError(e);
              }
            }
            _refreshCompleters.clear();
            
            return handler.next(error);
          }
        } else {
          debugPrint("   ⚠️ No refresh token available");
          _isRefreshing = false;
          return handler.next(error);
        }
      } finally {
        _isRefreshing = false;
      }
    }

    handler.next(error);
  }

  /// Refresh access token using refresh token
  Future<Map<String, String>?> _refreshAccessToken(String refreshToken) async {
    try {
      debugPrint('🔄 Starting token refresh...');
      debugPrint('   Refresh token length: ${refreshToken.length}');
      
      // Create a separate Dio instance for refresh to avoid interceptor loops
      final refreshDio = Dio();
      refreshDio.options.baseUrl = 'http://86.62.209.62:8000/';
      refreshDio.options.headers = {"Content-Type": "application/json"};
      refreshDio.options.connectTimeout = const Duration(seconds: 15);
      refreshDio.options.receiveTimeout = const Duration(seconds: 15);
      
      // Create AuthenticationApi instance
      final authApi = AuthenticationApi(refreshDio);
      
      // Call refresh token endpoint
      final response = await authApi.getRefreshToken(
        body: RefreshTokenBody(refresh_token: refreshToken),
      );

      debugPrint('✅ Token refresh API successful');
      debugPrint('   New access token length: ${response.access_token.length}');
      debugPrint('   New refresh token length: ${response.refresh_token.length}');
      debugPrint('   User ID: ${response.user_id}');

      if (response.access_token.isNotEmpty) {
        // Get current user data
        final userId = response.user_id.toString();
        final phone = await _storageProvider.getPhone() ?? '';

        debugPrint('💾 Saving new tokens to storage...');
        debugPrint('   User ID: $userId');
        debugPrint('   Phone: $phone');

        // Save new tokens
        await _storageProvider.saveUserData(
          userId: userId,
          accessToken: response.access_token,
          refreshToken: response.refresh_token,
          phone: phone,
        );
        
        // Verify tokens were saved
        final savedAccessToken = await _storageProvider.getAccessToken();
        final savedRefreshToken = await _storageProvider.getRefreshToken();
        
        debugPrint('✅ Tokens saved to storage');
        debugPrint('   Saved access token length: ${savedAccessToken?.length ?? 0}');
        debugPrint('   Saved refresh token length: ${savedRefreshToken?.length ?? 0}');
        
        // Reset inactivity timer after successful refresh
        _restartInactivityTimer();
        
        return {
          'access_token': response.access_token,
          'refresh_token': response.refresh_token,
        };
      }
      
      debugPrint('❌ Token refresh returned empty access token');
      return null;
    } catch (e, stackTrace) {
      debugPrint('❌ Error refreshing token: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Check if endpoint is public (doesn't need authentication)
  bool _isPublicEndpoint(String path) {
    final publicEndpoints = [
      '/auth/register',
      '/auth/verify-register-otp',
      '/auth/login', 
      '/auth/verify-login-otp',
      '/auth/otp/send',
      '/auth/otp/verify',
      '/auth/refresh-token',
    ];
    
    return publicEndpoints.any((endpoint) => path.contains(endpoint));
  }

  // ==================== Lifecycle Management ====================

  /// Start monitoring user inactivity
  void _startInactivityMonitoring() {
    _lastInteractionTime = DateTime.now();
    _restartInactivityTimer();
    debugPrint('🔒 Inactivity monitoring started (timeout: ${inactivityTimeout.inMinutes} minutes)');
  }

  /// Update last interaction time
  void _updateLastInteraction() {
    _lastInteractionTime = DateTime.now();
  }

  /// Restart the inactivity timer
  void _restartInactivityTimer() {
    _inactivityTimer?.cancel();
    
    if (!enableAutoLogout) {
      return; // Don't start timer if auto-logout is disabled
    }
    
    _inactivityTimer = Timer(inactivityTimeout, () {
      _checkInactivity();
    });
  }

  /// Check if user has been inactive
  void _checkInactivity() {
    if (_lastInteractionTime != null) {
      final inactiveDuration = DateTime.now().difference(_lastInteractionTime!);
      
      if (inactiveDuration >= inactivityTimeout) {
        debugPrint('⏰ User inactive for ${inactiveDuration.inMinutes} minutes (${inactiveDuration.inSeconds} seconds), logging out...');
        _performLogout();
      } else {
        // Restart timer if still within threshold
        debugPrint('⏱️ Inactivity check: ${inactiveDuration.inSeconds}s elapsed, still active');
        _restartInactivityTimer();
      }
    }
  }

  /// Manually trigger user interaction (call from UI gestures)
  void recordUserInteraction() {
    _updateLastInteraction();
    _restartInactivityTimer();
  }

  /// Check if user should be logged out based on time in background
  Future<void> checkBackgroundTimeout(DateTime backgroundStartTime) async {
    final timeInBackground = DateTime.now().difference(backgroundStartTime);
    
    if (timeInBackground >= backgroundTimeout) {
      debugPrint('⏰ App was in background for ${timeInBackground.inMinutes} minutes, logging out...');
      await _performLogout();
    } else {
      debugPrint('✅ App returned from background after ${timeInBackground.inSeconds} seconds (within ${backgroundTimeout.inMinutes} minute limit)');
    }
  }

  /// Pause inactivity monitoring (e.g., when app goes to background)
  void pauseInactivityMonitoring() {
    _inactivityTimer?.cancel();
    debugPrint('⏸️ Inactivity monitoring paused');
  }

  /// Resume inactivity monitoring (e.g., when app comes to foreground)
  void resumeInactivityMonitoring() {
    _lastInteractionTime = DateTime.now();
    _restartInactivityTimer();
    debugPrint('▶️ Inactivity monitoring resumed');
  }

  // ==================== Session Management ====================

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storageProvider.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Perform logout (clear all stored data)
  Future<void> _performLogout() async {
    try {
      debugPrint('🚪 Performing automatic logout...');
      _inactivityTimer?.cancel();
      //await _storageProvider.clearAllData();
      appRouter.replaceAll([SplashRoute()]);
      
      // Emit logout event
      _logoutController.add(null);
      
      debugPrint('✅ User redirected out due to inactivity/timeout');
    } catch (e) {
      debugPrint('❌ Error during logout: $e');
    }
  }

  /// Public method to manually logout
  Future<void> logout() async {
    debugPrint('🚪 Manual logout requested');
    await _performLogout();
  }

  /// Get current user ID
  Future<String?> getUserId() async {
    return await _storageProvider.getUserId();
  }

  /// Get current access token
  Future<String?> getAccessToken() async {
    return await _storageProvider.getAccessToken();
  }

  /// Get last interaction time
  DateTime? get lastInteractionTime => _lastInteractionTime;

  /// Get time until auto-logout
  Duration? getTimeUntilLogout() {
    if (_lastInteractionTime == null || !enableAutoLogout) return null;
    
    final elapsed = DateTime.now().difference(_lastInteractionTime!);
    final remaining = inactivityTimeout - elapsed;
    
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Dispose resources
  void dispose() {
    _inactivityTimer?.cancel();
    _logoutController.close();
  }
}