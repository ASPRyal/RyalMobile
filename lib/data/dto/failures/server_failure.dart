
import 'package:ryal_mobile/data/dto/failures/i_failure.dart';

class ServerFailure extends IFailure {
  ServerFailure({
    super.message = 'Server error',
  });
}
