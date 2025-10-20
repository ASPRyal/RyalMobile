import 'package:injectable/injectable.dart';
import 'package:ryal_mobile/data/api/authentication_api.dart';
import 'package:ryal_mobile/data/api/user_api.dart';
import 'package:ryal_mobile/network_service.dart';

@module
abstract class InjectableApiModule {
  @singleton
  AuthenticationApi userApi(NetworkService networkService) => AuthenticationApi(
        networkService.dio,
        baseUrl: networkService.dio.options.baseUrl,
      );
       UserApi user1Api(NetworkService networkService) =>  UserApi(
        networkService.dio,
        baseUrl: networkService.dio.options.baseUrl,
      );
}