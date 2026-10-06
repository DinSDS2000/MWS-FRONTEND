// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epipickedtable.g.dart';

@JsonSerializable()
class EpiPickedTable {
  EpiPickedTable({
    required this.key1,
    required this.key2,
    required this.key3,
    required this.childKey1,
    required this.character01,
    required this.character02,
    required this.character03,
    required this.number01,
    required this.number02,
    required this.number03,
    required this.character04,
    required this.character06,
    required this.accumulatedQty,
    required this.remQty,
  });
  @JsonKey(name: "UD103A_Key1")
  final String key1;

  @JsonKey(name: "UD103A_Key2")
  final String key2;

  @JsonKey(name: "UD103A_Key3")
  final String key3;

  @JsonKey(name: "UD103A_ChildKey1")
  final String childKey1;

  @JsonKey(name: "UD103A_Character01")
  final String character01;

  @JsonKey(name: "UD103A_Character02")
  final String character02;

  @JsonKey(name: "UD103A_Character03")
  final String character03;

  @JsonKey(name: "UD103A_Number01")
  final double number01;

  @JsonKey(name: "UD103A_Number02")
  final double number02;

  @JsonKey(name: "UD103A_Number03")
  final double number03;

  @JsonKey(name: "UD103A_Character04")
  final String character04;

  @JsonKey(name: "UD103A_Character06")
  final String character06;

  @JsonKey(name: "Calculated_AccumulatedQty")
  final double accumulatedQty;

  @JsonKey(name: "Calculated_RemQty")
  final double remQty;

  factory EpiPickedTable.fromJson(Map<String, dynamic> json) =>
      _$EpiPickedTableFromJson(json);

  Map<String, dynamic> toJson() => _$EpiPickedTableToJson(this);

  @override
  String toString() {
    return "$character01 $character02 $character03".toString();
  }
}

class EpiPickedTableList {
  final List<EpiPickedTable> epipickedtablelist;

  EpiPickedTableList({
    required this.epipickedtablelist,
  });

  factory EpiPickedTableList.fromJson(List<dynamic> json) {
    List<EpiPickedTable> epipickedtablelist =
        List<EpiPickedTable>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      epipickedtablelist = json.map((i) => EpiPickedTable.fromJson(i)).toList();
    }

    return EpiPickedTableList(
      epipickedtablelist: epipickedtablelist,
    );
  }
}
