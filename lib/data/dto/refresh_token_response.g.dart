// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshTokenResponse _$RefreshTokenResponseFromJson(
  Map<String, dynamic> json,
) => RefreshTokenResponse(
  access_token: json['access_token'] as String,
  refresh_token: json['refresh_token'] as String,
  token_type: json['token_type'] as String,
  user_id: json['user_id'] as String,
  user_type: json['user_type'] as String,
);

Map<String, dynamic> _$RefreshTokenResponseToJson(
  RefreshTokenResponse instance,
) => <String, dynamic>{
  'access_token': instance.access_token,
  'refresh_token': instance.refresh_token,
  'token_type': instance.token_type,
  'user_id': instance.user_id,
  'user_type': instance.user_type,
};
