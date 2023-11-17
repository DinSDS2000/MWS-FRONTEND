// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epijobtosalvage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiJobToSalvage _$EpiJobToSalvageFromJson(Map<String, dynamic> json) {
  return EpiJobToSalvage(
      company: json['Company'] as String,
      plant: json['Plant'] as String,
      jobnum: json['JobNum'] as String,
      jobpartnum: json['JobPartNum'] as String,
      partnum: json['PartNum'] as String,
      asmseq: json['AssemblySeq'],
      mtlseq: json['MtlSeq'],
      dtranqty: json['dTranQty'], 
      ium: json['IUM'] as String);
}

Map<String, dynamic> _$EpiJobToSalvageToJson(EpiJobToSalvage instance) => <String, dynamic>{
      'Company': instance.company,
      'Plant': instance.plant,
      'JobNum': instance.jobnum,
      'JobType': instance.jobpartnum,
      'PartNum': instance.partnum,
      'AssemblySeq': instance.asmseq,
      'MtlSeq': instance.mtlseq,
      'dTranQty': instance.dtranqty,
      'IUM': instance.ium
    };
