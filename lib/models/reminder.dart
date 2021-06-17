import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

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

  Reminder(this.id, this.frequency, this.time);

  static Map<String, dynamic> timeToJson(TimeOfDay e) => {'hour': e.hour, 'minute': e.minute};
  static TimeOfDay timeFromJson(Map<String, dynamic> map) => TimeOfDay(hour: map['hour'], minute: map['minute']);

  @override
  String toString() {
    switch (frequency) {
      case Frequency.daily:
        return 'daily';
      case Frequency.monthly:
        return 'monthly';
      case Frequency.weekly:
        return 'weekly';
    }
  }

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderToJson(this);
}
