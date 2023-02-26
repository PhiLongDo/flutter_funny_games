import 'package:json_annotation/json_annotation.dart';

part 'login_reponse.g.dart';

@JsonSerializable()
class LoginReposeModel {
  @JsonKey(name: "user_name")
  final String userName;
  @JsonKey(name: "user_id")
  final String userId;
  @JsonKey(defaultValue: null)
  final String? token;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? noJsonKey;

  LoginReposeModel({required this.userName, required this.userId, this.token, this.noJsonKey});

  factory LoginReposeModel.fromJson(Map<String, dynamic> json) =>
      _$LoginReposeModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginReposeModelToJson(this);
}
