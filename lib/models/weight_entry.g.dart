// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeightEntry _$WeightEntryFromJson(Map<String, dynamic> json) {
  return WeightEntry(
    weight: json['weight'] as int,
    id: json['id'] as String,
    date: WeightEntry.fromTimestamp(json['date'] as Timestamp),
  );
}

Map<String, dynamic> _$WeightEntryToJson(WeightEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weight': instance.weight,
      'date': WeightEntry.toTimestamp(instance.date),
    };
