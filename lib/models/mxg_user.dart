import 'package:json_annotation/json_annotation.dart';
import 'package:mxg/models/reminder.dart';

part 'mxg_user.g.dart';

@JsonSerializable()
class MxgUser {
  final String id;
  final String firstName;
  final String lastName;
  final Reminder? reminder;

  MxgUser(this.id, this.firstName, this.lastName, this.reminder);
  factory MxgUser.fromJson(Map<String, dynamic> json) =>
      _$MxgUserFromJson(json);
  Map<String, dynamic> toJson() => _$MxgUserToJson(this);
}
