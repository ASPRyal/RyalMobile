// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(
      httpStatus: (json['httpStatus'] as num).toInt(),
      internalCode: json['internalCode'] as String,
      errorMessage: json['errorMessage'] as String,
      traceId: json['traceId'] as String,
      subErrors: (json['subErrors'] as List<dynamic>)
          .map((e) => SubErrorResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'httpStatus': instance.httpStatus,
      'internalCode': instance.internalCode,
      'errorMessage': instance.errorMessage,
      'traceId': instance.traceId,
      'subErrors': instance.subErrors,
    };
