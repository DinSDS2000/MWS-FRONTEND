import 'package:json_annotation/json_annotation.dart';

part 'episplitmergeuom.g.dart';

@JsonSerializable()
class EpiSplitMergeUOM {
  EpiSplitMergeUOM({
    this.token,
    this.rowno,
    this.company,
    this.partnum,
    this.whsecode,
    this.binnum,
    this.lotnum,
    this.onhandqty,
    this.qty,
    this.ium,
    this.convfact,
    this.convfactuom,
    this.allocatedqty,
  });

  final int rowno;

  final String company;

  final String partnum;

  final String whsecode;

  final String binnum;

  final String lotnum;

  final double onhandqty;

  double qty;

  final String ium;

  final double convfact;

  final String convfactuom;

  final double allocatedqty;

  @JsonKey(nullable: true)
  String token;

  factory EpiSplitMergeUOM.fromJson(Map<String, dynamic> json) =>
      _$EpiSplitMergeUOMFromJson(json);

  Map<String, dynamic> toJson() => _$EpiSplitMergeUOMToJson(this);

  @override
  String toString() {
    return "$partnum".toString();
  }
}

class EpiSplitMergeUOMList {
  final List<EpiSplitMergeUOM> episplitmergeuomlist;

  EpiSplitMergeUOMList({
    this.episplitmergeuomlist,
  });

  factory EpiSplitMergeUOMList.fromJson(List<dynamic> json) {
    List<EpiSplitMergeUOM> _episplitmergeuomlist = new List<EpiSplitMergeUOM>();

    for (var i = 0; i < json.length; i++) {
      _episplitmergeuomlist =
          json.map((i) => EpiSplitMergeUOM.fromJson(i)).toList();
    }
    return new EpiSplitMergeUOMList(
      episplitmergeuomlist: _episplitmergeuomlist,
    );
  }
}
