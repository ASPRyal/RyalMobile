// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_otp_verify_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterOTPVerifyBody _$RegisterOTPVerifyBodyFromJson(
  Map<String, dynamic> json,
) => RegisterOTPVerifyBody(
  phone_number: json['phone_number'] as String,
  otp: json['otp'] as String,
);

Map<String, dynamic> _$RegisterOTPVerifyBodyToJson(
  RegisterOTPVerifyBody instance,
) => <String, dynamic>{
  'phone_number': instance.phone_number,
  'otp': instance.otp,
};
