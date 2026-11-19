// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epigetbin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiGetBin _$EpiGetBinFromJson(Map<String, dynamic> json) => EpiGetBin(
      binNum: json['PartBin_BinNum'] as String,
      onHandQty: (json['Calculated_SumOnHandQty'] as num).toDouble(),
    );

Map<String, dynamic> _$EpiGetBinToJson(EpiGetBin instance) => <String, dynamic>{
      'PartBin_BinNum': instance.binNum,
      'Calculated_SumOnHandQty': instance.onHandQty,
    };
