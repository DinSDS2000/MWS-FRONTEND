import 'package:flutter_epihhinventory/data/classes/epipartwhsebin.dart';
import 'package:json_annotation/json_annotation.dart';

part 'epipartwhse.g.dart';

@JsonSerializable()
class EpiPartWhse {
  EpiPartWhse({
    this.token,
    this.warehousedescription,
    this.whsebinlist,
  });

  final String warehousedescription;

  @JsonKey(nullable: true)
  List<EpiPartWhseBin> whsebinlist;

  @JsonKey(nullable: true)
  String token;

  factory EpiPartWhse.fromJson(Map<String, dynamic> json) =>
      _$EpiPartWhseFromJson(json);

  Map<String, dynamic> toJson() => _$EpiPartWhseToJson(this);

  @override
  String toString() {
    return "$warehousedescription".toString();
  }
}

class EpiPartWhseList {
  final List<EpiPartWhse> epipartwhselist;

  EpiPartWhseList({
    this.epipartwhselist,
  });

  factory EpiPartWhseList.fromJson(List<dynamic> json) {
    List<EpiPartWhse> epipartwhselist = new List<EpiPartWhse>();

   for (var i = 0; i < json.length; i++) {
    epipartwhselist = json.map((i) => EpiPartWhse.fromJson(i)).toList();
  }
  return new EpiPartWhseList(
      epipartwhselist: epipartwhselist,
    );
  }
}
