import 'package:json_annotation/json_annotation.dart';

part 'epiuom.g.dart';

@JsonSerializable()
class EpiUOM {
  EpiUOM({
    this.token,
    this.uomcode,
    this.uomdesc,
  });

  final String uomcode;

  final String uomdesc;

  @JsonKey(nullable: true)
  String token;

  factory EpiUOM.fromJson(Map<String, dynamic> json) =>
      _$EpiUOMFromJson(json);

  Map<String, dynamic> toJson() => _$EpiUOMToJson(this);

  @override
  String toString() {
    return "$uomcode $uomdesc".toString();
  }
}

class EpiUOMList {
  final List<EpiUOM> epiuomlist;

  EpiUOMList({
    this.epiuomlist,
  });

  factory EpiUOMList.fromJson(List<dynamic> json) {
    List<EpiUOM> epiuomlist = new List<EpiUOM>();

   for (var i = 0; i < json.length; i++) {
    epiuomlist = json.map((i) => EpiUOM.fromJson(i)).toList();
  }
  return new EpiUOMList(
      epiuomlist: epiuomlist,
    );
  }
}
