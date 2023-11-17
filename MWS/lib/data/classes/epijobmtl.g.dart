// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epijobmtl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiJobMtl _$EpiJobMtlFromJson(Map<String, dynamic> json) {
  return EpiJobMtl(
      partnum: json['PartNum'] as String,
      ium: json['IUM'] as String,
      reqqty: json['RequiredQty'] as double,
      previssueqyy: json['TotalIssuedQty'] as double);
}

Map<String, dynamic> _$EpiJobMtlToJson(EpiJobMtl instance) => <String, dynamic>{
      'PartNum': instance.partnum,
      'IUM': instance.ium,
      'RequiredQty': instance.reqqty,
      'TotalIssuedQty': instance.previssueqyy
    };
