import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ryal_mobile/core/app_validation_rule.dart';
import 'package:ryal_mobile/ui/resources/app_colors.dart';
import 'package:ryal_mobile/ui/resources/app_text_styles.dart';

class RoundedTextInputField extends StatefulWidget {
  const RoundedTextInputField({
    super.key,
    this.label,
    this.errorText,
    this.placeHolder,
    this.prefixText,
    this.suffixIcon,
    this.prefixIcon,
    this.isObscured = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmit,
    this.maxLines,
    this.focusNode,
    this.textInputAction,
    this.enabled = true,
    this.decoration,
    this.autovalidateMode = AutovalidateMode.always,
    this.hasError,
    this.inputFormatters,
    this.maxLength,
    this.keyboardType,
    this.initialValue,
    this.autofocus = false,
    this.textAlign,
  });

  final String? label;
  final String? errorText;
  final String? placeHolder;
  final String? prefixText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool isObscured;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;

  final Function(String)? onSubmit;
  final int? maxLines;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool enabled;
  final InputDecoration? decoration;
  final AutovalidateMode? autovalidateMode;
  final bool? hasError;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String? initialValue;
  final bool autofocus;
  final TextAlign? textAlign;

  @override
  State<RoundedTextInputField> createState() => _RoundedTextInputFieldState();
}

class _RoundedTextInputFieldState extends State<RoundedTextInputField> {
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      isFocused = widget.focusNode?.hasFocus ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ddecoration = widget.decoration ??
        InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.h,
            horizontal: 16.w
          ),
          //prefixText: widget.prefixText,
          suffixIcon: widget.suffixIcon != null
              ? Padding(
                  padding: EdgeInsets.only(
                      right: 12.w), // Add right padding for suffix icon
                  child: widget.suffixIcon,
                )
              : null,
          suffixIconConstraints: BoxConstraints(
            minWidth: 24.h,
            maxWidth: 40.h, // Increased max width to accommodate padding
            minHeight: 24.h,
            maxHeight: 24.h,
          ),
          hintStyle: AppTextStyles.primary.n16w500.hintTextGrey,
          isDense: true,
          // prefixIcon: Padding(
          //   padding: EdgeInsets.only(left: 14.w, right: 8.w),
          //   child: widget.prefixIcon,
          // ),
          hintText: widget.placeHolder,
          fillColor: isFocused ? AppColors.white : AppColors.whiteButtonBorder,
          filled: true,
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.transparent,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.transparent,
            ),
            // ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.transparent,
            ),
          ),
        );

    return Wrap(
      runSpacing: 8,
      children: [
        Text(
          widget.label ?? '',
          style: widget.hasError != null && widget.hasError!
              ? AppTextStyles.primary.n14w400.black
              : AppTextStyles.primary.n14w400.black,
        ),
        TextFormField(
          inputFormatters: widget.inputFormatters ??
              [
                FilteringTextInputFormatter.allow(
                  AppValidationRule.allowedCharacters,
                ),
              ],
          textAlign: widget.textAlign ?? TextAlign.center,
          autofocus: widget.autofocus,
          initialValue: widget.initialValue,
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          style: AppTextStyles.primary.n16w500.black,
          enabled: widget.enabled,
          obscureText: widget.isObscured,
          enableSuggestions: false,
          autocorrect: false,
          validator: widget.validator,
          controller: widget.controller,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          onFieldSubmitted: widget.onSubmit,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          decoration: widget.decoration ??
              ddecoration.copyWith(
                enabledBorder: ddecoration.border?.copyWith(
                  borderSide: BorderSide(
                    color: widget.hasError != null && widget.hasError!
                        ? AppColors.transparent
                        : AppColors.transparent,
                  ),
                ),
                focusedErrorBorder: ddecoration.border?.copyWith(
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                ),
                errorBorder: ddecoration.border?.copyWith(
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                ),
                errorStyle: const TextStyle().copyWith(
                  color: Colors.red,
                  fontSize: 12,
                ),
                counterText: '',
              ),
        ),
        if (widget.hasError != null &&
            widget.hasError! &&
            widget.errorText != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.w), // Match the field's horizontal padding
              child: Text(
                widget.errorText!,
                style: AppTextStyles.primary.n14w400.copyWith(
                  color: Colors.red,
                  fontSize: 12,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
      ],
    );
  }
}