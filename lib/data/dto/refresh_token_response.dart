// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response.g.dart';

@JsonSerializable()
class RefreshTokenResponse {
  const RefreshTokenResponse({
    required this.access_token,
    required this.refresh_token,    
    required this.token_type,
    required this.user_id,
    required this.user_type,


  });

  final String  access_token;
  final String refresh_token;
  final String token_type;
  final String user_id;
  final String user_type;



  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);
}


