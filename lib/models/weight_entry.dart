import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weight_entry.g.dart';

@JsonSerializable()
class WeightEntry {
  final String id;
  final int weight;
  @JsonKey(toJson: toTimestamp, fromJson: fromTimestamp)
  final DateTime date;

  static Timestamp toTimestamp(DateTime date) => Timestamp.fromDate(date);

  static DateTime fromTimestamp(Timestamp date) => date.toDate();

  WeightEntry({required this.weight, required this.id, required this.date});
  factory WeightEntry.fromJson(Map<String, dynamic> json) =>
      _$WeightEntryFromJson(json);
  Map<String, dynamic> toJson() => _$WeightEntryToJson(this);
}
