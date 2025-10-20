// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'register_user_response.g.dart';

@JsonSerializable()
class RegisterUserResponse {
  const RegisterUserResponse({
    required this.message,
    required this.phone_number,
  });

  final String message;
  final String phone_number;

  factory RegisterUserResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterUserResponseToJson(this);
}


