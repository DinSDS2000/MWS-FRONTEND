// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epimoveinvreq.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiMoveInvReq _$EpiMoveInvReqFromJson(Map<String, dynamic> json) {
  return EpiMoveInvReq(
      reqnum: json['ReqNum'] as String,
      partnum: json['PartNum'] as String,
      partdesc: json['Description'] as String,
      dtranqty: json['TranQty'],
      frwhse: json['FromWarehouseCode'] as String,
      frbin: json['FromBinNum'] as String,
      frlotnum: json['FromLotNum'] as String,
      towhse: json['ToWarehouseCode'] as String,
      tobin: json['ToBinNum'] as String,
      tolotnum: json['ToLotNum'] as String,
      labelcount: json['LabelCount'] as int);
}

Map<String, dynamic> _$EpiMoveInvReqToJson(EpiMoveInvReq instance) =>
    <String, dynamic>{
      'ReqNum': instance.reqnum,
      'PartNum': instance.partnum,
      'Description': instance.partdesc,
      'TranQty': instance.dtranqty,
      'FromWarehouseCode': instance.frwhse,
      'FromBinNum': instance.frbin,
      'FromLotNum': instance.frlotnum,
      'ToWarehouseCode': instance.towhse,
      'ToBinNum': instance.tobin,
      'ToLotNum': instance.tolotnum,
      'LabelCount': instance.labelcount
    };
