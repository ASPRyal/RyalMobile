
import 'package:ryal_mobile/data/dto/failures/i_failure.dart';
import 'package:ryal_mobile/data/dto/failures/sub_error_response.dart';

class InputFieldsFailure extends IFailure {
  InputFieldsFailure({
    String? message,
    this.subErrors,
  }) : super(message: message ?? 'Input fields contain errors');
  final List<SubErrorResponse>? subErrors;
}
