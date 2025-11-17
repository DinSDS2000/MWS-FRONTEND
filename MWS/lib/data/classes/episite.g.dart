// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiSite _$EpiSiteFromJson(Map<String, dynamic> json) => EpiSite(
      token: json['token'] as String?,
      company: json['Company'] as String,
      siteplant: json['SitePlant'] as String,
      name: json['Name'] as String,
    );

Map<String, dynamic> _$EpiSiteToJson(EpiSite instance) => <String, dynamic>{
      'Company': instance.company,
      'SitePlant': instance.siteplant,
      'Name': instance.name,
      'token': instance.token,
    };
