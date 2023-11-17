import 'package:json_annotation/json_annotation.dart';

part 'epiworkqueue.g.dart';

@JsonSerializable()
class EpiWorkQueue {
  EpiWorkQueue({
    this.token,
    this.jobno,
    this.asmno,
    this.oprno,
    this.opcode,
    this.resgroupid,
    this.resid,
    this.labortype,
    this.empid,
    this.empname,
    this.clockindate,
    this.clockintime,
    this.transqty,
    this.laborhedseq,
    this.labordtlseq,
  });

  final String jobno;

  final int asmno;

  final int oprno;

  final String opcode;

  final String resgroupid;

  final String resid;

  final String labortype;

  final String empid;

  final String empname;

  final String clockindate;

  final String clockintime;

  final double transqty;

  final int laborhedseq;

  final int labordtlseq;

  @JsonKey(nullable: true)
  String token;

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
    this.epiworkqueuelist,
  });

  factory EpiWorkQueueList.fromJson(List<dynamic> json) {
    List<EpiWorkQueue> _epiworkqueuelist = new List<EpiWorkQueue>();

    for (var i = 0; i < json.length; i++) {
      _epiworkqueuelist = json.map((i) => EpiWorkQueue.fromJson(i)).toList();
    }
    return new EpiWorkQueueList(
      epiworkqueuelist: _epiworkqueuelist,
    );
  }
}
