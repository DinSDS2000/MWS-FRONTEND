// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epiporeceiptdtl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiPOReceiptDtl _$EpiPOReceiptDtlFromJson(Map<String, dynamic> json) =>
    EpiPOReceiptDtl(
      ponum: (json['PONum'] as num).toInt(),
      poline: (json['POLine'] as num).toInt(),
      polinerel: (json['POLineRel'] as num).toInt(),
      vendorid: json['VendorID'] as String,
      vendornum: (json['VendorNum'] as num).toInt(),
      partnum: json['PartNum'] as String,
      partdesc: json['PartDesc'] as String,
      company: json['Company'] as String?,
      packslip: json['PackSlip'] as String?,
      whse: json['WarehouseCode'] as String?,
      bin: json['BinNum'] as String?,
      lotnum: json['LotNum'] as String?,
      tranqty: (json['TranQty'] as num?)?.toDouble() ?? 0,
      recvuom: json['RecvUOM'] as String?,
      porelqty: (json['PORelQty'] as num?)?.toDouble() ?? 0,
      entryperson: json['EntryPerson'] as String?,
      openorder: json['OpenOrder'] as bool? ?? false,
      labelcount: (json['LabelCount'] as num?)?.toInt() ?? 0,
      legalnumber: json['LegalNumber'] as String?,
      porelplant: json['PORelPlant'] as String?,
      porelwarehouse: json['PORelWarehouse'] as String?,
      receivedqty: (json['ReceivedQty'] as num?)?.toDouble() ?? 0,
      arrivedqty: (json['ArrivedQty'] as num?)?.toDouble() ?? 0,
      balancedqty: (json['BalancedQty'] as num?)?.toDouble() ?? 0,
      poqty: (json['POQty'] as num?)?.toDouble() ?? 0,
      approve: json['Approve'] as bool? ?? false,
      confirmed: json['Confirmed'] as bool? ?? false,
      podate: json['PODate'] as String?,
      packline: (json['PackLine'] as num?)?.toInt() ?? 0,
      exemptionno: json['ExemptionNo'] as String?,
      purpoint: json['PurPoint'] as String?,
      ourQty: (json['OurQty'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$EpiPOReceiptDtlToJson(EpiPOReceiptDtl instance) =>
    <String, dynamic>{
      'Company': instance.company,
      'PONum': instance.ponum,
      'POLine': instance.poline,
      'POLineRel': instance.polinerel,
      'VendorID': instance.vendorid,
      'VendorNum': instance.vendornum,
      'PartNum': instance.partnum,
      'PartDesc': instance.partdesc,
      'PackSlip': instance.packslip,
      'WarehouseCode': instance.whse,
      'BinNum': instance.bin,
      'LotNum': instance.lotnum,
      'TranQty': instance.tranqty,
      'RecvUOM': instance.recvuom,
      'PORelQty': instance.porelqty,
      'EntryPerson': instance.entryperson,
      'OpenOrder': instance.openorder,
      'LabelCount': instance.labelcount,
      'LegalNumber': instance.legalnumber,
      'PORelPlant': instance.porelplant,
      'PORelWarehouse': instance.porelwarehouse,
      'ReceivedQty': instance.receivedqty,
      'ArrivedQty': instance.arrivedqty,
      'BalancedQty': instance.balancedqty,
      'POQty': instance.poqty,
      'Approve': instance.approve,
      'Confirmed': instance.confirmed,
      'PODate': instance.podate,
      'PackLine': instance.packline,
      'PurPoint': instance.purpoint,
      'ExemptionNo': instance.exemptionno,
      'OurQty': instance.ourQty,
    };
