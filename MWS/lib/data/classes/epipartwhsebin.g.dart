// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epipartwhsebin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiPartWhseBin _$EpiPartWhseBinFromJson(Map<String, dynamic> json) =>
    EpiPartWhseBin(
      token: json['token'] as String,
      binnum: json['binnum'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$EpiPartWhseBinToJson(EpiPartWhseBin instance) =>
    <String, dynamic>{
      'binnum': instance.binnum,
      'description': instance.description,
      'token': instance.token,
    };
