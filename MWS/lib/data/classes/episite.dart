import 'package:json_annotation/json_annotation.dart';

part 'episite.g.dart';

@JsonSerializable()
class EpiSite {
  EpiSite({
    this.token,
    required this.company,
    required this.siteplant,
    required this.name,
  });
  @JsonKey(name: "Company")
  final String company;

  @JsonKey(name: "SitePlant")
  final String siteplant;

  @JsonKey(name: "Name")
  final String name;

  String? token;

  factory EpiSite.fromJson(Map<String, dynamic> json) =>
      _$EpiSiteFromJson(json);

  Map<String, dynamic> toJson() => _$EpiSiteToJson(this);

  @override
  String toString() {
    return "$siteplant $name".toString();
  }
}

class EpiSiteList {
  final List<EpiSite> episitelist;

  EpiSiteList({
    required this.episitelist,
  });

  factory EpiSiteList.fromJson(List<dynamic> json) {
    List<EpiSite> episitelist = List<EpiSite>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      episitelist = json.map((i) => EpiSite.fromJson(i)).toList();
    }
    return new EpiSiteList(
      episitelist: episitelist,
    );
  }
}
