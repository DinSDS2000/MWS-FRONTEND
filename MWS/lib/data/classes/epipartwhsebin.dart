// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epipartwhsebin.g.dart';

@JsonSerializable()
class EpiPartWhseBin {
  EpiPartWhseBin({
    required this.token,
    required this.binnum,
    required this.description,
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
    required this.epipartwhsebinlist,
  });

  factory EpiPartWhseBinList.fromJson(List<dynamic> json) {
    List<EpiPartWhseBin> epipartwhsebinlist = List<EpiPartWhseBin>.empty(growable: true);

   for (var i = 0; i < json.length; i++) {
    epipartwhsebinlist = json.map((i) => EpiPartWhseBin.fromJson(i)).toList();
  }
  return new EpiPartWhseBinList(
      epipartwhsebinlist: epipartwhsebinlist,
    );
  }
}
