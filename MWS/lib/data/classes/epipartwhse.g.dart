// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epipartwhse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiPartWhse _$EpiPartWhseFromJson(Map<String, dynamic> json) => EpiPartWhse(
      token: json['token'] as String,
      warehousedescription: json['warehousedescription'] as String,
      whsebinlist: (json['whsebinlist'] as List<dynamic>)
          .map((e) => EpiPartWhseBin.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EpiPartWhseToJson(EpiPartWhse instance) =>
    <String, dynamic>{
      'warehousedescription': instance.warehousedescription,
      'whsebinlist': instance.whsebinlist,
      'token': instance.token,
    };
