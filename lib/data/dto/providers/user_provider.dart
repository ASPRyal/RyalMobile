import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:ryal_mobile/data/api/user_api.dart';
import 'package:ryal_mobile/data/dto/failures/error_parser.dart';
import 'package:ryal_mobile/data/dto/failures/i_failure.dart';
import 'package:ryal_mobile/data/dto/failures/input_fields_failure.dart';
import 'package:ryal_mobile/data/dto/failures/server_failure.dart';
import 'package:ryal_mobile/data/dto/failures/uncaught_failure.dart';
import 'package:ryal_mobile/data/dto/get_user_profile_response.dart';

import 'package:ryal_mobile/data/dto/set_mpin_body.dart';
import 'package:ryal_mobile/data/dto/set_mpin_response.dart';
import 'package:ryal_mobile/data/dto/update_status_body.dart';

@singleton
class UserProvider {
  final UserApi _userApi;

  UserProvider(this._userApi);

  Future<Either<IFailure, SetMpinResponse>> setMpin({
    required String mpin,
    required int userId,
  }) async {
    try {
      
      final SetMpinResponse response = await _userApi.setMpin(
        userId: userId,
        body: SetMpinBody(
          mpin: mpin,
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

  Future<Either<IFailure, GetUserProfileResponse>>getUserProfile() async {
    try {
      
      final GetUserProfileResponse response = await _userApi.getUserProfile();
   



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

  Future<Either<IFailure, GetUserProfileResponse>>updateStatus({
  bool? is_email_verified,
 bool? is_phone_number_verified,
   bool? is_biometric_verified,
 bool? is_kyc_verified
  }) async {
    try {
      
      final GetUserProfileResponse response = await _userApi.updateStatus(  
        body: UpdateStatusBody(
          is_email_verified: is_email_verified,
          is_phone_verified: is_phone_number_verified,
          is_biometric_verified: is_biometric_verified,
          is_kyc_verified: is_kyc_verified
          

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

}