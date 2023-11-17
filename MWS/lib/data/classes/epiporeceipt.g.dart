// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epiporeceipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiPOReceipt _$EpiPOReceiptFromJson(Map<String, dynamic> json) {
  return EpiPOReceipt(
      ponum: json['PONum'],
      podate: json['PODate'] as String,
      vendorid: json['VendorId'] as String,
      vendorname: json['VendorName'] as String,
      buyer: json['Buyer'] as String,
      shipviacode: json['ShipViaCode'] as String,
      termcode: json['TermsCode'] as String,
      purpoint: json['PurPoint'] as String,
      currencycode: json['CurrencyCode'] as String,
      approve: json['Approve'] as bool,
      doctoorder: json['DocTotalOrder'] as double,
      legalnumber: json['LegalNumber'] as String);
}

Map<String, dynamic> _$EpiPOReceiptToJson(EpiPOReceipt instance) =>
    <String, dynamic>{
      'PONum': instance.ponum,
      'PODate': instance.podate,
      'VendorId': instance.vendorid,
      'VendorName': instance.vendorname,
      'Buyer': instance.buyer,
      'ShipViaCode': instance.shipviacode,
      'TermsCode': instance.termcode,
      'PurPoint': instance.purpoint,
      'CurrencyCode': instance.currencycode,
      'Approve': instance.approve,
      'DocTotalOrder': instance.doctoorder,
      'LegalNumber': instance.legalnumber
    };
