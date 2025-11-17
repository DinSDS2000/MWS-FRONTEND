// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epiuom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiUOM _$EpiUOMFromJson(Map<String, dynamic> json) => EpiUOM(
      token: json['token'] as String?,
      uomcode: json['UOMCode'] as String,
      uomdesc: json['UOMDescription'] as String,
    );

Map<String, dynamic> _$EpiUOMToJson(EpiUOM instance) => <String, dynamic>{
      'UOMCode': instance.uomcode,
      'UOMDescription': instance.uomdesc,
      'token': instance.token,
    };
