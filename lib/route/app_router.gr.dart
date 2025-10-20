// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AuthSelectionScreen]
class AuthSelectionRoute extends PageRouteInfo<void> {
  const AuthSelectionRoute({List<PageRouteInfo>? children})
    : super(AuthSelectionRoute.name, initialChildren: children);

  static const String name = 'AuthSelectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthSelectionScreen();
    },
  );
}

/// generated route for
/// [BiometricVerificationScreen]
class BiometricVerificationRoute extends PageRouteInfo<void> {
  const BiometricVerificationRoute({List<PageRouteInfo>? children})
    : super(BiometricVerificationRoute.name, initialChildren: children);

  static const String name = 'BiometricVerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BiometricVerificationScreen();
    },
  );
}

/// generated route for
/// [KycVerificationScreen]
class KycVerificationRoute extends PageRouteInfo<void> {
  const KycVerificationRoute({List<PageRouteInfo>? children})
    : super(KycVerificationRoute.name, initialChildren: children);

  static const String name = 'KycVerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const KycVerificationScreen();
    },
  );
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [MpinBioLoginScreen]
class MpinBioLoginRoute extends PageRouteInfo<void> {
  const MpinBioLoginRoute({List<PageRouteInfo>? children})
    : super(MpinBioLoginRoute.name, initialChildren: children);

  static const String name = 'MpinBioLoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MpinBioLoginScreen();
    },
  );
}

/// generated route for
/// [OTPVerificationScreen]
class OTPVerificationRoute extends PageRouteInfo<OTPVerificationRouteArgs> {
  OTPVerificationRoute({
    Key? key,
    required String phoneNumber,
    required bool isLogin,
    bool? isForgotMpin,
    List<PageRouteInfo>? children,
  }) : super(
         OTPVerificationRoute.name,
         args: OTPVerificationRouteArgs(
           key: key,
           phoneNumber: phoneNumber,
           isLogin: isLogin,
           isForgotMpin: isForgotMpin,
         ),
         initialChildren: children,
       );

  static const String name = 'OTPVerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OTPVerificationRouteArgs>();
      return OTPVerificationScreen(
        key: args.key,
        phoneNumber: args.phoneNumber,
        isLogin: args.isLogin,
        isForgotMpin: args.isForgotMpin,
      );
    },
  );
}

class OTPVerificationRouteArgs {
  const OTPVerificationRouteArgs({
    this.key,
    required this.phoneNumber,
    required this.isLogin,
    this.isForgotMpin,
  });

  final Key? key;

  final String phoneNumber;

  final bool isLogin;

  final bool? isForgotMpin;

  @override
  String toString() {
    return 'OTPVerificationRouteArgs{key: $key, phoneNumber: $phoneNumber, isLogin: $isLogin, isForgotMpin: $isForgotMpin}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OTPVerificationRouteArgs) return false;
    return key == other.key &&
        phoneNumber == other.phoneNumber &&
        isLogin == other.isLogin &&
        isForgotMpin == other.isForgotMpin;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      phoneNumber.hashCode ^
      isLogin.hashCode ^
      isForgotMpin.hashCode;
}

/// generated route for
/// [RegisterSuccessScreen]
class RegisterSuccessRoute extends PageRouteInfo<void> {
  const RegisterSuccessRoute({List<PageRouteInfo>? children})
    : super(RegisterSuccessRoute.name, initialChildren: children);

  static const String name = 'RegisterSuccessRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterSuccessScreen();
    },
  );
}

/// generated route for
/// [RegistrationScreen]
class RegistrationRoute extends PageRouteInfo<void> {
  const RegistrationRoute({List<PageRouteInfo>? children})
    : super(RegistrationRoute.name, initialChildren: children);

  static const String name = 'RegistrationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegistrationScreen();
    },
  );
}

/// generated route for
/// [SetMpinScreen]
class SetMpinRoute extends PageRouteInfo<SetMpinRouteArgs> {
  SetMpinRoute({
    Key? key,
    required bool isFirstSetup,
    List<PageRouteInfo>? children,
  }) : super(
         SetMpinRoute.name,
         args: SetMpinRouteArgs(key: key, isFirstSetup: isFirstSetup),
         initialChildren: children,
       );

  static const String name = 'SetMpinRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SetMpinRouteArgs>();
      return SetMpinScreen(key: args.key, isFirstSetup: args.isFirstSetup);
    },
  );
}

class SetMpinRouteArgs {
  const SetMpinRouteArgs({this.key, required this.isFirstSetup});

  final Key? key;

  final bool isFirstSetup;

  @override
  String toString() {
    return 'SetMpinRouteArgs{key: $key, isFirstSetup: $isFirstSetup}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SetMpinRouteArgs) return false;
    return key == other.key && isFirstSetup == other.isFirstSetup;
  }

  @override
  int get hashCode => key.hashCode ^ isFirstSetup.hashCode;
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [TempDashboardScreen]
class TempDashboardRoute extends PageRouteInfo<void> {
  const TempDashboardRoute({List<PageRouteInfo>? children})
    : super(TempDashboardRoute.name, initialChildren: children);

  static const String name = 'TempDashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TempDashboardScreen();
    },
  );
}
