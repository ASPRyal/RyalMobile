// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_otp_verify_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginOtpVerifyResponse _$LoginOtpVerifyResponseFromJson(
  Map<String, dynamic> json,
) => LoginOtpVerifyResponse(
  access_token: json['access_token'] as String,
  refresh_token: json['refresh_token'] as String,
  token_type: json['token_type'] as String,
  user_type: json['user_type'] as String,
  user_id: (json['user_id'] as num).toInt(),
);

Map<String, dynamic> _$LoginOtpVerifyResponseToJson(
  LoginOtpVerifyResponse instance,
) => <String, dynamic>{
  'access_token': instance.access_token,
  'refresh_token': instance.refresh_token,
  'token_type': instance.token_type,
  'user_type': instance.user_type,
  'user_id': instance.user_id,
};
