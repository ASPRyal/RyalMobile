// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserProfileResponse _$GetUserProfileResponseFromJson(
  Map<String, dynamic> json,
) => GetUserProfileResponse(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  phone_number: json['phone_number'] as String,
  user_type: json['user_type'] as String,
  qid: json['qid'] as String?,
  mcit_number: json['mcit_number'] as String?,
  nationality: json['nationality'] as String,
  lang: json['lang'] as String,
  is_active: json['is_active'] as bool,
  is_email_verified: json['is_email_verified'] as bool,
  is_phone_verified: json['is_phone_verified'] as bool,
  is_kyc_verified: json['is_kyc_verified'] as bool,
  is_biometric_verified: json['is_biometric_verified'] as bool,
  is_mpin: json['is_mpin'] as bool,
  kyc_status: json['kyc_status'] as String,
  created_on: json['created_on'] as String,
  updated_on: json['updated_on'] as String,
);

Map<String, dynamic> _$GetUserProfileResponseToJson(
  GetUserProfileResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone_number': instance.phone_number,
  'user_type': instance.user_type,
  'qid': instance.qid,
  'mcit_number': instance.mcit_number,
  'nationality': instance.nationality,
  'lang': instance.lang,
  'is_active': instance.is_active,
  'is_email_verified': instance.is_email_verified,
  'is_phone_verified': instance.is_phone_verified,
  'is_kyc_verified': instance.is_kyc_verified,
  'is_biometric_verified': instance.is_biometric_verified,
  'is_mpin': instance.is_mpin,
  'kyc_status': instance.kyc_status,
  'created_on': instance.created_on,
  'updated_on': instance.updated_on,
};
