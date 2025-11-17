import 'package:json_annotation/json_annotation.dart';

part 'episplitmergeuom.g.dart';

@JsonSerializable()
class EpiSplitMergeUOM {
  EpiSplitMergeUOM({
    required this.token,
    required this.rowno,
    required this.company,
    required this.partnum,
    required this.whsecode,
    required this.binnum,
    required this.lotnum,
    required this.onhandqty,
    required this.qty,
    required this.ium,
    required this.convfact,
    required this.convfactuom,
    required this.allocatedqty,
  });

  @JsonKey(name: 'RowNo')
  final int rowno;

  @JsonKey(name: 'Company')
  final String company;

  @JsonKey(name: 'PartNum')
  final String partnum;

  @JsonKey(name: 'WarehouseCode')
  final String whsecode;

  @JsonKey(name: 'BinNum')
  final String binnum;

  @JsonKey(name: 'LotNum')
  final String lotnum;

  @JsonKey(name: 'OnHandQty')
  final double onhandqty;

  @JsonKey(name: 'Qty')
  double qty;

  @JsonKey(name: 'UOM')
  final String ium;

  @JsonKey(name: 'ConvFact')
  final double convfact;

  @JsonKey(name: 'ConvFactUOM')
  final String convfactuom;

  @JsonKey(name: 'AllocatedQty')
  final double allocatedqty;

  @JsonKey(includeIfNull: true)
  String? token;

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
    required this.episplitmergeuomlist,
  });

  factory EpiSplitMergeUOMList.fromJson(List<dynamic> json) {
    List<EpiSplitMergeUOM> _episplitmergeuomlist =
        List<EpiSplitMergeUOM>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      _episplitmergeuomlist =
          json.map((i) => EpiSplitMergeUOM.fromJson(i)).toList();
    }
    return new EpiSplitMergeUOMList(
      episplitmergeuomlist: _episplitmergeuomlist,
    );
  }
}
