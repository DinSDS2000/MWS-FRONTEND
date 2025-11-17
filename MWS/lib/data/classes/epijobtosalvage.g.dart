// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epijobtosalvage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiJobToSalvage _$EpiJobToSalvageFromJson(Map<String, dynamic> json) =>
    EpiJobToSalvage(
      token: json['token'] as String,
      company: json['company'] as String,
      plant: json['plant'] as String,
      jobnum: json['jobnum'] as String,
      jobpartnum: json['jobpartnum'] as String,
      partnum: json['partnum'] as String,
      asmseq: (json['asmseq'] as num).toInt(),
      mtlseq: (json['mtlseq'] as num).toInt(),
      dtranqty: (json['dtranqty'] as num).toDouble(),
      ium: json['ium'] as String,
    );

Map<String, dynamic> _$EpiJobToSalvageToJson(EpiJobToSalvage instance) =>
    <String, dynamic>{
      'company': instance.company,
      'plant': instance.plant,
      'jobnum': instance.jobnum,
      'jobpartnum': instance.jobpartnum,
      'partnum': instance.partnum,
      'asmseq': instance.asmseq,
      'mtlseq': instance.mtlseq,
      'dtranqty': instance.dtranqty,
      'ium': instance.ium,
      'token': instance.token,
    };
