// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'register_user_body.g.dart';

@JsonSerializable()
class RegisterUserBody {
  const RegisterUserBody({
    required this.name,
    required this.email,
    required this.phone_number,
    required this.user_type,
    required this.qid,
    required this.nationality,

    
this.mcit_number,        

  });

  final String name;
  final String email;
  final String phone_number;
  final String user_type;
final String    nationality;
  final String qid;
      final String? mcit_number;
        


  factory RegisterUserBody.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterUserBodyToJson(this);
}


