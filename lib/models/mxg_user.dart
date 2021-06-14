import 'package:json_annotation/json_annotation.dart';

part 'mxg_user.g.dart';

@JsonSerializable()
class MxgUser {
  final String firstName;
  final String lastName;
  final String id;

  MxgUser(this.id, this.firstName, this.lastName);
  factory MxgUser.fromJson(Map<String, dynamic> json) => _$MxgUserFromJson(json);
  Map<String, dynamic> toJson() => _$MxgUserToJson(this);
}