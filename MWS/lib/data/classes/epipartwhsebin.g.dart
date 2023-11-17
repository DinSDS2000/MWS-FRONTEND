// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epipartwhsebin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiPartWhseBin _$EpiPartWhseBinFromJson(Map<String, dynamic> json) {
  return EpiPartWhseBin(
      binnum: json['BinNum'] as String,
      description: json['Description'] as String);
}

Map<String, dynamic> _$EpiPartWhseBinToJson(EpiPartWhseBin instance) => <String, dynamic>{
      'BinNum': instance.binnum,
      'Description': instance.description
    };
