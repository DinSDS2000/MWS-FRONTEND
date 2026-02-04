// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epitrxinfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiTrxInfo _$EpiTrxInfoFromJson(Map<String, dynamic> json) => EpiTrxInfo(
      token: json['token'] as String?,
      company: json['Company'] as String,
      sysdate: json['SysDate'] as String,
      tranno: (json['TranNo'] as num).toInt(),
      trantype: json['TranType'] as String,
      partnum: json['PartNum'] as String,
      tranqty: (json['TranQty'] as num).toDouble(),
      whsecode: json['WarehouseCode'] as String,
      binnum: json['BinNum'] as String,
      jobnum: json['JobNum'] as String,
      assemblyseq: (json['AssemblySeq'] as num).toInt(),
      lotnum: json['LotNum'] as String,
      uom: json['UOM'] as String,
      entryperson: json['EntryPerson'] as String,
    );

Map<String, dynamic> _$EpiTrxInfoToJson(EpiTrxInfo instance) =>
    <String, dynamic>{
      'Company': instance.company,
      'SysDate': instance.sysdate,
      'TranNo': instance.tranno,
      'TranType': instance.trantype,
      'PartNum': instance.partnum,
      'TranQty': instance.tranqty,
      'WarehouseCode': instance.whsecode,
      'BinNum': instance.binnum,
      'JobNum': instance.jobnum,
      'AssemblySeq': instance.assemblyseq,
      'LotNum': instance.lotnum,
      'UOM': instance.uom,
      'EntryPerson': instance.entryperson,
      'token': instance.token,
    };
