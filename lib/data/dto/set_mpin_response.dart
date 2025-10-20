// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'set_mpin_response.g.dart';

@JsonSerializable()
class SetMpinResponse {
  const SetMpinResponse({
    required this.message,
    required this.user_id,
    required this.is_mpin,



  });

  final String message;
  final int user_id;
  final bool is_mpin;



  factory SetMpinResponse.fromJson(Map<String, dynamic> json) =>
      _$SetMpinResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SetMpinResponseToJson(this);
}

