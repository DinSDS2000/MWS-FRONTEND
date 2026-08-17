// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

// Matches the exact filename for the build_runner generator
part 'epigetlot.g.dart';

@JsonSerializable()
class EpiGetLot {
  EpiGetLot({
    required this.lotNum,
    required this.onHandQty,
  });

  @JsonKey(name: 'LotNum')
  final String lotNum;

  // Handles Epicor decimal syntax formatting safely
  @JsonKey(name: 'OnHandQty')
  final double onHandQty;

  factory EpiGetLot.fromJson(Map<String, dynamic> json) =>
      _$EpiGetLotFromJson(json);

  Map<String, dynamic> toJson() => _$EpiGetLotToJson(this);

  @override
  String toString() {
    return "$lotNum (Qty: $onHandQty)".toString();
  }
}

class EpiGetLotList {
  final List<EpiGetLot> epigetliotlist;

  EpiGetLotList({
    required this.epigetliotlist,
  });

  factory EpiGetLotList.fromJson(List<dynamic> json) {
    List<EpiGetLot> epigetliotlist =
        json.map((item) => EpiGetLot.fromJson(item)).toList();

    return EpiGetLotList(
      epigetliotlist: epigetliotlist,
    );
  }
}
