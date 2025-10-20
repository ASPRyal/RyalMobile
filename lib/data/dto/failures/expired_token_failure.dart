
import 'package:ryal_mobile/data/dto/failures/i_failure.dart';

class ExpiredTokenFailure extends IFailure {
  ExpiredTokenFailure(
    String? message,
  ) : super(message: message ?? 'Expired Token');
}
