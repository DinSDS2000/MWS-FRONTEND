// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epidocustinfo.g.dart';

@JsonSerializable()
class EpiDOCustInfo {
  EpiDOCustInfo({
    required this.token,
    required this.company,
    required this.custid,
    required this.custnum,
    required this.custname,
    required this.custaddress,
  });

  final String company;

  final String custid;

  final int custnum;

  final String custname;

  final String custaddress;

  
  @JsonKey(nullable: true)
  String token;

  factory EpiDOCustInfo.fromJson(Map<String, dynamic> json) =>
      _$EpiDOCustInfoFromJson(json);

  Map<String, dynamic> toJson() => _$EpiDOCustInfoToJson(this);

  @override
  String toString() {
    return "$custid $custname".toString();
  }
}

class EpiDOCustInfoList {
  final List<EpiDOCustInfo> epidocustinfolist;

  EpiDOCustInfoList({
    required this.epidocustinfolist,
  });

  factory EpiDOCustInfoList.fromJson(List<dynamic> json) {
    List<EpiDOCustInfo> epidocustinfolist = List<EpiDOCustInfo>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      epidocustinfolist = json.map((i) => EpiDOCustInfo.fromJson(i)).toList();
    }
    return new EpiDOCustInfoList(
      epidocustinfolist: epidocustinfolist,
    );
  }
}
