import 'package:json_annotation/json_annotation.dart';

part 'task_reponse.g.dart';

@JsonSerializable()
class TaskReposeModel {
  String? id;
  String? name;
  String? avatar;
  String? createdAt;

  TaskReposeModel({this.id, this.name, this.avatar, this.createdAt});

  factory TaskReposeModel.fromJson(Map<String, dynamic> json) => _$TaskReposeModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskReposeModelToJson(this);
}