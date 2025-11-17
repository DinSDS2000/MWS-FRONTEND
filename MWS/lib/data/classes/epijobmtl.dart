// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epijobmtl.g.dart';

@JsonSerializable()
class EpiJobMtl {
  EpiJobMtl({
    this.token,
    required this.partnum,
    required this.ium,
    required this.reqqty,
    required this.previssueqyy,
  });

  @JsonKey(name: 'PartNum')
  final String partnum;

  @JsonKey(name: 'IUM')
  final String ium;

  @JsonKey(name: 'RequiredQty')
  final double reqqty;

  @JsonKey(name: 'TotalIssuedQty')
  final double previssueqyy;

  String? token;

  factory EpiJobMtl.fromJson(Map<String, dynamic> json) =>
      _$EpiJobMtlFromJson(json);

  Map<String, dynamic> toJson() => _$EpiJobMtlToJson(this);

  @override
  String toString() => "$partnum";
}

class EpiJobMtlList {
  final List<EpiJobMtl> epijobmtllist;

  EpiJobMtlList({
    required this.epijobmtllist,
  });

  factory EpiJobMtlList.fromJson(List<dynamic> json) {
    List<EpiJobMtl> _epijobmtllist = List<EpiJobMtl>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      _epijobmtllist = json.map((i) => EpiJobMtl.fromJson(i)).toList();
    }
    return new EpiJobMtlList(
      epijobmtllist: _epijobmtllist,
    );
  }
}
