import 'package:json_annotation/json_annotation.dart';

part 'epimoveinvreq.g.dart';

@JsonSerializable()
class EpiMoveInvReq {
  EpiMoveInvReq({
    this.token,
    required this.reqnum,
    required this.partnum,
    required this.partdesc,
    required this.dtranqty,
    required this.frwhse,
    required this.frbin,
    required this.frlotnum,
    required this.towhse,
    required this.tobin,
    required this.tolotnum,
    required this.labelcount,
  });

  @JsonKey(name: 'ReqNum')
  final String reqnum;

  @JsonKey(name: 'PartNum')
  final String partnum;

  @JsonKey(name: 'Description')
  final String partdesc;

  @JsonKey(name: 'TranQty')
  final double dtranqty;

  @JsonKey(name: 'FromWarehouseCode')
  final String frwhse;

  @JsonKey(name: 'FromBinNum')
  final String frbin;

  @JsonKey(name: 'FromLotNum')
  final String frlotnum;

  @JsonKey(name: 'ToWarehouseCode')
  final String towhse;

  @JsonKey(name: 'ToBinNum')
  final String tobin;

  @JsonKey(name: 'ToLotNum')
  final String tolotnum;

  @JsonKey(name: 'LabelCount')
  final int labelcount;

  String? token;

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
    required this.epimoveinvreqlist,
  });

  factory EpiMoveInvReqList.fromJson(List<dynamic> json) {
    List<EpiMoveInvReq> _epimoveinvreqlist =
        List<EpiMoveInvReq>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      _epimoveinvreqlist = json.map((i) => EpiMoveInvReq.fromJson(i)).toList();
    }
    return new EpiMoveInvReqList(
      epimoveinvreqlist: _epimoveinvreqlist,
    );
  }
}
