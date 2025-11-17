// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epijobmtl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiJobMtl _$EpiJobMtlFromJson(Map<String, dynamic> json) => EpiJobMtl(
      token: json['token'] as String?,
      partnum: json['PartNum'] as String,
      ium: json['IUM'] as String,
      reqqty: (json['RequiredQty'] as num).toDouble(),
      previssueqyy: (json['TotalIssuedQty'] as num).toDouble(),
    );

Map<String, dynamic> _$EpiJobMtlToJson(EpiJobMtl instance) => <String, dynamic>{
      'PartNum': instance.partnum,
      'IUM': instance.ium,
      'RequiredQty': instance.reqqty,
      'TotalIssuedQty': instance.previssueqyy,
      'token': instance.token,
    };
