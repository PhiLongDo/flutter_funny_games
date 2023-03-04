// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_reponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskReposeModel _$TaskReposeModelFromJson(Map<String, dynamic> json) =>
    TaskReposeModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$TaskReposeModelToJson(TaskReposeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'createdAt': instance.createdAt,
    };
