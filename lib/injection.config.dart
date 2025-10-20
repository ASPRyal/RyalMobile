// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:ryal_mobile/data/api/authentication_api.dart' as _i1058;
import 'package:ryal_mobile/data/api/user_api.dart' as _i360;
import 'package:ryal_mobile/data/dto/providers/authentication_provider.dart'
    as _i116;
import 'package:ryal_mobile/data/dto/providers/user_provider.dart' as _i492;
import 'package:ryal_mobile/data/dto/services/i_authentication_service.dart'
    as _i288;
import 'package:ryal_mobile/data/dto/services/i_user_service.dart' as _i1047;
import 'package:ryal_mobile/data/dto/services/impl/authentication_service_impl.dart'
    as _i114;
import 'package:ryal_mobile/data/dto/services/impl/user_service_impl.dart'
    as _i479;
import 'package:ryal_mobile/injectable_api_module.dart' as _i919;
import 'package:ryal_mobile/network_service.dart' as _i241;
import 'package:ryal_mobile/services/connection_service_impl.dart' as _i683;
import 'package:ryal_mobile/services/i_connection_service.dart' as _i856;
import 'package:ryal_mobile/services/providers/i_local_storage_provider.dart'
    as _i891;
import 'package:ryal_mobile/services/providers/local_security_storage_provider_impl.dart'
    as _i17;
import 'package:ryal_mobile/services/storages/i_storage_service.dart' as _i443;
import 'package:ryal_mobile/services/storages/storage_service_impl.dart'
    as _i491;
import 'package:ryal_mobile/state/register/register_cubit.dart' as _i518;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectableApiModule = _$InjectableApiModule();
    gh.lazySingleton<_i856.IConnectionService>(
      () => _i683.ConnectionServiceImpl(),
    );
    gh.factoryParam<
      _i891.ILocalStorageProvider,
      _i558.FlutterSecureStorage?,
      dynamic
    >((storage, _) => _i17.LocalSecurityStorageProviderImpl(storage));
    gh.lazySingleton<_i241.NetworkService>(
      () => _i241.NetworkService(gh<_i891.ILocalStorageProvider>()),
    );
    gh.factory<_i443.IStorageService>(
      () => _i491.StorageServiceImpl(
        localProvider: gh<_i891.ILocalStorageProvider>(),
      ),
    );
    gh.factory<_i360.UserApi>(
      () => injectableApiModule.user1Api(gh<_i241.NetworkService>()),
    );
    gh.singleton<_i1058.AuthenticationApi>(
      () => injectableApiModule.userApi(gh<_i241.NetworkService>()),
    );
    gh.singleton<_i492.UserProvider>(
      () => _i492.UserProvider(gh<_i360.UserApi>()),
    );
    gh.singleton<_i116.AuthenticationProvider>(
      () => _i116.AuthenticationProvider(gh<_i1058.AuthenticationApi>()),
    );
    gh.factory<_i1047.IUserService>(
      () => _i479.UserServiceImpl(gh<_i492.UserProvider>()),
    );
    gh.factory<_i288.IAuthenticationService>(
      () => _i114.AuthenticationServiceImpl(gh<_i116.AuthenticationProvider>()),
    );
    gh.factory<_i518.RegisterCubit>(
      () => _i518.RegisterCubit(
        gh<_i288.IAuthenticationService>(),
        gh<_i891.ILocalStorageProvider>(),
        gh<_i1047.IUserService>(),
      ),
    );
    return this;
  }
}

class _$InjectableApiModule extends _i919.InjectableApiModule {}
