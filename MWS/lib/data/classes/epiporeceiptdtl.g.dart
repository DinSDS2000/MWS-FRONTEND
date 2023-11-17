// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epiporeceiptdtl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiPOReceiptDtl _$EpiPOReceiptDtlFromJson(Map<String, dynamic> json) {
  return EpiPOReceiptDtl(
      ponum: json['PONum'],
      poline: json['POLine'],
      polinerel: json['POLineRel'],
      partnum: json['PartNum'] as String,
      partdesc: json['PartDesc'] as String,
      dporelqty: json['PORelQty'],
      vendorid: json['VendorID'] as String,
      vendornum: json['VendorNum'],
      whse: json['WarehouseCode'] as String,
      bin: json['BinNum'] as String,
      lotnum: json['LotNum'] as String);
}

Map<String, dynamic> _$EpiPOReceiptDtlToJson(EpiPOReceiptDtl instance) =>
    <String, dynamic>{
      'PONum': instance.ponum,
      'POLine': instance.poline,
      'POLineRel': instance.polinerel,
      'PartNum': instance.partnum,
      'PartDesc': instance.partdesc,
      'PORelQty': instance.dporelqty,
      'VendorID': instance.vendorid,
      'VendorNum': instance.vendornum,
      'WarehouseCode': instance.whse,
      'BinNum': instance.bin,
      'LotNum': instance.lotnum
    };
