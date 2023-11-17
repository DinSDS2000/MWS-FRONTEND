// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episplitmergeuom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiSplitMergeUOM _$EpiSplitMergeUOMFromJson(Map<String, dynamic> json) {
  return EpiSplitMergeUOM(
      rowno: json['RowNo'] as int,
      company: json['Company'] as String,
      partnum: json['PartNum'] as String,
      whsecode: json['WarehouseCode'] as String,
      binnum: json['BinNum'] as String,
      lotnum: json['LotNum'] as String,
      onhandqty: json['OnHandQty'] as double,
      qty: json['Qty'] as double,
      ium: json['UOM'] as String,
      convfact: json['ConvFact'] as double,
      convfactuom: json['ConvFactUOM'] as String,
      allocatedqty: json['AllocatedQty'] as double);
}

Map<String, dynamic> _$EpiSplitMergeUOMToJson(EpiSplitMergeUOM instance) =>
    <String, dynamic>{
      '"RowNo"': instance.rowno,
      '"Company"': '"' + instance.company + '"',
      '"PartNum"': '"' + instance.partnum + '"',
      '"WarehouseCode"': '"' + instance.whsecode + '"',
      '"BinNum"': '"' + instance.binnum + '"',
      '"LotNum"': '"' + instance.lotnum + '"',
      '"OnHandQty"': instance.onhandqty,
      '"Qty"': instance.qty,
      '"UOM"': '"' + instance.ium + '"', 
      '"ConvFact"': instance.convfact,
      '"ConvFactUOM"': '"' + instance.convfactuom + '"',
      '"AllocatedQty"': instance.allocatedqty
    };
