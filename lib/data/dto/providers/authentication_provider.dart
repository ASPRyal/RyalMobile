import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:ryal_mobile/data/api/authentication_api.dart';
import 'package:ryal_mobile/data/dto/failures/error_parser.dart';
import 'package:ryal_mobile/data/dto/failures/i_failure.dart';
import 'package:ryal_mobile/data/dto/failures/input_fields_failure.dart';
import 'package:ryal_mobile/data/dto/failures/server_failure.dart';
import 'package:ryal_mobile/data/dto/failures/uncaught_failure.dart';
import 'package:ryal_mobile/data/dto/login_body.dart';
import 'package:ryal_mobile/data/dto/login_otp_verify_response.dart';
import 'package:ryal_mobile/data/dto/login_response.dart';
import 'package:ryal_mobile/data/dto/otp_response.dart';
import 'package:ryal_mobile/data/dto/refresh_token_body.dart';
import 'package:ryal_mobile/data/dto/refresh_token_response.dart';
import 'package:ryal_mobile/data/dto/register_otp_verify_body.dart';
import 'package:ryal_mobile/data/dto/register_otp_verify_response.dart';
import 'package:ryal_mobile/data/dto/register_user_body.dart';
import 'package:ryal_mobile/data/dto/register_user_response.dart';
import 'package:ryal_mobile/data/dto/set_mpin_body.dart';
import 'package:ryal_mobile/data/dto/verify_otp_body.dart';

@singleton
class AuthenticationProvider {
  final AuthenticationApi _authApi;

  AuthenticationProvider(this._authApi);

  Future<Either<IFailure, RegisterUserResponse>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String qidNumber,
    String ? mcitNumber,  
    required String  userType,
    required String nationality,
    
  }) async {
    try {
      
      final RegisterUserResponse response = await _authApi.registerUser(
        body: RegisterUserBody(
          name: fullName,
          email: email,
          phone_number: phoneNumber,
          user_type:userType,
          qid: qidNumber,
          mcit_number: mcitNumber,
          nationality: nationality
        ),
      );
   



      return Right(response);
    } on DioException catch (error) {
      // print('ERROR: API Endpoint Called: ${error.requestOptions.method} ${error.requestOptions.uri}');
      // print('Request Headers: ${error.requestOptions.headers}');
      // print('Request Data: ${error.requestOptions.data}');
      // print('Error Type: ${error.type}');
      // print('Error Message: ${error.message}');
      // if (error.response != null) {
      //   print('Response Status: ${error.response?.statusCode}');
      //   print('Response Data: ${error.response?.data}');
      // }
      // print('───────────────────────────────────');
      if (error.type == DioExceptionType.badResponse) {
        if (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500) {
          return Left(ServerFailure());
        }

        final errorResponse = ErrorParser.parseErrorResponse(error);
        
        // Handle specific error codes
        if (error.response?.statusCode == 400) {
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Invalid information provided'),
          );
        }
        
        if (error.response?.statusCode == 409) {
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Email or phone number already exists'),
          );
        }
        
        if (error.response?.statusCode == 422) {
          if (errorResponse?.subErrors.isNotEmpty ?? false) {
            return Left(
              InputFieldsFailure(subErrors: errorResponse!.subErrors),
            );
          }
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Validation error'),
          );
        }

        return Left(UncaughtFailure(message: errorResponse?.errorMessage));
      }
      return Left(ServerFailure(message: error.message));
    }
  }



    Future<Either<IFailure, RegisterOtpVerifyResponse>> verifyRegisterOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      
      final RegisterOtpVerifyResponse response = await _authApi.verifyRegisterOtp(
        body: RegisterOTPVerifyBody(
          phone_number: phoneNumber,
          otp: otp,
        ),
      );

      return Right(response);
    } on DioException catch (error) {

      if (error.type == DioExceptionType.badResponse) {
        if (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500) {
          return Left(ServerFailure());
        }

        final errorResponse = ErrorParser.parseErrorResponse(error);
        
        // Handle specific error codes
        if (error.response?.statusCode == 400) {
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Invalid information provided'),
          );
        }
        
        if (error.response?.statusCode == 409) {
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Email or phone number already exists'),
          );
        }
        
        if (error.response?.statusCode == 422) {
          if (errorResponse?.subErrors.isNotEmpty ?? false) {
            return Left(
              InputFieldsFailure(subErrors: errorResponse!.subErrors),
            );
          }
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Validation error'),
          );
        }

        return Left(UncaughtFailure(message: errorResponse?.errorMessage));
      }
      return Left(ServerFailure(message: error.message));
    }
  }
 Future<Either<IFailure, LoginOtpVerifyResponse>> verifyLoginOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      
      final LoginOtpVerifyResponse response = await _authApi.verifyLoginOtp(
        body: RegisterOTPVerifyBody(
          phone_number: phoneNumber,
          otp: otp,
        ),
      );

      return Right(response);
    } on DioException catch (error) {

      if (error.type == DioExceptionType.badResponse) {
        if (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500) {
          return Left(ServerFailure());
        }

        final errorResponse = ErrorParser.parseErrorResponse(error);
        
        // Handle specific error codes
        if (error.response?.statusCode == 400) {
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Invalid information provided'),
          );
        }
        
        if (error.response?.statusCode == 409) {
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Email or phone number already exists'),
          );
        }
        
        if (error.response?.statusCode == 422) {
          if (errorResponse?.subErrors.isNotEmpty ?? false) {
            return Left(
              InputFieldsFailure(subErrors: errorResponse!.subErrors),
            );
          }
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Validation error'),
          );
        }

        return Left(UncaughtFailure(message: errorResponse?.errorMessage));
      }
      return Left(ServerFailure(message: error.message));
    }
  }
 Future<Either<IFailure, LoginOtpVerifyResponse>> mpinLogin({
    required String mpin
  }) async {
    try {
      
      final LoginOtpVerifyResponse response = await _authApi.mpinLogin(
        body: SetMpinBody(
          mpin: mpin,
        ),
      );

      return Right(response);
    } on DioException catch (error) {

      if (error.type == DioExceptionType.badResponse) {
        if (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500) {
          return Left(ServerFailure());
        }

        final errorResponse = ErrorParser.parseErrorResponse(error);
        
        // Handle specific error codes
        if (error.response?.statusCode == 400) {
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Invalid information provided'),
          );
        }
        
        if (error.response?.statusCode == 409) {
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Email or phone number already exists'),
          );
        }
        
        if (error.response?.statusCode == 422) {
          if (errorResponse?.subErrors.isNotEmpty ?? false) {
            return Left(
              InputFieldsFailure(subErrors: errorResponse!.subErrors),
            );
          }
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Validation error'),
          );
        }

        return Left(UncaughtFailure(message: errorResponse?.errorMessage));
      }
      return Left(ServerFailure(message: error.message));
    }
  }

 Future<Either<IFailure, OtpResponse>> sendOtp({
    required String phoneNumber,
  }) async {
    try {
      
      final OtpResponse response = await _authApi.sendOtp(
        body:LoginBody(
          phone_number: phoneNumber,
        ),
      );

      return Right(response);
    } on DioException catch (error) {

      if (error.type == DioExceptionType.badResponse) {
        if (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500) {
          return Left(ServerFailure());
        }

        final errorResponse = ErrorParser.parseErrorResponse(error);
        
        // Handle specific error codes
        if (error.response?.statusCode == 400) {
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Invalid information provided'),
          );
        }
        
        if (error.response?.statusCode == 409) {
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Email or phone number already exists'),
          );
        }
        
        if (error.response?.statusCode == 422) {
          if (errorResponse?.subErrors.isNotEmpty ?? false) {
            return Left(
              InputFieldsFailure(subErrors: errorResponse!.subErrors),
            );
          }
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Validation error'),
          );
        }

        return Left(UncaughtFailure(message: errorResponse?.errorMessage));
      }
      return Left(ServerFailure(message: error.message));
    }
  }
 Future<Either<IFailure, OtpResponse>> verifyOtp({
    required String phoneNumber,
    required String otp,

  }) async {
    try {
      
      final OtpResponse response = await _authApi.verifyOtp(body:   VerifyOtpBody(
          phone_number: phoneNumber,
          otp: otp,
        ),
      );

      return Right(response);
    } on DioException catch (error) {

      if (error.type == DioExceptionType.badResponse) {
        if (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500) {
          return Left(ServerFailure());
        }

        final errorResponse = ErrorParser.parseErrorResponse(error);
        
        // Handle specific error codes
        if (error.response?.statusCode == 400) {
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Invalid information provided'),
          );
        }
        
        if (error.response?.statusCode == 409) {
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Email or phone number already exists'),
          );
        }
        
        if (error.response?.statusCode == 422) {
          if (errorResponse?.subErrors.isNotEmpty ?? false) {
            return Left(
              InputFieldsFailure(subErrors: errorResponse!.subErrors),
            );
          }
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Validation error'),
          );
        }

        return Left(UncaughtFailure(message: errorResponse?.errorMessage));
      }
      return Left(ServerFailure(message: error.message));
    }
  }
      Future<Either<IFailure, RefreshTokenResponse>> getRefreshToken({
    required String refreshToken,
  }) async {
    try {
      
      final RefreshTokenResponse response = await _authApi.getRefreshToken(
        body:RefreshTokenBody(  
          refresh_token: refreshToken,
        ),
      );

      return Right(response);
    } on DioException catch (error) {

      if (error.type == DioExceptionType.badResponse) {
        if (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500) {
          return Left(ServerFailure());
        }

        final errorResponse = ErrorParser.parseErrorResponse(error);
        
        // Handle specific error codes
        if (error.response?.statusCode == 400) {
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Invalid information provided'),
          );
        }
        
        if (error.response?.statusCode == 409) {
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Email or phone number already exists'),
          );
        }
        
        if (error.response?.statusCode == 422) {
          if (errorResponse?.subErrors.isNotEmpty ?? false) {
            return Left(
              InputFieldsFailure(subErrors: errorResponse!.subErrors),
            );
          }
          return Left(
            UncaughtFailure(message: errorResponse?.errorMessage ?? 'Validation error'),
          );
        }

        return Left(UncaughtFailure(message: errorResponse?.errorMessage));
      }
      return Left(ServerFailure(message: error.message));
    }
  }


Future<Either<IFailure, LoginResponse>> login({
  required String phoneNumber,
}) async {
  try {
    final LoginResponse response = await _authApi.login(
      body: LoginBody(
        phone_number: phoneNumber,
      ),
    );

    return Right(response);
  } on DioException catch (error) {
    if (error.type == DioExceptionType.badResponse) {
      // Handle 500+ server errors
      if (error.response?.statusCode != null &&
          error.response!.statusCode! >= 500) {
        return Left(ServerFailure());
      }

      // Handle 404 - User not found (SPECIFIC HANDLING)
      if (error.response?.statusCode == 404) {
        // Try to parse the nested detail
        String errorMessage = 'User not found';
        
        try {
          final responseData = error.response?.data;
          if (responseData is Map<String, dynamic>) {
            final detail = responseData['detail'];
            
            if (detail is String) {
              // If detail is a JSON string, try to parse it
              try {
                final parsed = jsonDecode(detail);
                if (parsed is Map && parsed.containsKey('detail')) {
                  errorMessage = parsed['detail'];
                }
              } catch (_) {
                // If parsing fails, use the string as is
                errorMessage = detail;
              }
            } else if (detail is Map) {
              errorMessage = detail['detail'] ?? 'User not found';
            }
          }
        } catch (_) {
          // If any parsing fails, use default message
          errorMessage = 'User not found';
        }

        return Left(
          UncaughtFailure(message: errorMessage),
        );
      }

      // Parse error response for other status codes
      final errorResponse = ErrorParser.parseErrorResponse(error);
      
      // Handle 400 - Bad Request
      if (error.response?.statusCode == 400) {
        return Left(
          UncaughtFailure(message: errorResponse?.errorMessage ?? 'Invalid information provided'),
        );
      }
      
      // Handle 409 - Conflict
      if (error.response?.statusCode == 409) {
        return Left(
          UncaughtFailure(message: errorResponse?.errorMessage ?? 'Email or phone number already exists'),
        );
      }
      
      // Handle 422 - Validation Error
      if (error.response?.statusCode == 422) {
        if (errorResponse?.subErrors.isNotEmpty ?? false) {
          return Left(
            InputFieldsFailure(subErrors: errorResponse!.subErrors),
          );
        }
        return Left(
          UncaughtFailure(message: errorResponse?.errorMessage ?? 'Validation error'),
        );
      }

      // Handle any other error codes
      return Left(UncaughtFailure(message: errorResponse?.errorMessage));
    }
    
    // Handle connection errors, timeouts, etc.
    return Left(ServerFailure(message: error.message));
  }
}
}