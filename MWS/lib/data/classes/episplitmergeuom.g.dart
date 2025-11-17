// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episplitmergeuom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiSplitMergeUOM _$EpiSplitMergeUOMFromJson(Map<String, dynamic> json) =>
    EpiSplitMergeUOM(
      token: json['token'] as String?,
      rowno: (json['RowNo'] as num).toInt(),
      company: json['Company'] as String,
      partnum: json['PartNum'] as String,
      whsecode: json['WarehouseCode'] as String,
      binnum: json['BinNum'] as String,
      lotnum: json['LotNum'] as String,
      onhandqty: (json['OnHandQty'] as num).toDouble(),
      qty: (json['Qty'] as num).toDouble(),
      ium: json['UOM'] as String,
      convfact: (json['ConvFact'] as num).toDouble(),
      convfactuom: json['ConvFactUOM'] as String,
      allocatedqty: (json['AllocatedQty'] as num).toDouble(),
    );

Map<String, dynamic> _$EpiSplitMergeUOMToJson(EpiSplitMergeUOM instance) =>
    <String, dynamic>{
      'RowNo': instance.rowno,
      'Company': instance.company,
      'PartNum': instance.partnum,
      'WarehouseCode': instance.whsecode,
      'BinNum': instance.binnum,
      'LotNum': instance.lotnum,
      'OnHandQty': instance.onhandqty,
      'Qty': instance.qty,
      'UOM': instance.ium,
      'ConvFact': instance.convfact,
      'ConvFactUOM': instance.convfactuom,
      'AllocatedQty': instance.allocatedqty,
      'token': instance.token,
    };
