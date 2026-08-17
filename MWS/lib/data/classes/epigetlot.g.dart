// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epigetlot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiGetLot _$EpiGetLotFromJson(Map<String, dynamic> json) => EpiGetLot(
      lotNum: json['LotNum'] as String,
      onHandQty: (json['OnHandQty'] as num).toDouble(),
    );

Map<String, dynamic> _$EpiGetLotToJson(EpiGetLot instance) => <String, dynamic>{
      'LotNum': instance.lotNum,
      'OnHandQty': instance.onHandQty,
    };
