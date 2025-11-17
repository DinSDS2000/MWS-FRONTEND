// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epicompany.g.dart';

@JsonSerializable()
class EpiCompany {
  EpiCompany({
    required this.token,
    required this.companycode,
    required this.companyname,
  });

  @JsonKey(name: 'Company_Code')
  final String? companycode;

  @JsonKey(name: 'Company_Name')
  final String? companyname;

  String? token;

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
    required this.epicompanylist,
  });

  factory EpiCompanyList.fromJson(List<dynamic> json) {
    List<EpiCompany> epicompanylist = List<EpiCompany>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      epicompanylist = json.map((i) => EpiCompany.fromJson(i)).toList();
    }
    return new EpiCompanyList(
      epicompanylist: epicompanylist,
    );
  }
}
