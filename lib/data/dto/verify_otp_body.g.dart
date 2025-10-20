// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpBody _$VerifyOtpBodyFromJson(Map<String, dynamic> json) =>
    VerifyOtpBody(
      phone_number: json['phone_number'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$VerifyOtpBodyToJson(VerifyOtpBody instance) =>
    <String, dynamic>{
      'phone_number': instance.phone_number,
      'otp': instance.otp,
    };
