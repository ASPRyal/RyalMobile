import 'package:flutter/widgets.dart';
import 'package:ryal_mobile/ui/screens/biometric_verification_screen.dart';
import 'package:ryal_mobile/ui/screens/splash_page.dart';
import 'package:ryal_mobile/ui/screens/login_page.dart';
import 'package:ryal_mobile/ui/screens/register_page.dart';
import 'package:ryal_mobile/ui/screens/otp_verification_page.dart';


import 'package:ryal_mobile/ui/screens/auth_selection_page.dart';
import 'package:ryal_mobile/ui/screens/choose_account_type_page.dart';
import 'package:ryal_mobile/ui/screens/set_mpin_screen.dart';
import 'package:ryal_mobile/ui/screens/kyc_scan_page.dart';
import 'package:ryal_mobile/ui/screens/mpin_bio_login_page.dart';
import 'package:ryal_mobile/ui/screens/temp_dashboard.dart';
import 'package:ryal_mobile/ui/screens/register_success_page.dart';







//export 'appp_router.gr.dart';

import 'package:auto_route/auto_route.dart';


part 'app_router.gr.dart';



@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
   
       AutoRoute(page: SplashRoute.page,
          path: '/',
      initial: true,),
    //    AutoRoute(
    //   page: AuthRoute.page,
   
    // ),
     AutoRoute(
      page: LoginRoute.page,
   
    ),
     AutoRoute(
      page: RegistrationRoute.page,
   
    ),
    AutoRoute(
      page: AuthSelectionRoute.page,
   
    ),
      AutoRoute(
      page: OTPVerificationRoute.page,
   
    ),

    //        AutoRoute(
    //   page: ChooseAccountTypeRoute.page,
   
    // ),
    AutoRoute(page:   SetMpinRoute.page),
    AutoRoute(page:  KycVerificationRoute.page),
    AutoRoute(page: BiometricVerificationRoute.page),
    AutoRoute(page: MpinBioLoginRoute.page),
    AutoRoute(page: TempDashboardRoute.page),
    AutoRoute(page: RegisterSuccessRoute.page),




    //    AutoRoute(
    //   page: KYCFlowRoute.page,
   
    // ),
    // Add more routes here
  ];
}