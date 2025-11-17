// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epijobhead.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiJobHead _$EpiJobHeadFromJson(Map<String, dynamic> json) => EpiJobHead(
      token: json['token'] as String,
      company: json['company'] as String,
      plant: json['plant'] as String,
      jobnum: json['jobnum'] as String,
      jobtype: json['jobtype'] as String,
      partnum: json['partnum'] as String,
      partdescription: json['partdescription'] as String,
      revisionnum: json['revisionnum'] as String,
      prodqty: (json['prodqty'] as num).toDouble(),
      ium: json['ium'] as String,
    );

Map<String, dynamic> _$EpiJobHeadToJson(EpiJobHead instance) =>
    <String, dynamic>{
      'company': instance.company,
      'plant': instance.plant,
      'jobnum': instance.jobnum,
      'jobtype': instance.jobtype,
      'partnum': instance.partnum,
      'partdescription': instance.partdescription,
      'revisionnum': instance.revisionnum,
      'prodqty': instance.prodqty,
      'ium': instance.ium,
      'token': instance.token,
    };
