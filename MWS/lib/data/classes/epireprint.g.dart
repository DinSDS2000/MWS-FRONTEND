// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epireprint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiReprintInfo _$EpiReprintInfoFromJson(Map<String, dynamic> json) =>
    EpiReprintInfo(
      company: json['Part_Company'] as String,
      partNum: json['Part_PartNum'] as String,
      partDesc: json['Part_PartDescription'] as String,
      lotNum: json['PartTran_LotNum'] as String?,
      fromSeq: (json['PartTran_SD_FromSeq_c'] as num?)?.toInt(),
      toSeq: (json['PartTran_SD_ToSeq_c'] as num?)?.toInt(),
      batch: json['PartLot_Batch'] as String?,
      sysDate: json['PartTran_SysDate'] as String?,
      tranType: json['PartTran_TranType'] as String?,
      tranNum: (json['PartTran_TranNum'] as num).toInt(),
    );

Map<String, dynamic> _$EpiReprintInfoToJson(EpiReprintInfo instance) =>
    <String, dynamic>{
      'Part_Company': instance.company,
      'Part_PartNum': instance.partNum,
      'Part_PartDescription': instance.partDesc,
      'PartTran_LotNum': instance.lotNum,
      'PartTran_SD_FromSeq_c': instance.fromSeq,
      'PartTran_SD_ToSeq_c': instance.toSeq,
      'PartLot_Batch': instance.batch,
      'PartTran_SysDate': instance.sysDate,
      'PartTran_TranType': instance.tranType,
      'PartTran_TranNum': instance.tranNum,
    };
