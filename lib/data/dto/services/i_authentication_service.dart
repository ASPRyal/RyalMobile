import 'package:dartz/dartz.dart';
import 'package:ryal_mobile/data/dto/failures/i_failure.dart';
import 'package:ryal_mobile/data/dto/login_otp_verify_response.dart';
import 'package:ryal_mobile/data/dto/login_response.dart';
import 'package:ryal_mobile/data/dto/otp_response.dart';
import 'package:ryal_mobile/data/dto/refresh_token_response.dart';
import 'package:ryal_mobile/data/dto/register_otp_verify_response.dart';
import 'package:ryal_mobile/data/dto/register_user_response.dart';

abstract class IAuthenticationService {
  const IAuthenticationService();

  Future<Either<IFailure, RegisterUserResponse>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String qidNumber,
   String ? mcitNumber,
  required   String nationality,
  required  String userType,
  });
 Future<Either<IFailure, RegisterOtpVerifyResponse>>  verifyRegisterOtp ({

    required String phoneNumber,
    required String otp
  });


   Future<Either<IFailure, RefreshTokenResponse>>  getRefreshToken ({

    required String refreshToken,
  });

     Future<Either<IFailure, OtpResponse>>  sendOtp ({

    required String phoneNumber,
  });

     Future<Either<IFailure, OtpResponse>>  verifyOtp ({


    required String phoneNumber,
    required String otp
  });
   Future<Either<IFailure, LoginOtpVerifyResponse>>  verifyLoginOtp ({

    required String phoneNumber,
    required String otp
  });

     Future<Either<IFailure, LoginOtpVerifyResponse>>  mpinLogin ({

    required String mpin
  });
 Future<Either<IFailure, LoginResponse>>  login ({

    required String phoneNumber,
  });
}