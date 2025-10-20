// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_status_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateStatusBody _$UpdateStatusBodyFromJson(Map<String, dynamic> json) =>
    UpdateStatusBody(
      is_email_verified: json['is_email_verified'] as bool?,
      is_phone_verified: json['is_phone_verified'] as bool?,
      is_kyc_verified: json['is_kyc_verified'] as bool?,
      is_biometric_verified: json['is_biometric_verified'] as bool?,
    );

Map<String, dynamic> _$UpdateStatusBodyToJson(UpdateStatusBody instance) =>
    <String, dynamic>{
      'is_email_verified': instance.is_email_verified,
      'is_phone_verified': instance.is_phone_verified,
      'is_kyc_verified': instance.is_kyc_verified,
      'is_biometric_verified': instance.is_biometric_verified,
    };
