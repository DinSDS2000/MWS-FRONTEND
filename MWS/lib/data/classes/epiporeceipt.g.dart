// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epiporeceipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiPOReceipt _$EpiPOReceiptFromJson(Map<String, dynamic> json) => EpiPOReceipt(
      token: json['token'] as String,
      ponum: (json['ponum'] as num).toInt(),
      podate: json['podate'] as String,
      vendorid: json['vendorid'] as String,
      vendorname: json['vendorname'] as String,
      buyer: json['buyer'] as String,
      shipviacode: json['shipviacode'] as String,
      termcode: json['termcode'] as String,
      purpoint: json['purpoint'] as String,
      currencycode: json['currencycode'] as String,
      approve: json['approve'] as bool,
      doctoorder: (json['doctoorder'] as num).toDouble(),
      legalnumber: json['legalnumber'] as String,
      exemptionno: json['exemptionno'] as String,
    );

Map<String, dynamic> _$EpiPOReceiptToJson(EpiPOReceipt instance) =>
    <String, dynamic>{
      'ponum': instance.ponum,
      'podate': instance.podate,
      'vendorid': instance.vendorid,
      'vendorname': instance.vendorname,
      'buyer': instance.buyer,
      'shipviacode': instance.shipviacode,
      'termcode': instance.termcode,
      'purpoint': instance.purpoint,
      'currencycode': instance.currencycode,
      'approve': instance.approve,
      'doctoorder': instance.doctoorder,
      'legalnumber': instance.legalnumber,
      'exemptionno': instance.exemptionno,
      'token': instance.token,
    };
