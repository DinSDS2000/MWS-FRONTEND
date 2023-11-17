
import 'package:json_annotation/json_annotation.dart';

part 'epitrxinfo.g.dart';

@JsonSerializable()
class EpiTrxInfo {
  EpiTrxInfo({
    this.token,
    this.company,
    this.sysdate,
    this.tranno,
    this.trantype,
    this.partnum,
    this.tranqty,
    this.whsecode,
    this.binnum,
    this.jobnum,
    this.assemblyseq,
    this.lotnum,
    this.uom,
    this.entryperson,
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
    this.epitrxinfolist,
  });

  factory EpiTrxInfoList.fromJson(List<dynamic> json) {
    List<EpiTrxInfo> epitrxinfolist = new List<EpiTrxInfo>();

    for (var i = 0; i < json.length; i++) {
      epitrxinfolist = json.map((i) => EpiTrxInfo.fromJson(i)).toList();
    }
    return new EpiTrxInfoList(
      epitrxinfolist: epitrxinfolist,
    );
  }
}
