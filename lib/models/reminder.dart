import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:get/get_utils/get_utils.dart';

part 'reminder.g.dart';

enum Frequency {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
}

@JsonSerializable()
class Reminder {
  final int id;
  final Frequency frequency;
  @JsonKey(toJson: timeToJson, fromJson: timeFromJson)
  final TimeOfDay time;
  final int? weekday;

  static Map<int, String> weekdays = {
    1: 'monday',
    2: 'tuesday',
    3: 'wednesday',
    4: 'thursday',
    5: 'friday',
    6: 'saturday',
    7: 'sunday'
  };

  Reminder(this.id, this.frequency, this.time, this.weekday);

  static Map<String, dynamic> timeToJson(TimeOfDay e) =>
      {'hour': e.hour, 'minute': e.minute};

  static TimeOfDay timeFromJson(Map<String, dynamic> map) =>
      TimeOfDay(hour: map['hour'], minute: map['minute']);

  String toStr(BuildContext context) {
    switch (frequency) {
      case Frequency.daily:
        return 'Daily at ${time.format(context)}.';
      case Frequency.monthly:
        return 'monthly';
      case Frequency.weekly:
        return 'Weekly, every ${weekdays[weekday]!.capitalize}, at ${time.format(context)}.';
    }
  }

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderToJson(this);
}
