// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epiuom.g.dart';

@JsonSerializable()
class EpiUOM {
  EpiUOM({
    this.token,
    required this.uomcode,
    required this.uomdesc,
  });

  @JsonKey(name: 'UOMCode')
  final String uomcode;

  @JsonKey(name: 'UOMDescription')
  final String uomdesc;

  @JsonKey(nullable: true)
  String? token;

  factory EpiUOM.fromJson(Map<String, dynamic> json) => _$EpiUOMFromJson(json);

  Map<String, dynamic> toJson() => _$EpiUOMToJson(this);

  @override
  String toString() {
    return "$uomcode $uomdesc".toString();
  }
}

class EpiUOMList {
  final List<EpiUOM> epiuomlist;

  EpiUOMList({
    required this.epiuomlist,
  });

  factory EpiUOMList.fromJson(List<dynamic> json) {
    List<EpiUOM> epiuomlist = List<EpiUOM>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      epiuomlist = json.map((i) => EpiUOM.fromJson(i)).toList();
    }
    return new EpiUOMList(
      epiuomlist: epiuomlist,
    );
  }
}
