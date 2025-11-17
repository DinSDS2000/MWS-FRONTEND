// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epiworkqueue.g.dart';

@JsonSerializable()
class EpiWorkQueue {
  EpiWorkQueue({
    this.token,
    required this.jobno,
    required this.asmno,
    required this.oprno,
    required this.opcode,
    required this.resgroupid,
    required this.resid,
    required this.labortype,
    required this.empid,
    required this.empname,
    required this.clockindate,
    required this.clockintime,
    required this.transqty,
    required this.laborhedseq,
    required this.labordtlseq,
  });

  @JsonKey(name: "JobNum")
  final String jobno;
  @JsonKey(name: "AssemblySeq")
  final int asmno;
  @JsonKey(name: "OprSeq")
  final int oprno;
  @JsonKey(name: "OpCode")
  final String opcode;
  @JsonKey(name: "ResourceGrpID")
  final String resgroupid;
  @JsonKey(name: "ResourceID")
  final String resid;
  @JsonKey(name: "LaborType")
  final String labortype;
  @JsonKey(name: "EmployeeNum")
  final String empid;
  @JsonKey(name: "EmployeeName")
  final String empname;
  @JsonKey(name: "ClockInDate")
  final String clockindate;
  @JsonKey(name: "ClockIntime")
  final String clockintime;
  @JsonKey(name: "TranQty")
  final double transqty;
  @JsonKey(name: "LaborHedSeq")
  final int laborhedseq;
  @JsonKey(name: "LaborDtlSeq")
  final int labordtlseq;

  String? token;

  factory EpiWorkQueue.fromJson(Map<String, dynamic> json) =>
      _$EpiWorkQueueFromJson(json);

  Map<String, dynamic> toJson() => _$EpiWorkQueueToJson(this);

  @override
  String toString() {
    return "$jobno".toString();
  }
}

class EpiWorkQueueList {
  final List<EpiWorkQueue> epiworkqueuelist;

  EpiWorkQueueList({
    required this.epiworkqueuelist,
  });

  factory EpiWorkQueueList.fromJson(List<dynamic> json) {
    List<EpiWorkQueue> _epiworkqueuelist =
        List<EpiWorkQueue>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      _epiworkqueuelist = json.map((i) => EpiWorkQueue.fromJson(i)).toList();
    }
    return new EpiWorkQueueList(
      epiworkqueuelist: _epiworkqueuelist,
    );
  }
}
