// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epipickedtable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiPickedTable _$EpiPickedTableFromJson(Map<String, dynamic> json) =>
    EpiPickedTable(
      key1: json['UD103A_Key1'] as String,
      key2: json['UD103A_Key2'] as String,
      key3: json['UD103A_Key3'] as String,
      childKey1: json['UD103A_ChildKey1'] as String,
      character01: json['UD103A_Character01'] as String,
      character02: json['UD103A_Character02'] as String,
      character03: json['UD103A_Character03'] as String,
      number01: (json['UD103A_Number01'] as num).toDouble(),
      number02: (json['UD103A_Number02'] as num).toDouble(),
      number03: (json['UD103A_Number03'] as num).toDouble(),
      character04: json['UD103A_Character04'] as String,
      character06: json['UD103A_Character06'] as String,
      accumulatedQty: (json['Calculated_AccumulatedQty'] as num).toDouble(),
      remQty: (json['Calculated_RemQty'] as num).toDouble(),
    );

Map<String, dynamic> _$EpiPickedTableToJson(EpiPickedTable instance) =>
    <String, dynamic>{
      'UD103A_Key1': instance.key1,
      'UD103A_Key2': instance.key2,
      'UD103A_Key3': instance.key3,
      'UD103A_ChildKey1': instance.childKey1,
      'UD103A_Character01': instance.character01,
      'UD103A_Character02': instance.character02,
      'UD103A_Character03': instance.character03,
      'UD103A_Number01': instance.number01,
      'UD103A_Number02': instance.number02,
      'UD103A_Number03': instance.number03,
      'UD103A_Character04': instance.character04,
      'UD103A_Character06': instance.character06,
      'Calculated_AccumulatedQty': instance.accumulatedQty,
      'Calculated_RemQty': instance.remQty,
    };
