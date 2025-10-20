import 'package:json_annotation/json_annotation.dart';

part 'set_mpin_body.g.dart';

@JsonSerializable()
class SetMpinBody {
  const SetMpinBody({
required this.mpin,

  });

     final String mpin;  

  factory SetMpinBody.fromJson(Map<String, dynamic> json) =>
      _$SetMpinBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SetMpinBodyToJson(this);
}


