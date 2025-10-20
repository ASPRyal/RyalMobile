// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_body.g.dart';

@JsonSerializable()
class VerifyOtpBody {
  const VerifyOtpBody({
    required this.phone_number,
    required this.otp,

  });


  final String phone_number;
  final String otp;
        


  factory VerifyOtpBody.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpBodyFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpBodyToJson(this);
}


