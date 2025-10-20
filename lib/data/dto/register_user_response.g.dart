// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterUserResponse _$RegisterUserResponseFromJson(
  Map<String, dynamic> json,
) => RegisterUserResponse(
  message: json['message'] as String,
  phone_number: json['phone_number'] as String,
);

Map<String, dynamic> _$RegisterUserResponseToJson(
  RegisterUserResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'phone_number': instance.phone_number,
};
