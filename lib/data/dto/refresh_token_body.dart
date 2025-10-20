// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_body.g.dart';

@JsonSerializable()
class RefreshTokenBody {
  const RefreshTokenBody({
    required this.refresh_token,

  });

  final String refresh_token;


  factory RefreshTokenBody.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenBodyToJson(this);
}


