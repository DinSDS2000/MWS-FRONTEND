// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epitrxinfo.g.dart';

@JsonSerializable()
class EpiTrxInfo {
  EpiTrxInfo({
    this.token,
    required this.company,
    required this.sysdate,
    required this.tranno,
    required this.trantype,
    required this.partnum,
    required this.tranqty,
    required this.whsecode,
    required this.binnum,
    required this.jobnum,
    required this.assemblyseq,
    required this.lotnum,
    required this.uom,
    required this.entryperson,
  });
  @JsonKey(name: 'Company')
  final String company;

  @JsonKey(name: 'SysDate')
  final String sysdate;

  @JsonKey(name: 'TranNo')
  final int tranno;

  @JsonKey(name: 'TranType')
  final String trantype;

  @JsonKey(name: 'PartNum')
  final String partnum;

  @JsonKey(name: 'TranQty')
  final double tranqty;

  @JsonKey(name: 'WarehouseCode')
  final String whsecode;

  @JsonKey(name: 'BinNum')
  final String binnum;

  @JsonKey(name: 'JobNum')
  final String jobnum;

  @JsonKey(name: 'AssemblySeq')
  final int assemblyseq;

  @JsonKey(name: 'LotNum')
  final String lotnum;

  @JsonKey(name: 'UOM')
  final String uom;

  @JsonKey(name: 'EntryPerson')
  final String entryperson;

  String? token;

  factory EpiTrxInfo.fromJson(Map<String, dynamic> json) =>
      _$EpiTrxInfoFromJson(json);

  Map<String, dynamic> toJson() => _$EpiTrxInfoToJson(this);

  @override
  String toString() {
    return "$tranno".toString();
  }
}

class EpiTrxInfoList {
  final List<EpiTrxInfo> epitrxinfolist;

  EpiTrxInfoList({
    required this.epitrxinfolist,
  });

  factory EpiTrxInfoList.fromJson(List<dynamic> json) {
    List<EpiTrxInfo> epitrxinfolist = List<EpiTrxInfo>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      epitrxinfolist = json.map((i) => EpiTrxInfo.fromJson(i)).toList();
    }
    return new EpiTrxInfoList(
      epitrxinfolist: epitrxinfolist,
    );
  }
}
