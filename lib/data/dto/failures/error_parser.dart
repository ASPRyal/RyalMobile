import 'package:dio/dio.dart';
import 'package:ryal_mobile/data/dto/failures/error_response.dart';

class ErrorParser {
  ErrorParser._();

  static ErrorResponse? parseErrorResponse(DioException error) {
    try {
      final dynamic object = error.response?.data;
      final response = ErrorResponse.fromJson(object as Map<String, dynamic>);
      return response;
    } catch (_) {
      return null;
    }
  }
}
