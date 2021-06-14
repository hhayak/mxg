// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mxg_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MxgUser _$MxgUserFromJson(Map<String, dynamic> json) {
  return MxgUser(
    json['id'] as String,
    json['firstName'] as String,
    json['lastName'] as String,
  );
}

Map<String, dynamic> _$MxgUserToJson(MxgUser instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'id': instance.id,
    };
