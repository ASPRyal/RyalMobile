import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';



/// A utility class that holds all the core [TextStyle] used
/// throughout the entire app.
/// This class has no constructor and all variables are `static`.
///
/// Only create the high level variants here. Any modification can
/// be done on the fly using `style.copyWith()`.
/// `newStyle = AppTextStyles.primary.body1.copyWith(color: Colors.red)`.
@immutable
class AppTextStyles {
  const AppTextStyles._();

  /// Base TextTheme for the Montserrat Font.
  static const _montserratTextTheme = TextStyle(
    fontFamily: 'Montserrat',
    letterSpacing: 0.0,
  );

  /// The main [_FontStyle] used for most of typography in the app.
  static final primary = _FontStyle(
 fontFamily: _montserratTextTheme.fontFamily ?? 'Montserrat',
   
    n16w700: _montserratTextTheme.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
    ),
      n24w700: _montserratTextTheme.copyWith(
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
    ),
     n18w500: _montserratTextTheme.copyWith(
      fontSize: 18.sp,
      fontWeight: FontWeight.w500,
    ),
      n14w400: _montserratTextTheme.copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
    ),
      n14w500: _montserratTextTheme.copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
    ),
     n16w500: _montserratTextTheme.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
    ),
     n16w600: _montserratTextTheme.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
    ),
     n24w600: _montserratTextTheme.copyWith(
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
    ),
     n32w500: _montserratTextTheme.copyWith(
      fontSize: 32.sp,
      fontWeight: FontWeight.w500,
    ),
     n18w700: _montserratTextTheme.copyWith(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
    ),
     n16w400: _montserratTextTheme.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
    ),
     n20w600: _montserratTextTheme.copyWith(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
    ),
     n18w600: _montserratTextTheme.copyWith(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
    ),

  );
}

/// A class containing all the predefined [TextStyle]s in the app.
@immutable
class _FontStyle {
  final String fontFamily;
  final TextStyle n16w700;
  final TextStyle n24w700;
  final TextStyle n20w600;

  final TextStyle n24w600;
  final TextStyle n32w500;

  final TextStyle n14w400;
  final TextStyle n18w500;
  final TextStyle n18w700;


  final TextStyle n14w500;

  final TextStyle n16w500;
  final TextStyle n16w400;

  final TextStyle n16w600;
  final TextStyle n18w600;






  const _FontStyle({
    required this.n16w700,
    required this.n16w400,
    required this.n20w600,
    required this.n18w600,


    required this.n16w500,
    required this.n32w500,
    required this.n18w500,
    required this.n18w700,




    required this.n24w700,
    required this.n24w600,

    required this.n14w400,
    required this.n14w500,

    required this.n16w600,


    
    required this.fontFamily,

  });
}

extension Colorized on TextStyle {
  TextStyle get black => copyWith(color: AppColors.black);
    TextStyle get white => copyWith(color: AppColors.white);
    TextStyle get hintTextGrey => copyWith(color: AppColors.hintGrey);
    TextStyle get primaryBlueText => copyWith(color: AppColors.primaryBlueButton);
    TextStyle get blueText => copyWith(color: AppColors.blueText);
    TextStyle get timerGreen => copyWith(color: AppColors.timerGreen);
    TextStyle get blueText1 => copyWith(color: AppColors.blueText1);




  // TextStyle get primaryDarkPurplePallet2 =>
  //     copyWith(color: const Color(0xFF1D153B));

}
