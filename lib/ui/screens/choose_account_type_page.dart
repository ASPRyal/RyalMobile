// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:ryal_mobile/extension/localization_ext.dart';
// import 'package:ryal_mobile/injection.dart';
// import 'package:ryal_mobile/main.dart';
// import 'package:ryal_mobile/route/app_router.dart';
// import 'package:ryal_mobile/services/storages/i_storage_service.dart';
// import 'package:ryal_mobile/ui/components/buttons/app_button.dart';
// import 'package:ryal_mobile/ui/resources/app_assets.dart';
// import 'package:ryal_mobile/ui/resources/app_colors.dart';
// import 'package:ryal_mobile/ui/resources/app_text_styles.dart';
// import 'package:ryal_mobile/ui/widgets/appbar.dart';
// import 'package:ryal_mobile/ui/widgets/language_selection.dart';

// @RoutePage()
// class ChooseAccountTypeScreen extends StatefulWidget {
//   const ChooseAccountTypeScreen({super.key});

//   @override
//   State<ChooseAccountTypeScreen> createState() => _ChooseAccountTypeScreenState();
// }

// class _ChooseAccountTypeScreenState extends State<ChooseAccountTypeScreen> {
//   String selectedLanguage = 'English';

//   @override
//   void initState() {
//     super.initState();
//     _loadCurrentLanguage();
//   }

//   Future<void> _loadCurrentLanguage() async {
//     final locale = await getIt<IStorageService>().getLangCode();
//     setState(() {
//       selectedLanguage = locale?.languageCode == 'ar' ? 'Arabic' : 'English';
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }




//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: TransparentAppBar(
//         showBackButton: false,
//         preferredSize: const Size.fromHeight(60),
//         action: LanguageSelectorWidget(),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 22.0,right: 22,bottom: 100),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Add your other widgets here
//               Text("Choose your account type",
//                   style: AppTextStyles.primary.n16w600.blueText),
//                       SizedBox(height: 44.h),
                        
//           AppButton(
//                         title: context.l10n.individual,
//                         isActive: true,
//                         onPressed: (){
//                           appRouter.push(LoginRoute() ) ;
//                         },
//                         buttonColor: AppColors.otpBorder,
//                                    textStyle:AppTextStyles.primary.n16w700.primaryBlueText ,
//                                    svgIcon: AppAssets.icIndividual,
                                   
//                       ),
                      
//                       SizedBox(height: 25.h),
//                        AppButton(
//                         textStyle:AppTextStyles.primary.n16w700.primaryBlueText ,
//                         title: context.l10n.corporate,
//                         isActive: true,
//                         onPressed: (){
//                           appRouter.push(LoginRoute() ) ;
    
//                         },
//                         buttonColor: AppColors.otpBorder,
//                             svgIcon: AppAssets.icCorporate,
                        
//                       ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }