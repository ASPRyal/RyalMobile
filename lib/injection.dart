import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:ryal_mobile/core/build_config.dart';
import 'package:ryal_mobile/core/build_config_dev.dart';
import 'package:ryal_mobile/injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
void configureInjection(String env) {
    // First: Initialize injectable dependencies
    getIt.init(environment: env);
    
    // Then: Add manual registrations
    getIt.registerLazySingleton<BuildConfig>(() => getEnv(env));
}

BuildConfig getEnv(String env) {
  switch (env) {
    case "dev":
      return BuildConfigDev();
    // case "test":
    //   return BuildConfigDev();
    // case "prod":
    //   return BuildConfigProd();
    default:
      return BuildConfigDev();
  }
}