// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epicompany.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiCompany _$EpiCompanyFromJson(Map<String, dynamic> json) => EpiCompany(
      token: json['token'] as String?,
      companycode: json['Company_Code'] as String?,
      companyname: json['Company_Name'] as String?,
    );

Map<String, dynamic> _$EpiCompanyToJson(EpiCompany instance) =>
    <String, dynamic>{
      'Company_Code': instance.companycode,
      'Company_Name': instance.companyname,
      'token': instance.token,
    };
