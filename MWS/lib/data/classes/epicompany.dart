import 'package:json_annotation/json_annotation.dart';

part 'epicompany.g.dart';

@JsonSerializable()
class EpiCompany {
  EpiCompany({
    this.token,
    this.companycode,
    this.companyname,
  });

  final String companycode;

  final String companyname;

  @JsonKey(nullable: true)
  String token;

  factory EpiCompany.fromJson(Map<String, dynamic> json) =>
      _$EpiCompanyFromJson(json);

  Map<String, dynamic> toJson() => _$EpiCompanyToJson(this);

  @override
  String toString() {
    return "$companycode $companyname".toString();
  }
}

class EpiCompanyList {
  final List<EpiCompany> epicompanylist;

  EpiCompanyList({
    this.epicompanylist,
  });

  factory EpiCompanyList.fromJson(List<dynamic> json) {
    List<EpiCompany> epicompanylist = new List<EpiCompany>();

   for (var i = 0; i < json.length; i++) {
    epicompanylist = json.map((i) => EpiCompany.fromJson(i)).toList();
  }
  return new EpiCompanyList(
      epicompanylist: epicompanylist,
    );
  }
}
