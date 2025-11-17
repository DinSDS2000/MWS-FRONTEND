// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epijobmtlreqqty.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiJobMtlReqQty _$EpiJobMtlReqQtyFromJson(Map<String, dynamic> json) =>
    EpiJobMtlReqQty(
      token: json['token'] as String?,
      partnum: json['PartNum'] as String,
      qtyper: (json['QtyPer'] as num).toInt(),
      IUM: json['IUM'] as String,
    );

Map<String, dynamic> _$EpiJobMtlReqQtyToJson(EpiJobMtlReqQty instance) =>
    <String, dynamic>{
      'PartNum': instance.partnum,
      'QtyPer': instance.qtyper,
      'IUM': instance.IUM,
      'token': instance.token,
    };
