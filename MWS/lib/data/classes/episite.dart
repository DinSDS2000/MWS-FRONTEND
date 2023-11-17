import 'package:json_annotation/json_annotation.dart';

part 'episite.g.dart';

@JsonSerializable()
class EpiSite {
  EpiSite({
    this.token,
    this.company,
    this.siteplant,
    this.name,
  });

  final String company;

  final String siteplant;

  final String name;

  @JsonKey(nullable: true)
  String token;

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
    this.episitelist,
  });

  factory EpiSiteList.fromJson(List<dynamic> json) {
    List<EpiSite> episitelist = new List<EpiSite>();

   for (var i = 0; i < json.length; i++) {
    episitelist = json.map((i) => EpiSite.fromJson(i)).toList();
  }
  return new EpiSiteList(
      episitelist: episitelist,
    );
  }
}
