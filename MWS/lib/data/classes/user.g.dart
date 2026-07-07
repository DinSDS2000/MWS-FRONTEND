// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      token: json['token'] as String? ?? '',
      epicuserid: json['Epic_UserId'] as String? ?? '',
      epicpasskey: json['Epic_PassKey'] as String? ?? '',
      epicusername: json['Epic_UserName'] as String? ?? '',
      epiccompany: json['Epic_Company'] as String? ?? '',
      epiccurcompany: json['Epic_CurCompany'] as String? ?? '',
      epiccurcompanyname: json['Epic_CurCompanyName'] as String? ?? '',
      epicplant: json['Epic_Plant'] as String? ?? '',
      epicplantname: json['Epic_PlantName'] as String? ?? '',
      epiempid: json['Epic_EmpId'] as String? ?? '',
      epicenableissuematerial: json['IsEnable_MiscIssue'] as bool? ?? false,
      epicenablemoveinventory: json['IsEnable_MoveInventory'] as bool? ?? false,
      epicenablereturnmaterial:
          json['IsEnable_ReturnMaterial'] as bool? ?? false,
      epicenablemoveinventoryrequest:
          json['IsEnable_MoveInventoryRequest'] as bool? ?? false,
      epicenableacceptinventoryrequest:
          json['IsEnable_MoveInventoryApproval'] as bool? ?? false,
      epicenablejobtoinventory: json['IsEnable_JobReceipts'] as bool? ?? false,
      epicenablejobtosalvage:
          json['IsEnable_SalvageReceipts'] as bool? ?? false,
      epicenableporeceipt: json['IsEnable_POReceipts'] as bool? ?? false,
      epienableissueassembly: json['IsEnable_IssueAssembly'] as bool? ?? false,
      epicenablereturnassembly:
          json['IsEnable_ReturnAssembly'] as bool? ?? false,
      epienablesplitmergeuom: json['IsEnable_SplitMergeUOM'] as bool? ?? false,
      epienabledeliverytracking:
          json['IsEnable_DeliveryTrack'] as bool? ?? false,
      epienablereprintlabel: json['IsEnable_Reprint'] as bool? ?? false,
      epienableissuemiscmaterial:
          json['IsEnable_IssueMiscMaterial'] as bool? ?? false,
      epienablereturnmiscmaterial:
          json['IsEnable_ReturnMiscMaterial'] as bool? ?? false,
      epienableqtyadjustment: json['IsEnable_QtyAdjustment'] as bool? ?? false,
      epienableclockin: json['IsEnable_ClockInOut'] as bool? ?? false,
      epienablestartoperation: json['IsEnable_StartEndOp'] as bool? ?? false,
      epienablematerialpicking:
          json['IsEnable_MaterialPicking'] as bool? ?? false,
      epienablematerialloading:
          json['IsEnable_MaterialLoading'] as bool? ?? false,
      epienableworkqueue: json['IsEnable_WorkQueue'] as bool? ?? false,
      epienabledefaultlabelqty:
          json['IsEnable_UseDefaultLabelQty'] as bool? ?? false,
      epiprinter: json['Printer'] as String? ?? '',
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'Epic_UserId': instance.epicuserid,
      'Epic_PassKey': instance.epicpasskey,
      'Epic_UserName': instance.epicusername,
      'Epic_Company': instance.epiccompany,
      'Epic_CurCompany': instance.epiccurcompany,
      'Epic_CurCompanyName': instance.epiccurcompanyname,
      'Epic_Plant': instance.epicplant,
      'Epic_PlantName': instance.epicplantname,
      'Epic_EmpId': instance.epiempid,
      'IsEnable_MiscIssue': instance.epicenableissuematerial,
      'IsEnable_MoveInventory': instance.epicenablemoveinventory,
      'IsEnable_ReturnMaterial': instance.epicenablereturnmaterial,
      'IsEnable_MoveInventoryRequest': instance.epicenablemoveinventoryrequest,
      'IsEnable_MoveInventoryApproval':
          instance.epicenableacceptinventoryrequest,
      'IsEnable_JobReceipts': instance.epicenablejobtoinventory,
      'IsEnable_SalvageReceipts': instance.epicenablejobtosalvage,
      'IsEnable_MaterialPicking': instance.epienablematerialpicking,
      'IsEnable_MaterialLoading': instance.epienablematerialloading,
      'IsEnable_POReceipts': instance.epicenableporeceipt,
      'IsEnable_IssueAssembly': instance.epienableissueassembly,
      'IsEnable_ReturnAssembly': instance.epicenablereturnassembly,
      'IsEnable_SplitMergeUOM': instance.epienablesplitmergeuom,
      'IsEnable_DeliveryTrack': instance.epienabledeliverytracking,
      'IsEnable_Reprint': instance.epienablereprintlabel,
      'IsEnable_IssueMiscMaterial': instance.epienableissuemiscmaterial,
      'IsEnable_ReturnMiscMaterial': instance.epienablereturnmiscmaterial,
      'IsEnable_QtyAdjustment': instance.epienableqtyadjustment,
      'IsEnable_ClockInOut': instance.epienableclockin,
      'IsEnable_StartEndOp': instance.epienablestartoperation,
      'IsEnable_WorkQueue': instance.epienableworkqueue,
      'IsEnable_UseDefaultLabelQty': instance.epienabledefaultlabelqty,
      'Printer': instance.epiprinter,
      'token': instance.token,
    };
