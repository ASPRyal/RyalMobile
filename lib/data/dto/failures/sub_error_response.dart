import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sub_error_response.g.dart';

@JsonSerializable()
class SubErrorResponse extends Equatable {
  final String objectName;
  final String fieldName;
  final String rejectedValue;
  final String message;

  const SubErrorResponse({
    required this.objectName,
    required this.fieldName,
    required this.rejectedValue,
    required this.message,
  });

  @override
  List<Object> get props => [objectName, fieldName, rejectedValue, message];

  factory SubErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$SubErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubErrorResponseToJson(this);
}
