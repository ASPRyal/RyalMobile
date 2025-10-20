import 'package:auto_route/auto_route.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ryal_mobile/extension/localization_ext.dart';
import 'package:ryal_mobile/injection.dart';
import 'package:ryal_mobile/main.dart';
import 'package:ryal_mobile/route/app_router.dart';
import 'package:ryal_mobile/state/register/register_cubit.dart';
import 'package:ryal_mobile/ui/components/buttons/app_button.dart';
import 'package:ryal_mobile/ui/components/icons/svg_icon_component.dart';
import 'package:ryal_mobile/ui/components/unfocuser.dart';
import 'package:ryal_mobile/ui/resources/app_assets.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';
import 'package:ryal_mobile/ui/resources/app_text_styles.dart';
import 'package:ryal_mobile/ui/widgets/appbar.dart';
import 'package:ryal_mobile/ui/widgets/inputs/rounded_textinput_field.dart';
import 'package:ryal_mobile/ui/widgets/language_selection.dart';
import 'package:ryal_mobile/ui/widgets/phone_confirmation_widget.dart';
import 'package:ryal_mobile/ui/enums/user_type_enum.dart';

@RoutePage()
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _qidController = TextEditingController();
  final _mcitController = TextEditingController();
  final _emailController = TextEditingController();
  final _buildingNoController = TextEditingController();
  final _zoneController = TextEditingController();
  final _streetNoController = TextEditingController();

  late final RegisterCubit cubit;
  String _nationalityCountryCode = '';

  @override
  void initState() {
    super.initState();
    cubit = getIt<RegisterCubit>();

    _fullNameController.addListener(() {
      cubit.onFullNameChange(_fullNameController.text);
    });
    
    _phoneController.addListener(() {
      cubit.onPhoneChange(_phoneController.text);
    });
    
    _qidController.addListener(() {
      cubit.onQidChange(_qidController.text);
    });
    
    _mcitController.addListener(() {
      cubit.onMcitNumberChange(_mcitController.text);
    });
    
    _emailController.addListener(() {
      cubit.onEmailChange(_emailController.text);
    });

    _usernameController.addListener(() {
    cubit.onUsernameChange(_usernameController.text);
  });
  
  _companyNameController.addListener(() {
    cubit.onCompanyNameChange(_companyNameController.text);
  });
  
  _buildingNoController.addListener(() {
    cubit.onBuildingNoChange(_buildingNoController.text);
  });
  
  _zoneController.addListener(() {
    cubit.onZoneChange(_zoneController.text);
  });
  
  _streetNoController.addListener(() {
    cubit.onStreetNoChange(_streetNoController.text);
  });
}
  

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _companyNameController.dispose();
    _phoneController.dispose();
    _qidController.dispose();
    _mcitController.dispose();
    _emailController.dispose();
    _buildingNoController.dispose();
    _zoneController.dispose();
    _streetNoController.dispose();
    super.dispose();
  }

  void _handleRegister(RegisterCubit cubit) {
    //if(cubit.state.userType == UserType.individual ) {
    cubit.validateAndSubmit();
  //  }
  }

  void _navigateToLogin() {
    appRouter.push(const LoginRoute());
  }

  void _showNationalityPicker(RegisterCubit cubit) {
    showCountryPicker(
      context: context,
      favorite: ['QA'],
      showPhoneCode: false,
      onSelect: (Country country) {
        cubit.selectedNationality(nationality: country.name);
        setState(() {
          _nationalityCountryCode = country.countryCode;
        });
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

  void _showCountryPicker(RegisterCubit cubit, RegisterState state) {
    showCountryPicker(
      context: context,
      favorite: ['QA'],
      showPhoneCode: true,
      onSelect: (Country country) {
        cubit.onCountryChange(country.countryCode, country.phoneCode);
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

  void _showPhoneConfirmationDialog(String phoneNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PhoneConfirmationDialog(
          phoneNumber: phoneNumber,
          onConfirm: () {
            appRouter.pop();
            appRouter.push(OTPVerificationRoute(
              phoneNumber: phoneNumber,
              isLogin: false
            ));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (BuildContext context) => cubit,
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.isSuccess) {
            final fullPhoneNumber = '+${state.selectedCountryPhoneCode}${state.phoneNumber.trim()}';
          _showPhoneConfirmationDialog(fullPhoneNumber);
          }
          
          if (state.showErrors && !state.termsAccepted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please accept Terms and Conditions')),
            );
          }
        },
        builder: (context, state) {
          final registerCubit = context.read<RegisterCubit>();
          final selectedCountry = Country.tryParse(state.selectedCountryCode) ?? Country.parse('QA');
          
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            appBar: TransparentAppBar(
              showBackButton: true,
              preferredSize: const Size.fromHeight(60),
              action: LanguageSelectorWidget(),
            ),
            body: SafeArea(
              child: Unfocuser(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                       "Welcome !",
                        style: AppTextStyles.primary.n24w700.black,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.please_enter_the_required_information_to_sign_up,
                        style: AppTextStyles.primary.n14w400,
                      ),
                      const SizedBox(height: 32),

                      // User Type Tabs
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => registerCubit.onUserTypeChange(UserType.individual),
                              child: Container(
                                height: 42.h,
                                decoration: BoxDecoration(
                                  color: state.userType == UserType.individual
                                      ? AppColors.otpBorder
                                      : Colors.white,
                                  borderRadius: state.userType == UserType.individual
                                      ? BorderRadius.circular(20.r)
                                      : BorderRadius.zero,
                                  border: state.userType != UserType.individual
                                      ? Border(
                                          bottom: BorderSide(
                                            color: AppColors.otpBorder,
                                            width: 1,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgIconComponent(iconPath: AppAssets.icIndividual, size: 22,color: state.userType == UserType.individual ? AppColors.primaryBlueButton: AppColors.lightGrey,),
                                   
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Individual',
                                      style:AppTextStyles.primary.n16w700.copyWith(
                                        color: state.userType==UserType.individual ? AppColors.primaryBlueButton :AppColors.hintGrey
                                      )
                                      
                                      //  TextStyle(
                                      //   fontSize: 16.sp,
                                      //   fontWeight: FontWeight.w500,
                                      //   color: state.userType == UserType.individual
                                      //       ? AppColors.primaryBlueButton
                                      //       : Colors.grey[600],
                                      // ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => registerCubit.onUserTypeChange(UserType.corporate),
                              child: Container(
                                height: 42.h,
                                decoration: BoxDecoration(
                                  color: state.userType == UserType.corporate
                                            ? AppColors.otpBorder
                                      : Colors.white,
                                  borderRadius: state.userType == UserType.corporate
                                      ? BorderRadius.circular(20.r)
                                      : BorderRadius.zero,
                                  border: state.userType != UserType.corporate
                                      ? Border(
                                          bottom: BorderSide(
                                   color: AppColors.otpBorder,
                                            width: 1,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgIconComponent(iconPath: AppAssets.icCorporate, size: 22,color: state.userType == UserType.corporate ? AppColors.primaryBlueButton: AppColors.lightGrey,),
                                  
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Corporate',
                                      style:AppTextStyles.primary.n16w700.copyWith(
                                        color: state.userType==UserType.corporate ? AppColors.primaryBlueButton :AppColors.hintGrey
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Conditional fields based on user type
                      if (state.userType == UserType.individual) ...[
                        // Full Name for Individual
                        RoundedTextInputField(
                          controller: _fullNameController,
                          placeHolder: "Full Name",
                          textAlign: TextAlign.start,
                          hasError: registerCubit.hasError('fullname'),
                          errorText: registerCubit.getFullNameError(),
                        ),
                      ] else ...[
                        // Username for Corporate
                        RoundedTextInputField(
                          controller: _usernameController,
                          placeHolder: "Username",
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 16),
                        // Company Name for Corporate
                        RoundedTextInputField(
                          controller: _companyNameController,
                          placeHolder: "Company Name",
                          textAlign: TextAlign.start,
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Phone Number
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _showCountryPicker(registerCubit, state),
                                child: Container(
                                  height: 56,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[50],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        selectedCountry.flagEmoji,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '+${selectedCountry.phoneCode}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RoundedTextInputField(
                                  controller: _phoneController,
                                  textAlign: TextAlign.start,
                                  placeHolder: "Phone Number",
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(8),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  hasError: registerCubit.hasError('phone'),
                                ),
                              ),
                            ],
                          ),
                          if (registerCubit.getPhoneError() != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 16),
                              child: Text(
                                registerCubit.getPhoneError()!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email
                      RoundedTextInputField(
                        controller: _emailController,
                        textAlign: TextAlign.start,
                        placeHolder: "Email",
                        keyboardType: TextInputType.emailAddress,
                        hasError: registerCubit.hasError('email'),
                        errorText: registerCubit.getEmailError(),
                      ),
                      const SizedBox(height: 16),
RoundedTextInputField(
                          controller: _qidController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(11),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          placeHolder: "QID number",
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.number,
                          hasError: registerCubit.hasError('qid'),
                          errorText: registerCubit.getQidError(),
                        ),
                        const SizedBox(height: 16),
                      // Corporate-specific fields
                      if (state.userType == UserType.corporate) ...[
                        Row(
                          children: [
                            Expanded(
                              child: RoundedTextInputField(
                                controller: _buildingNoController,
                                placeHolder: "Building No",
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: RoundedTextInputField(
                                controller: _zoneController,
                                placeHolder: "Zone",
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.number,

                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        RoundedTextInputField(
                          controller: _streetNoController,
                          placeHolder: "Street No",
                          textAlign: TextAlign.start,
                                keyboardType: TextInputType.number,

                        ),
                        const SizedBox(height: 16),
                      ],

                      // Individual-specific fields
                      if (state.userType == UserType.individual) ...[
                        // QID
                        

                        // Nationality Dropdown
                        GestureDetector(
                          onTap: () => _showNationalityPicker(registerCubit),
                          child: Container(
                            height: 56.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.whiteButtonBorder,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                              color: AppColors.whiteButtonBorder,
                            ),
                            child: Row(
                              children: [
                                if (_nationalityCountryCode.isNotEmpty) ...[
                                  Text(
                                    Country.tryParse(_nationalityCountryCode)?.flagEmoji ?? '',
                                    style: TextStyle(fontSize: 24.sp),
                                  ),
                                  SizedBox(width: 12.w),
                                ],
                                Expanded(
                                  child: Text(
                                    state.selectedNationality.isNotEmpty 
                                        ? state.selectedNationality
                                        : 'Nationality',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: state.selectedNationality.isNotEmpty 
                                          ? Colors.black 
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                  size: 24.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: state.termsAccepted,
                        onChanged: (bool? value) {
                          registerCubit.toggleTermsAcceptance();
                        },
                        activeColor: AppColors.primaryBlueButton,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            registerCubit.toggleTermsAcceptance();
                          },
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.primary.n14w500.black,
                              children: [
                                TextSpan(
                                  text: "${context.l10n.i_have_read_and_agreed_to_the} ",
                                ),
                                TextSpan(
                                  text: 'Terms and Conditions',
                                  style: AppTextStyles.primary.n14w500.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppButton(
                    title: state.isSubmitting 
                        ? 'Loading...' 
                        : context.l10n.continue_text,
                    isActive: registerCubit.areAllFieldsFilled && !state.isSubmitting,
                    onPressed: registerCubit.areAllFieldsFilled && !state.isSubmitting 
                        ? () => _handleRegister(registerCubit)
                        : null,
                    buttonColor: AppColors.primaryBlueButton,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GestureDetector(
                      onTap: _navigateToLogin,
                      child: Text(
                        'You already have an account? Log in',
                        style: AppTextStyles.primary.n16w500.primaryBlueText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}