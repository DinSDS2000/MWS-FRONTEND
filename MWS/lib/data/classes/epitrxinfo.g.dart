// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epitrxinfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiTrxInfo _$EpiTrxInfoFromJson(Map<String, dynamic> json) => EpiTrxInfo(
      token: json['token'] as String,
      company: json['company'] as String,
      sysdate: json['sysdate'] as String,
      tranno: (json['tranno'] as num).toInt(),
      trantype: json['trantype'] as String,
      partnum: json['partnum'] as String,
      tranqty: (json['tranqty'] as num).toDouble(),
      whsecode: json['whsecode'] as String,
      binnum: json['binnum'] as String,
      jobnum: json['jobnum'] as String,
      assemblyseq: (json['assemblyseq'] as num).toInt(),
      lotnum: json['lotnum'] as String,
      uom: json['uom'] as String,
      entryperson: json['entryperson'] as String,
    );

Map<String, dynamic> _$EpiTrxInfoToJson(EpiTrxInfo instance) =>
    <String, dynamic>{
      'company': instance.company,
      'sysdate': instance.sysdate,
      'tranno': instance.tranno,
      'trantype': instance.trantype,
      'partnum': instance.partnum,
      'tranqty': instance.tranqty,
      'whsecode': instance.whsecode,
      'binnum': instance.binnum,
      'jobnum': instance.jobnum,
      'assemblyseq': instance.assemblyseq,
      'lotnum': instance.lotnum,
      'uom': instance.uom,
      'entryperson': instance.entryperson,
      'token': instance.token,
    };
