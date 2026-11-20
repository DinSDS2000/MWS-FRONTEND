import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    this.token = '',
    this.epicuserid = '',
    this.epicpasskey = '',
    this.epicusername = '',
    this.epiccompany = '',
    this.epiccurcompany = '',
    this.epiccurcompanyname = '',
    this.epicplant = '',
    this.epicplantname = '',
    this.epiempid = '',
    this.epicenableissuematerial = false,
    this.epicenablemoveinventory = false,
    this.epicenablereturnmaterial = false,
    this.epicenablemoveinventoryrequest = false,
    this.epicenableacceptinventoryrequest = false,
    this.epicenablejobtoinventory = false,
    this.epicenablejobtosalvage = false,
    this.epicenableporeceipt = false,
    this.epienableissueassembly = false,
    this.epicenablereturnassembly = false,
    this.epienablesplitmergeuom = false,
    this.epienabledeliverytracking = false,
    this.epienablereprintlabel = false,
    this.epienableissuemiscmaterial = false,
    this.epienablereturnmiscmaterial = false,
    this.epienableqtyadjustment = false,
    this.epienableclockin = false,
    this.epienablestartoperation = false,
    this.epienablematerialpicking = false,
    this.epienablematerialloading = false,
    this.epienableworkqueue = false,
    this.epienabledefaultlabelqty = false,
    this.epiprinter = '',
    this.epiprinterpath = '',
  });

  @JsonKey(name: 'Epic_UserId')
  final String epicuserid;

  @JsonKey(name: 'Epic_PassKey')
  final String epicpasskey;

  @JsonKey(name: 'Epic_UserName')
  final String epicusername;

  @JsonKey(name: 'Epic_Company')
  final String epiccompany;

  @JsonKey(name: 'Epic_CurCompany')
  final String epiccurcompany;

  @JsonKey(name: 'Epic_CurCompanyName')
  final String epiccurcompanyname;

  @JsonKey(name: 'Epic_Plant')
  final String epicplant;

  @JsonKey(name: 'Epic_PlantName')
  final String epicplantname;

  @JsonKey(name: 'Epic_EmpId')
  final String epiempid;

  @JsonKey(name: 'IsEnable_MiscIssue')
  final bool epicenableissuematerial;

  @JsonKey(name: 'IsEnable_MoveInventory')
  final bool epicenablemoveinventory;

  @JsonKey(name: 'IsEnable_ReturnMaterial')
  final bool epicenablereturnmaterial;

  @JsonKey(name: 'IsEnable_MoveInventoryRequest')
  final bool epicenablemoveinventoryrequest;

  @JsonKey(name: 'IsEnable_MoveInventoryApproval')
  final bool epicenableacceptinventoryrequest;

  @JsonKey(name: 'IsEnable_JobReceipts')
  final bool epicenablejobtoinventory;

  @JsonKey(name: 'IsEnable_SalvageReceipts')
  final bool epicenablejobtosalvage;

  @JsonKey(name: 'IsEnable_MaterialPicking')
  final bool epienablematerialpicking;

  @JsonKey(name: 'IsEnable_MaterialLoading')
  final bool epienablematerialloading;

  @JsonKey(name: 'IsEnable_POReceipts')
  final bool epicenableporeceipt;

  @JsonKey(name: 'IsEnable_IssueAssembly')
  final bool epienableissueassembly;

  @JsonKey(name: 'IsEnable_ReturnAssembly')
  final bool epicenablereturnassembly;

  @JsonKey(name: 'IsEnable_SplitMergeUOM')
  final bool epienablesplitmergeuom;

  @JsonKey(name: 'IsEnable_DeliveryTrack')
  final bool epienabledeliverytracking;

  @JsonKey(name: 'IsEnable_Reprint')
  final bool epienablereprintlabel;

  @JsonKey(name: 'IsEnable_IssueMiscMaterial')
  final bool epienableissuemiscmaterial;

  @JsonKey(name: 'IsEnable_ReturnMiscMaterial')
  final bool epienablereturnmiscmaterial;

  @JsonKey(name: 'IsEnable_QtyAdjustment')
  final bool epienableqtyadjustment;

  @JsonKey(name: 'IsEnable_ClockInOut')
  final bool epienableclockin;

  @JsonKey(name: 'IsEnable_StartEndOp')
  final bool epienablestartoperation;

  @JsonKey(name: 'IsEnable_WorkQueue')
  final bool epienableworkqueue;

  @JsonKey(name: 'IsEnable_UseDefaultLabelQty')
  final bool epienabledefaultlabelqty;

  @JsonKey(name: 'Printer')
  final String epiprinter;

  @JsonKey(name: 'PrinterPath')
  final String epiprinterpath;

  String token;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return "$epicuserid $epicusername";
  }
}
