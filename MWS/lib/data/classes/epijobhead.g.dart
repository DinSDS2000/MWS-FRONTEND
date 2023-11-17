// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epijobhead.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiJobHead _$EpiJobHeadFromJson(Map<String, dynamic> json) {
  return EpiJobHead(
      company: json['Company'] as String,
      plant: json['Plant'] as String,
      jobnum: json['JobNum'] as String,
      jobtype: json['JobType'] as String,
      partnum: json['PartNum'] as String,
      partdescription: json['PartDescription'] as String,
      revisionnum: json['RevisionNum'] as String,
      prodqty: json['ProdQty'], //Decimal.parse(json['ProdQty']),
      ium: json['IUM'] as String);
}

Map<String, dynamic> _$EpiJobHeadToJson(EpiJobHead instance) => <String, dynamic>{
      'Company': instance.company,
      'Plant': instance.plant,
      'JobNum': instance.jobnum,
      'JobType': instance.jobtype,
      'PartNum': instance.partnum,
      'PartDescription': instance.partdescription,
      'RevisionNum': instance.revisionnum,
      'ProdQty': instance.prodqty,
      'IUM': instance.ium
    };
