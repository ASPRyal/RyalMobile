import 'package:auto_route/auto_route.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ryal_mobile/core/app_validation_rule.dart';
import 'package:ryal_mobile/extension/localization_ext.dart';
import 'package:ryal_mobile/injection.dart';
import 'package:ryal_mobile/main.dart';
import 'package:ryal_mobile/route/app_router.dart';
import 'package:ryal_mobile/state/register/register_cubit.dart';
import 'package:ryal_mobile/ui/components/buttons/app_button.dart';
import 'package:ryal_mobile/ui/components/unfocuser.dart';
import 'package:ryal_mobile/ui/resources/app_assets.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';
import 'package:ryal_mobile/ui/resources/app_text_styles.dart';
import 'package:ryal_mobile/ui/widgets/appbar.dart';
import 'package:ryal_mobile/ui/widgets/inputs/rounded_textinput_field.dart';
import 'package:ryal_mobile/ui/widgets/language_selection.dart';
import 'package:ryal_mobile/ui/widgets/phone_confirmation_widget.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool showPhoneError = false;
  late final RegisterCubit registerCubit;

  @override
  void initState() {
    super.initState();
    registerCubit = getIt<RegisterCubit>();
    
    phoneController.addListener(() {
      registerCubit.onPhoneChange(phoneController.text);
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _showPhoneConfirmationDialog(String phoneNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PhoneConfirmationDialog(
          phoneNumber: phoneNumber,
          onConfirm: () {
            registerCubit.login(phoneNumber: phoneNumber);
            appRouter.pop();
          },
        );
      },
    );
  }

  void _handleLogin() {
    setState(() {
      showPhoneError = true;
    });
    
    final phoneNumber = phoneController.text.trim();
    final selectedCountry = registerCubit.state.selectedCountryCode.isNotEmpty 
        ? Country.tryParse(registerCubit.state.selectedCountryCode) ?? Country.parse('QA')
        : Country.parse('QA');
    
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your phone number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (!AppValidationRule.phoneValidator(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid phone number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final fullPhoneNumber = '+${selectedCountry.phoneCode}$phoneNumber';
    _showPhoneConfirmationDialog(fullPhoneNumber);
  }

  String? _getPhoneError() {
    if (!showPhoneError) return null;
    
    final phoneNumber = phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      return 'Please enter your phone number';
    } else if (!AppValidationRule.phoneValidator(phoneNumber)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  bool _hasPhoneError() {
    if (!showPhoneError) return false;
    
    final phoneNumber = phoneController.text.trim();
    return phoneNumber.isEmpty || !AppValidationRule.phoneValidator(phoneNumber);
  }

  bool get _isPhoneValid {
    final phoneNumber = phoneController.text.trim();
    return phoneNumber.isNotEmpty && AppValidationRule.phoneValidator(phoneNumber);
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      favorite: ['QA'],
      showPhoneCode: true,
      onSelect: (Country country) {
        registerCubit.onCountryChange(country.countryCode, country.phoneCode);
      },
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.75,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.whiteButtonBorder,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.whiteButtonBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.searchBarBorder,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (context) => registerCubit,
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          // Show error message if login fails
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
            // Clear the error after showing
            registerCubit.clearErrors();
          }
          
          // Navigate to OTP screen on successful login request
          if (state.isLoginSuccess) {
            appRouter.replace(OTPVerificationRoute(
              phoneNumber: state.phoneNumber,
              isLogin: true,
            ));
          }
        },
        builder: (context, state) {
          final selectedCountry = state.selectedCountryCode.isNotEmpty 
              ? Country.tryParse(state.selectedCountryCode) ?? Country.parse('QA')
              : Country.parse('QA');
          
          return Unfocuser(
            child: Scaffold(
              appBar: TransparentAppBar(
                showBackButton: true,
                preferredSize: const Size.fromHeight(60),
                action: LanguageSelectorWidget(),
              ),
              backgroundColor: AppColors.white,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.welcome_back,
                                style: AppTextStyles.primary.n24w700.blueText,
                              ),
                              
                              SizedBox(height: 8.h),
                              
                              Text(
                                'Please enter your phone number.',
                                style: AppTextStyles.primary.n14w400.blueText,
                              ),
                              
                              SizedBox(height: 28.h),
                              
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: _showCountryPicker,
                                    child: Container(
                                      height: 56.h,
                                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: _hasPhoneError() 
                                              ? Colors.red 
                                              : AppColors.transparent,
                                        ),
                                        borderRadius: BorderRadius.circular(12.r),
                                        color: AppColors.whiteButtonBorder,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            selectedCountry.flagEmoji,
                                            style: TextStyle(fontSize: 24.sp),
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            '+${selectedCountry.phoneCode}',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: RoundedTextInputField(
                                      controller: phoneController,
                                      placeHolder: "Phone Number",
                                      keyboardType: TextInputType.phone,
                                      textAlign: TextAlign.start,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(8),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      hasError: _hasPhoneError(),
                                      onChanged: (value) {
                                        registerCubit.onPhoneChange(
                                          '+${selectedCountry.phoneCode}$value',
                                        );
                                        if (showPhoneError && value.isNotEmpty) {
                                          setState(() {
                                            showPhoneError = false;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              
                              if (_getPhoneError() != null)
                                Padding(
                                  padding: EdgeInsets.only(top: 8.h, left: 16.w),
                                  child: Text(
                                    _getPhoneError()!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              
                              SizedBox(height: 40.h),
                              
                              AppButton(
                                title: context.l10n.login,
                                isActive: _isPhoneValid && !state.isSubmitting,
                                onPressed: (_isPhoneValid && !state.isSubmitting) 
                                    ? _handleLogin 
                                    : null,
                                buttonColor: AppColors.primaryBlueButton,
                              ),
                              
                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
                      ),
                      
                      Center(
                        child: TextButton(
                          onPressed: () {
                            appRouter.push(const RegistrationRoute());
                          },
                          child: Text(
                            context.l10n.new_here_create_an_account,
                            style: AppTextStyles.primary.n16w500.primaryBlueText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}