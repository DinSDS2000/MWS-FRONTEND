import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    this.token,
    this.epicuserid,
    this.epicpasskey,
    this.epicusername,
    this.epiccompany,
    this.epiccurcompany,
    this.epiccurcompanyname,
    this.epicplant,
    this.epicplantname,
    this.epiempid,
    this.epicenableissuematerial,
    this.epicenablemoveinventory,
    this.epicenablereturnmaterial,
    this.epicenablemoveinventoryrequest,
    this.epicenableacceptinventoryrequest,
    this.epicenablejobtoinventory,
    this.epicenablejobtosalvage,
    this.epicenableporeceipt,
    this.epienableissueassembly,
    this.epicenablereturnassembly,
    this.epienablesplitmergeuom,
    this.epienabledeliverytracking,
    this.epienablereprintlabel,
    this.epienableissuemiscmaterial,
    this.epienablereturnmiscmaterial,
    this.epienableqtyadjustment,
    this.epienableclockin,
    this.epienablestartoperation,
    this.epienableworkqueue,
    this.epienabledefaultlabelqty,
  });

  final String epicuserid;

  final String epicpasskey;

  final String epicusername;

  final String epiccompany;

  final String epiccurcompany;

  final String epiccurcompanyname;

  final String epicplant;

  final String epicplantname;

  final String epiempid;

  final bool epicenableissuematerial;

  final bool epicenablemoveinventory;

  final bool epicenablereturnmaterial;

  final bool epicenablemoveinventoryrequest;

  final bool epicenableacceptinventoryrequest;

  final bool epicenablejobtoinventory;

  final bool epicenablejobtosalvage;

  final bool epicenableporeceipt;

  final bool epienableissueassembly;

  final bool epicenablereturnassembly;

  final bool epienablesplitmergeuom;

  final bool epienabledeliverytracking;

  final bool epienablereprintlabel;

  final bool epienableissuemiscmaterial;

  final bool epienablereturnmiscmaterial;

  final bool epienableqtyadjustment;

  final bool epienableclockin;

  final bool epienablestartoperation;

  final bool epienableworkqueue;

  final bool epienabledefaultlabelqty;

  @JsonKey(nullable: true)
  String token;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return "$epicuserid $epicusername".toString();
  }
}
