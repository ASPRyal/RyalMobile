// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'update_status_body.g.dart';

@JsonSerializable()
class UpdateStatusBody {
  const UpdateStatusBody({
this.is_email_verified,
    this.is_phone_verified,
    this.is_kyc_verified,
    this.is_biometric_verified, 

  });

  final bool ? is_email_verified;
   final bool ? is_phone_verified;
    final bool ? is_kyc_verified;
     final bool ? is_biometric_verified;  

  factory UpdateStatusBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateStatusBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateStatusBodyToJson(this);
}


