// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epidocustinfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiDOCustInfo _$EpiDOCustInfoFromJson(Map<String, dynamic> json) {
  return EpiDOCustInfo(
      company: json['Company'] as String,
      custid: json['CustID'] as String,
      custnum: json['CustNum'] as int,
      custname: json['CustName'] as String,
      custaddress: json['CustAddress'] as String
  );      
}

Map<String, dynamic> _$EpiDOCustInfoToJson(EpiDOCustInfo instance) => <String, dynamic>{
      'Company': instance.company,
      'CustID': instance.custid,
      'CustNum': instance.custnum,
      'CustName': instance.custname,
      'CustAddress': instance.custaddress
    };
