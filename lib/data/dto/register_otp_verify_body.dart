// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'register_otp_verify_body.g.dart';

@JsonSerializable()
class RegisterOTPVerifyBody {
  const RegisterOTPVerifyBody({
    required this.phone_number,
    required this.otp,

  });

  final String phone_number;
  final String otp;


  factory RegisterOTPVerifyBody.fromJson(Map<String, dynamic> json) =>
      _$RegisterOTPVerifyBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterOTPVerifyBodyToJson(this);
}


