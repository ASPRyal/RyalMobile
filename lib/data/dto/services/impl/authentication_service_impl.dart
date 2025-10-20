import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ryal_mobile/data/dto/failures/i_failure.dart';
import 'package:ryal_mobile/data/dto/login_otp_verify_response.dart';
import 'package:ryal_mobile/data/dto/login_response.dart';
import 'package:ryal_mobile/data/dto/otp_response.dart';
import 'package:ryal_mobile/data/dto/providers/authentication_provider.dart';
import 'package:ryal_mobile/data/dto/refresh_token_response.dart';
import 'package:ryal_mobile/data/dto/register_otp_verify_response.dart';
import 'package:ryal_mobile/data/dto/register_user_response.dart';
import 'package:ryal_mobile/data/dto/services/i_authentication_service.dart';

@Injectable(as: IAuthenticationService)
class AuthenticationServiceImpl extends IAuthenticationService {
  final AuthenticationProvider _authProvider;

  const AuthenticationServiceImpl(this._authProvider);

  @override
  Future<Either<IFailure, RegisterUserResponse>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String qidNumber,
  String ? mcitNumber,
  required   String userType,
  required   String nationality,


  }) async {
    final result = await _authProvider.register(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      qidNumber: qidNumber,
      mcitNumber: mcitNumber, 
      userType: userType,
      nationality: nationality,
    );
    
    // The provider already returns Either<IFailure, RegisterUserResponse>
    // so we can return it directly
    return result;
  }


    @override
  Future<Either<IFailure, RegisterOtpVerifyResponse>> verifyRegisterOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final result = await _authProvider.verifyRegisterOtp(phoneNumber: phoneNumber, otp: otp);
    

    return result;
  }


   @override
  Future<Either<IFailure, RefreshTokenResponse>> getRefreshToken({
    required String refreshToken
  }) async {
    final result = await _authProvider.getRefreshToken(refreshToken: refreshToken);
    

    return result;
  }

  @override
  Future<Either<IFailure, OtpResponse>> sendOtp({
    required String phoneNumber,
  }) async {
    final result = await _authProvider.sendOtp(phoneNumber: phoneNumber);
    

    return result;
  }

  @override
  Future<Either<IFailure,OtpResponse>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final result = await _authProvider.verifyOtp(phoneNumber: phoneNumber, otp: otp);
    

    return result;
  }
    @override
  Future<Either<IFailure, LoginOtpVerifyResponse>> verifyLoginOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final result = await _authProvider.verifyLoginOtp(phoneNumber: phoneNumber, otp: otp);
    

    return result;
  }

      @override
  Future<Either<IFailure, LoginOtpVerifyResponse>> mpinLogin({
    required String mpin
  }) async {
    final result = await _authProvider.mpinLogin(mpin: mpin);
    

    return result;
  }
    @override
  Future<Either<IFailure, LoginResponse>> login({
    required String phoneNumber,
  }) async {
    final result = await _authProvider.login(phoneNumber: phoneNumber );
    

    return result;
  }

  
}