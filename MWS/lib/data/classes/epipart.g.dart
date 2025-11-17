// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epipart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiPart _$EpiPartFromJson(Map<String, dynamic> json) => EpiPart(
      token: json['Token'] as String?,
      partdescription: json['PartDescription'] as String,
      ium: json['IUM'] as String,
      tracklots: json['TrackLots'] as bool,
      attbatch: json['AttBatch'] as String,
      attmfgbatch: json['AttMfgBatch'] as String,
      attmfglot: json['AttMfgLot'] as String,
      attheat: json['AttHeat'] as String,
      attfirmware: json['AttFirmware'] as String,
      attbeforedt: json['AttBeforeDt'] as String,
      attmfgdt: json['AttMfgDt'] as String,
      attcuredt: json['AttCureDt'] as String,
      attexpdt: json['AttExpDt'] as String,
    );

Map<String, dynamic> _$EpiPartToJson(EpiPart instance) => <String, dynamic>{
      'PartDescription': instance.partdescription,
      'IUM': instance.ium,
      'TrackLots': instance.tracklots,
      'AttBatch': instance.attbatch,
      'AttMfgBatch': instance.attmfgbatch,
      'AttMfgLot': instance.attmfglot,
      'AttHeat': instance.attheat,
      'AttFirmware': instance.attfirmware,
      'AttBeforeDt': instance.attbeforedt,
      'AttMfgDt': instance.attmfgdt,
      'AttCureDt': instance.attcuredt,
      'AttExpDt': instance.attexpdt,
      'Token': instance.token,
    };
