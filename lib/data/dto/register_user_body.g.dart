// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_user_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterUserBody _$RegisterUserBodyFromJson(Map<String, dynamic> json) =>
    RegisterUserBody(
      name: json['name'] as String,
      email: json['email'] as String,
      phone_number: json['phone_number'] as String,
      user_type: json['user_type'] as String,
      qid: json['qid'] as String,
      nationality: json['nationality'] as String,
      mcit_number: json['mcit_number'] as String?,
    );

Map<String, dynamic> _$RegisterUserBodyToJson(RegisterUserBody instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone_number': instance.phone_number,
      'user_type': instance.user_type,
      'nationality': instance.nationality,
      'qid': instance.qid,
      'mcit_number': instance.mcit_number,
    };
