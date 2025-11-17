// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epijoboprresource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiJobOprResource _$EpiJobOprResourceFromJson(Map<String, dynamic> json) =>
    EpiJobOprResource(
      token: json['token'] as String,
      resourceid: json['resourceid'] as String,
      resourcedesc: json['resourcedesc'] as String,
      opcode: json['opcode'] as String,
      resourcegrpid: json['resourcegrpid'] as String,
      resourcegrpdesc: json['resourcegrpdesc'] as String,
    );

Map<String, dynamic> _$EpiJobOprResourceToJson(EpiJobOprResource instance) =>
    <String, dynamic>{
      'resourceid': instance.resourceid,
      'resourcedesc': instance.resourcedesc,
      'opcode': instance.opcode,
      'resourcegrpid': instance.resourcegrpid,
      'resourcegrpdesc': instance.resourcegrpdesc,
      'token': instance.token,
    };
