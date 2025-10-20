

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ryal_mobile/extension/localization_ext.dart';
import 'package:ryal_mobile/main.dart';
import 'package:ryal_mobile/route/app_router.dart';
import 'package:ryal_mobile/ui/components/buttons/app_button.dart';
import 'package:ryal_mobile/ui/resources/app_assets.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';
import 'package:ryal_mobile/ui/resources/app_text_styles.dart';
import 'package:ryal_mobile/ui/widgets/appbar.dart';
import 'package:ryal_mobile/ui/widgets/language_selection.dart';

@RoutePage()
class RegisterSuccessScreen extends StatefulWidget {
  const RegisterSuccessScreen({super.key});

  @override
  State<RegisterSuccessScreen> createState() => _RegisterSuccessScreenState();
}

class _RegisterSuccessScreenState extends State<RegisterSuccessScreen> {
  String selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
  }

  
  @override
  void dispose() {
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TransparentAppBar(
        showBackButton: false,
        preferredSize: const Size.fromHeight(60),
        action: LanguageSelectorWidget(),
      ),
      body: Stack(
        
        children: [
           Positioned.fill(
        child: Image.asset(
          "assets/png/bg2.png",
         // AppAssets.bg,
          fit: BoxFit.cover,
        ),
      ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 22.0,right: 22,bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add your other widgets here
                 
               Image.asset(
                                      AppAssets.registerSuccess,
                                      height: 300,
                                      width: 300,

                                    ),
          
                                     Center(
                                       child: Text("Your account has been registered successfully!",
                                       textAlign: TextAlign.center,
                                                         style: AppTextStyles.primary.n24w700.primaryBlueText),
                                     ),
                                    Spacer(),
          
           Center(
                                       child: Text(" A few final steps to securely set up your account.",
                                       textAlign: TextAlign.center,
                                                         style: AppTextStyles.primary.n16w500.primaryBlueText),
                                     ),
                                     SizedBox(height: 20,),
                                    //
                                                            AppButton(
                            textStyle:AppTextStyles.primary.n16w700.white ,
                            title: context.l10n.login,
                            isActive: true,
                            onPressed: (){
                              appRouter.push(LoginRoute() ) ;
              
                            },
                            buttonColor: AppColors.primaryBlueButton,
                            
                          ),
                            
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}