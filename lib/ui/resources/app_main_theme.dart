import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';
import 'package:ryal_mobile/ui/resources/app_dimens.dart';
import 'package:ryal_mobile/ui/resources/app_text_styles.dart';

const String _almaraiFont = 'Almarai';
const String _montserratFont = 'Montserrat';

ThemeData buildTheme(BuildContext context, String? lang) => ThemeData(
      scrollbarTheme: const ScrollbarThemeData().copyWith(
        thumbColor: WidgetStateProperty.all(
        AppColors.primaryBlueButton),
      ),
      splashFactory: NoSplash.splashFactory,
      brightness: Brightness.light,
      primaryColor: Colors.grey,
      primaryColorDark: Colors.grey,
      textTheme: const TextTheme(
        titleMedium: TextStyle(
          color: Colors.grey,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.grey,
        selectionHandleColor: Colors.grey,
      ),
      scaffoldBackgroundColor: Colors.white ,//scaffoldbackgroundcolor
      fontFamily: lang == 'ar' ? _almaraiFont : _montserratFont,
      elevatedButtonTheme: _elevatedButtonTheme,
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      outlinedButtonTheme: _outlinedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      bottomNavigationBarTheme: _bottomNavigatorBarTheme,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        foregroundColor: Colors.grey,
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: AppTextStyles.primary.n16w700.black,
      ),
      colorScheme: const ColorScheme.light(
        primary: Colors.grey,
      ).copyWith(error: Colors.red),
    );

ElevatedButtonThemeData get _elevatedButtonTheme {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      splashFactory: NoSplash.splashFactory,
      elevation: 0, 
      minimumSize: Size(double.maxFinite, AppDimens.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: AppDimens.defautlRadius),
      textStyle: AppTextStyles.primary.n16w700.black,
    ).copyWith(
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
    ),
  );
}

OutlinedButtonThemeData get _outlinedButtonTheme {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: Size(double.maxFinite, AppDimens.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: AppDimens.defautlRadius),
      textStyle: AppTextStyles.primary.n16w700
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.grey;
          }
          return null;
        },
      ),
      side: WidgetStateProperty.resolveWith<BorderSide?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return const BorderSide(color:AppColors.primaryBlueButton);
          }
          if (states.contains(WidgetState.disabled)) {
            return const BorderSide(color: AppColors.transparent);
          }
          return const BorderSide(color:  AppColors.transparent);
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primaryBlueButton;
          }
          if (states.contains(WidgetState.disabled)) {
            return AppColors.primaryBlueButton;
          }
          return AppColors.primaryBlueButton;
        },
      ),
      elevation: WidgetStateProperty.resolveWith<double>(
        (Set<WidgetState> states) {
          return 0;
        },
      ),
    ),
  );
}

InputDecorationTheme get _inputDecorationTheme {
  final defaultBorder = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.grey,
    ),
    borderRadius: AppDimens.defautlRadius,
  );
  return InputDecorationTheme(
    fillColor: Colors.grey,
    filled: true,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: defaultBorder,
    enabledBorder: defaultBorder,
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color:Colors.grey,
      ),
      borderRadius: AppDimens.defautlRadius,
    ),
    disabledBorder: defaultBorder,
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.red,
      ),
      borderRadius: AppDimens.defautlRadius,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.red,
      ),
      borderRadius: AppDimens.defautlRadius,
    ),
    hintStyle: AppTextStyles.primary.n16w700.copyWith(color: Colors.grey),
    errorStyle: AppTextStyles.primary.n16w700.copyWith(color: Colors.red),
  );
}

BottomNavigationBarThemeData get _bottomNavigatorBarTheme =>
    BottomNavigationBarThemeData(
      // selectedIconTheme: const IconThemeData(
      //   shadows: <Shadow>[Shadow(color: Colors.white, blurRadius: 4.0)],
      // ),
      selectedItemColor: Colors.white,
      unselectedItemColor: AppColors.primaryBlueButton,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      backgroundColor: Colors.pink,
      selectedLabelStyle: AppTextStyles.primary.n16w700,
      unselectedLabelStyle: AppTextStyles.primary.n16w700,
    );
