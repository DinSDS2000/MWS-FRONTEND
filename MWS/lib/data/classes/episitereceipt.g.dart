// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episitereceipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiSiteReceipt _$EpiSiteReceiptFromJson(Map<String, dynamic> json) =>
    EpiSiteReceipt(
      token: json['token'] as String,
      company: json['company'] as String,
      trandate: json['trandate'] as String,
      whsedescription: json['whsedescription'] as String,
      bindescription: json['bindescription'] as String,
      jobnum: json['jobnum'] as String,
      partnum: json['partnum'] as String,
      partdescription: json['partdescription'] as String,
      tranqty: json['tranqty'] as num,
      uom: json['uom'] as String,
      refno: json['refno'] as String,
      seqno: json['seqno'] as String,
      rcvdqty: json['rcvdqty'] as num,
      submitqty: json['submitqty'] as num,
      fullrcv: json['fullrcv'] as bool,
    );

Map<String, dynamic> _$EpiSiteReceiptToJson(EpiSiteReceipt instance) =>
    <String, dynamic>{
      'company': instance.company,
      'partnum': instance.partnum,
      'partdescription': instance.partdescription,
      'trandate': instance.trandate,
      'whsedescription': instance.whsedescription,
      'bindescription': instance.bindescription,
      'jobnum': instance.jobnum,
      'tranqty': instance.tranqty,
      'uom': instance.uom,
      'refno': instance.refno,
      'seqno': instance.seqno,
      'rcvdqty': instance.rcvdqty,
      'submitqty': instance.submitqty,
      'fullrcv': instance.fullrcv,
      'token': instance.token,
    };
