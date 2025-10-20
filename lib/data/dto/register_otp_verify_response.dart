import 'package:json_annotation/json_annotation.dart';

part 'register_otp_verify_response.g.dart';

@JsonSerializable()
class RegisterOtpVerifyResponse {
  const RegisterOtpVerifyResponse({
    required this.message,

  });

  final String message;

  factory RegisterOtpVerifyResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterOtpVerifyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterOtpVerifyResponseToJson(this);
}


