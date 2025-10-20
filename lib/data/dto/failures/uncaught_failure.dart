
import 'package:ryal_mobile/data/dto/failures/i_failure.dart';

class UncaughtFailure extends IFailure {
  UncaughtFailure({
    String? message = 'Uncaught Error',
  }) : super(message: message ?? '');

  UncaughtFailure.withCode({
    int? code,
    String? message = 'Uncaught Error',
  }) : super(message: '$message ${code ?? ''}');
}
