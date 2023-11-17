import 'package:json_annotation/json_annotation.dart';

part 'epimoveinvreq.g.dart';

@JsonSerializable()
class EpiMoveInvReq {
  EpiMoveInvReq({
    this.token,
    this.reqnum,
    this.partnum,
    this.partdesc,
    this.dtranqty,
    this.frwhse,
    this.frbin,
    this.frlotnum,
    this.towhse,
    this.tobin,
    this.tolotnum,
    this.labelcount,
  });

  final String reqnum;

  final String partnum;

  final String partdesc;

  final double dtranqty;

  final String frwhse;

  final String frbin;

  final String frlotnum;

  final String towhse;

  final String tobin;

  final String tolotnum;

  final int labelcount;

  @JsonKey(nullable: true)
  String token;

  factory EpiMoveInvReq.fromJson(Map<String, dynamic> json) =>
      _$EpiMoveInvReqFromJson(json);

  Map<String, dynamic> toJson() => _$EpiMoveInvReqToJson(this);

  @override
  String toString() {
    return "$partnum".toString();
  }
}

class EpiMoveInvReqList {
  final List<EpiMoveInvReq> epimoveinvreqlist;

  EpiMoveInvReqList({
    this.epimoveinvreqlist,
  });

  factory EpiMoveInvReqList.fromJson(List<dynamic> json) {
    List<EpiMoveInvReq> _epimoveinvreqlist = new List<EpiMoveInvReq>();

    for (var i = 0; i < json.length; i++) {
      _epimoveinvreqlist = json.map((i) => EpiMoveInvReq.fromJson(i)).toList();
    }
    return new EpiMoveInvReqList(
      epimoveinvreqlist: _epimoveinvreqlist,
    );
  }
}
