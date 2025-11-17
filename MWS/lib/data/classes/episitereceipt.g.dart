// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episitereceipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiSiteReceipt _$EpiSiteReceiptFromJson(Map<String, dynamic> json) =>
    EpiSiteReceipt(
      token: json['token'] as String?,
      company: json['UD09_Company'] as String?,
      trandate: json['UD09_Date01'] as String?,
      whsedescription: json['Warehse_Description'] as String?,
      bindescription: json['WhseBin_Description'] as String?,
      jobnum: json['UD09_Key3'] as String?,
      partnum: json['UD09_ShortChar01'] as String?,
      partdescription: json['UD09_Character01'] as String?,
      tranqty: json['UD09_Number02'] as num?,
      uom: json['UD09_ShortChar02'] as String?,
      refno: json['UD09_Key1'] as String?,
      seqno: json['Calculated_SeqNo'] as String?,
      rcvdqty: json['rcvdqty'] as num?,
      submitqty: json['Calculated_TotalSubmitQty'] as num?,
      fullrcv: json['fullrcv'] as bool?,
    );

Map<String, dynamic> _$EpiSiteReceiptToJson(EpiSiteReceipt instance) =>
    <String, dynamic>{
      'UD09_Company': instance.company,
      'UD09_ShortChar01': instance.partnum,
      'UD09_Character01': instance.partdescription,
      'UD09_Date01': instance.trandate,
      'Warehse_Description': instance.whsedescription,
      'WhseBin_Description': instance.bindescription,
      'UD09_Key3': instance.jobnum,
      'UD09_Number02': instance.tranqty,
      'UD09_ShortChar02': instance.uom,
      'UD09_Key1': instance.refno,
      'Calculated_SeqNo': instance.seqno,
      'rcvdqty': instance.rcvdqty,
      'Calculated_TotalSubmitQty': instance.submitqty,
      'fullrcv': instance.fullrcv,
      'token': instance.token,
    };
