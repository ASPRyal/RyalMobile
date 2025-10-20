import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
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

part 'authentication_api.g.dart';

@RestApi()
abstract class AuthenticationApi {
  factory AuthenticationApi(
    Dio dio, {
    String baseUrl,
  }) = _AuthenticationApi;

  @POST('auth/register')
  Future<RegisterUserResponse> registerUser({
    @Body() required RegisterUserBody body,
  });

    @POST('auth/verify-register-otp')
  Future<RegisterOtpVerifyResponse> verifyRegisterOtp({
    @Body() required RegisterOTPVerifyBody body,
  });
      @POST('auth/verify-login-otp')
  Future<LoginOtpVerifyResponse> verifyLoginOtp({
    @Body() required RegisterOTPVerifyBody body,
  });

  @POST('auth/login')
  Future<LoginResponse> login({
    @Body() required LoginBody body,
  });

   @POST('auth/login/mpin')
  Future<LoginOtpVerifyResponse> mpinLogin({
    @Body() required SetMpinBody body,
  });
 @POST('auth/otp/send')
  Future<OtpResponse> sendOtp({
    @Body() required LoginBody body,
  });
 @POST('auth/otp/verify')
  Future<OtpResponse> verifyOtp({
    @Body() required VerifyOtpBody body,
  });

   @POST('auth/refresh-token')
  Future<RefreshTokenResponse> getRefreshToken({
    @Body() required RefreshTokenBody body  ,
  });
 }


