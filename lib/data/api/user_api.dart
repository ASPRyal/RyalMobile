import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ryal_mobile/data/dto/get_user_profile_response.dart';
import 'package:ryal_mobile/data/dto/login_response.dart';
import 'package:ryal_mobile/data/dto/set_mpin_body.dart';
import 'package:ryal_mobile/data/dto/set_mpin_response.dart';
import 'package:ryal_mobile/data/dto/update_status_body.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(
    Dio dio, {
    String baseUrl,
  }) = _UserApi;



      @PUT('auth/users/{user_Id}/statuses')
  Future<GetUserProfileResponse> updateStatus({
    @Body() required UpdateStatusBody body,
  });

      @PUT('auth/users/{user_id}/set-mpin')
  Future<SetMpinResponse> setMpin({
    @Body() required SetMpinBody body,
    @Path('user_id') required int userId,
  });


      @GET('auth/me')
  Future<GetUserProfileResponse> getUserProfile(
  );
 }

