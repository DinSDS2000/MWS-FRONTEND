// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epidocustinfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiDOCustInfo _$EpiDOCustInfoFromJson(Map<String, dynamic> json) =>
    EpiDOCustInfo(
      token: json['token'] as String,
      company: json['company'] as String,
      custid: json['custid'] as String,
      custnum: (json['custnum'] as num).toInt(),
      custname: json['custname'] as String,
      custaddress: json['custaddress'] as String,
    );

Map<String, dynamic> _$EpiDOCustInfoToJson(EpiDOCustInfo instance) =>
    <String, dynamic>{
      'company': instance.company,
      'custid': instance.custid,
      'custnum': instance.custnum,
      'custname': instance.custname,
      'custaddress': instance.custaddress,
      'token': instance.token,
    };
