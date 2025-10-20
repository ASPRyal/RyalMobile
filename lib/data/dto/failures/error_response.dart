import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ryal_mobile/data/dto/failures/sub_error_response.dart';


part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse extends Equatable {
  final int httpStatus;
  final String internalCode;
  final String errorMessage;
  final String traceId;
  final List<SubErrorResponse> subErrors;

  const ErrorResponse({
    required this.httpStatus,
    required this.internalCode,
    required this.errorMessage,
    required this.traceId,
    required this.subErrors,
  });

  @override
  List<Object> get props => [
        httpStatus,
        internalCode,
        errorMessage,
        traceId,
        subErrors,
      ];

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}
