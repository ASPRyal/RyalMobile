// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubErrorResponse _$SubErrorResponseFromJson(Map<String, dynamic> json) =>
    SubErrorResponse(
      objectName: json['objectName'] as String,
      fieldName: json['fieldName'] as String,
      rejectedValue: json['rejectedValue'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$SubErrorResponseToJson(SubErrorResponse instance) =>
    <String, dynamic>{
      'objectName': instance.objectName,
      'fieldName': instance.fieldName,
      'rejectedValue': instance.rejectedValue,
      'message': instance.message,
    };
