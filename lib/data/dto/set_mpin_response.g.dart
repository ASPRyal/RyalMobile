// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_mpin_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetMpinResponse _$SetMpinResponseFromJson(Map<String, dynamic> json) =>
    SetMpinResponse(
      message: json['message'] as String,
      user_id: (json['user_id'] as num).toInt(),
      is_mpin: json['is_mpin'] as bool,
    );

Map<String, dynamic> _$SetMpinResponseToJson(SetMpinResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user_id': instance.user_id,
      'is_mpin': instance.is_mpin,
    };
