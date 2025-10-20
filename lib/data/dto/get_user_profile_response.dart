// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'get_user_profile_response.g.dart';

@JsonSerializable()
class GetUserProfileResponse {
  const GetUserProfileResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.phone_number,
    required this.user_type,
  this.qid,
    required this.mcit_number,
    required this.nationality,
    required this.lang,
    required this.is_active,
    required this.is_email_verified,
    required this.is_phone_verified,
    required this.is_kyc_verified,
    required this.is_biometric_verified,
    required this.is_mpin,
    required this.kyc_status,
    required this.created_on,
    required this.updated_on,





  });

  final int id;
  final String name;
  final String email;
  final String phone_number;
  final String user_type;
  final String? qid;
  final String? mcit_number;
  final String nationality;
  final String lang;
  final bool is_active;
  final bool is_email_verified;
  final bool is_phone_verified;
  final bool is_kyc_verified;
  final bool is_biometric_verified;
  final bool is_mpin;
  final String kyc_status;
  final String  created_on;
  final String  updated_on;








  factory GetUserProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserProfileResponseToJson(this);
}
