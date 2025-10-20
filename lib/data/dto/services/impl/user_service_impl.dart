import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ryal_mobile/data/dto/failures/i_failure.dart';
import 'package:ryal_mobile/data/dto/get_user_profile_response.dart';
import 'package:ryal_mobile/data/dto/providers/user_provider.dart';
import 'package:ryal_mobile/data/dto/services/i_user_service.dart';
import 'package:ryal_mobile/data/dto/set_mpin_response.dart';

@Injectable(as: IUserService)
class UserServiceImpl extends IUserService {
  final UserProvider _userProvider;

  const UserServiceImpl(this._userProvider);

  @override
  Future<Either<IFailure, SetMpinResponse>> setMpin({
    required String mpin,
    required int userId,

  }) async {
    final result = await _userProvider.setMpin(
      userId: userId,
     mpin: mpin
    );
    

    return result;
  }


  @override
  Future<Either<IFailure, GetUserProfileResponse>> getUserProfile() async {
    final result = await _userProvider.getUserProfile(
    
    );
    

    return result;
  }
    @override
  Future<Either<IFailure, GetUserProfileResponse>> updateStatus({bool? is_biometric_verified,bool ? is_email_verified, bool ? is_kyc_verified,bool ? is_phone_verified}) async {
    final result = await _userProvider.updateStatus(
      is_biometric_verified: is_biometric_verified,
      is_email_verified: is_email_verified,
      is_kyc_verified: is_kyc_verified,
      is_phone_number_verified: is_phone_verified
    
    );
    

    return result;
  }
   

  
}