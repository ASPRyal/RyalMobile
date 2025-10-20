// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'login_otp_verify_response.g.dart';

@JsonSerializable()
class LoginOtpVerifyResponse {
  const LoginOtpVerifyResponse({
    required this.access_token,
    required this.refresh_token,
    required this.token_type,
    required this.user_type,
    required this.user_id,



  });

  final String access_token;
  final String refresh_token;
  final String token_type;
  final String user_type;
  final int user_id;



  factory LoginOtpVerifyResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginOtpVerifyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginOtpVerifyResponseToJson(this);
}


