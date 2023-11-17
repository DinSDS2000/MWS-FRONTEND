// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epijoboprresource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiJobOprResource _$EpiJobOprResourceFromJson(Map<String, dynamic> json) {
  return EpiJobOprResource(
      resourceid: json['ResourceId'] as String,
      resourcedesc: json['ResourceDescription'] as String,
      opcode: json['Opcode'] as String,
      resourcegrpid: json['ResourceGroupId'] as String,
      resourcegrpdesc: json['ResourceGroupDescription'] as String);
}

Map<String, dynamic> _$EpiJobOprResourceToJson(EpiJobOprResource instance) =>
    <String, dynamic>{
      'ResourceId': instance.resourceid,
      'ResourceDescription': instance.resourcedesc,
      'Opcode': instance.opcode,
      'ResourceGroupId': instance.resourcegrpid,
      'ResourceGroupDescription': instance.resourcegrpdesc
    };
