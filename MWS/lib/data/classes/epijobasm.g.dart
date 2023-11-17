// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epijobasm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiJobAsm _$EpiJobAsmFromJson(Map<String, dynamic> json) {
  return EpiJobAsm(
      partnum: json['PartNum'] as String,
      ium: json['IUM'] as String,
      reqqty: json['RequiredQty'] as double,
      previssueqyy: json['IssuedQty'] as double);
}

Map<String, dynamic> _$EpiJobAsmToJson(EpiJobAsm instance) => <String, dynamic>{
      'PartNum': instance.partnum,
      'IUM': instance.ium,
      'RequiredQty': instance.reqqty,
      'IssuedQty': instance.previssueqyy
    };
