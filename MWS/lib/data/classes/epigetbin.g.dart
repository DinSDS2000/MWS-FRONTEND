// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epigetbin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiGetBin _$EpiGetBinFromJson(Map<String, dynamic> json) => EpiGetBin(
      binNum: json['BinNum'] as String,
      onHandQty: (json['OnHandQty'] as num).toDouble(),
    );

Map<String, dynamic> _$EpiGetBinToJson(EpiGetBin instance) => <String, dynamic>{
      'BinNum': instance.binNum,
      'OnHandQty': instance.onHandQty,
    };
