import 'package:json_annotation/json_annotation.dart';

part 'epipartwhsebin.g.dart';

@JsonSerializable()
class EpiPartWhseBin {
  EpiPartWhseBin({
    this.token,
    this.binnum,
    this.description,
  });

  final String binnum;

  final String description;

  @JsonKey(nullable: true)
  String token;

  factory EpiPartWhseBin.fromJson(Map<String, dynamic> json) =>
      _$EpiPartWhseBinFromJson(json);

  Map<String, dynamic> toJson() => _$EpiPartWhseBinToJson(this);

  @override
  String toString() {
    return "$binnum $description".toString();
  }
}

class EpiPartWhseBinList {
  final List<EpiPartWhseBin> epipartwhsebinlist;

  EpiPartWhseBinList({
    this.epipartwhsebinlist,
  });

  factory EpiPartWhseBinList.fromJson(List<dynamic> json) {
    List<EpiPartWhseBin> epipartwhsebinlist = new List<EpiPartWhseBin>();

   for (var i = 0; i < json.length; i++) {
    epipartwhsebinlist = json.map((i) => EpiPartWhseBin.fromJson(i)).toList();
  }
  return new EpiPartWhseBinList(
      epipartwhsebinlist: epipartwhsebinlist,
    );
  }
}
