// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

// Matches the exact filename for the build_runner generator
part 'epigetbin.g.dart';

@JsonSerializable()
class EpiGetBin {
  EpiGetBin({
    required this.binNum,
    required this.onHandQty,
  });

  @JsonKey(name: 'BinNum')
  final String binNum;

  // Handles Epicor decimal syntax formatting safely
  @JsonKey(name: 'OnHandQty')
  final double onHandQty;

  factory EpiGetBin.fromJson(Map<String, dynamic> json) =>
      _$EpiGetBinFromJson(json);

  Map<String, dynamic> toJson() => _$EpiGetBinToJson(this);

  @override
  String toString() {
    return "$binNum (Qty: $onHandQty)".toString();
  }
}

class EpiGetBinList {
  final List<EpiGetBin> epigetbinlist;

  EpiGetBinList({
    required this.epigetbinlist,
  });

  factory EpiGetBinList.fromJson(List<dynamic> json) {
    List<EpiGetBin> epigetbinlist =
        json.map((item) => EpiGetBin.fromJson(item)).toList();

    return EpiGetBinList(
      epigetbinlist: epigetbinlist,
    );
  }
}
