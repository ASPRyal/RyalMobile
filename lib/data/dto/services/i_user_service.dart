import 'package:dartz/dartz.dart';
import 'package:ryal_mobile/data/dto/failures/i_failure.dart';
import 'package:ryal_mobile/data/dto/get_user_profile_response.dart';
import 'package:ryal_mobile/data/dto/set_mpin_response.dart';

abstract class IUserService {
  const IUserService();


 Future<Either<IFailure, SetMpinResponse>>  setMpin ({

    required String mpin,
    required int userId,
  });
 Future<Either<IFailure, GetUserProfileResponse>>  getUserProfile ();
  Future<Either<IFailure, GetUserProfileResponse>> updateStatus (
    {bool? is_email_verified,
    bool? is_phone_verified,
    bool? is_biometric_verified,
    bool? is_kyc_verified}
  );
}