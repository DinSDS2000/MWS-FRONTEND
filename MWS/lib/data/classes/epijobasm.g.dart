// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epijobasm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiJobAsm _$EpiJobAsmFromJson(Map<String, dynamic> json) => EpiJobAsm(
      token: json['token'] as String?,
      partnum: json['PartNum'] as String,
      ium: json['IUM'] as String,
      reqqty: (json['RequiredQty'] as num).toDouble(),
      previssueqyy: (json['IssuedQty'] as num).toDouble(),
    );

Map<String, dynamic> _$EpiJobAsmToJson(EpiJobAsm instance) => <String, dynamic>{
      'PartNum': instance.partnum,
      'IUM': instance.ium,
      'RequiredQty': instance.reqqty,
      'IssuedQty': instance.previssueqyy,
      'token': instance.token,
    };
