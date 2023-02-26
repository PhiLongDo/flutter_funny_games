// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_reponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginReposeModel _$LoginReposeModelFromJson(Map<String, dynamic> json) =>
    LoginReposeModel(
      userName: json['user_name'] as String,
      userId: json['user_id'] as String,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$LoginReposeModelToJson(LoginReposeModel instance) =>
    <String, dynamic>{
      'user_name': instance.userName,
      'user_id': instance.userId,
      'token': instance.token,
    };
