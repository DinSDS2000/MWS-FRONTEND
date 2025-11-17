
// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epitrxinfo.g.dart';

@JsonSerializable()
class EpiTrxInfo {
  EpiTrxInfo({
    required this.token,
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

  final String company;

  final String sysdate;

  final int tranno;

  final String trantype;

  final String partnum;

  final double tranqty;

  final String whsecode;

  final String binnum;

  final String jobnum;

  final int assemblyseq;

  final String lotnum;

  final String uom;

  final String entryperson;

  @JsonKey(nullable: true)
  String token;

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
