// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epireason.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiReason _$EpiReasonFromJson(Map<String, dynamic> json) => EpiReason(
      token: json['token'] as String?,
      reasoncode: json['ReasonCode'] as String,
      reasondesc: json['Description'] as String,
    );

Map<String, dynamic> _$EpiReasonToJson(EpiReason instance) => <String, dynamic>{
      'ReasonCode': instance.reasoncode,
      'Description': instance.reasondesc,
      'token': instance.token,
    };
