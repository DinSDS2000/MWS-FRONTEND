// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epireason.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiReason _$EpiReasonFromJson(Map<String, dynamic> json) {
  return EpiReason(
      reasoncode: json['ReasonCode'] as String,
      reasondesc: json['ReasonDescription'] as String);
}

Map<String, dynamic> _$EpiReasonToJson(EpiReason instance) => <String, dynamic>{
      'ReasonCode': instance.reasoncode,
      'ReasonDescription': instance.reasondesc
    };
