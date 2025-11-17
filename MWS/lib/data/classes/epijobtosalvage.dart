// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epijobtosalvage.g.dart';

@JsonSerializable()
class EpiJobToSalvage {
  EpiJobToSalvage({
    required this.token,
    required this.company,
    required this.plant,
    required this.jobnum,
    required this.jobpartnum,
    required this.partnum,
    required this.asmseq,
    required this.mtlseq,
    required this.dtranqty,
    required this.ium,
  });

  final String company;

  final String plant;

  final String jobnum;

  final String jobpartnum;

  final String partnum;

  final int asmseq;

  final int mtlseq;

  final double dtranqty;

  final String ium;

  @JsonKey(nullable: true)
  String token;

  factory EpiJobToSalvage.fromJson(Map<String, dynamic> json) =>
      _$EpiJobToSalvageFromJson(json);

  Map<String, dynamic> toJson() => _$EpiJobToSalvageToJson(this);

  @override
  String toString() {
    return "$jobnum".toString();
  }
}

class EpiJobToSalvageList {
  final List<EpiJobToSalvage> epijobtosalvage;

  EpiJobToSalvageList({
    required this.epijobtosalvage,
  });

  factory EpiJobToSalvageList.fromJson(List<dynamic> json) {
    List<EpiJobToSalvage> _epijobtosalvage = List<EpiJobToSalvage>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      _epijobtosalvage = json.map((i) => EpiJobToSalvage.fromJson(i)).toList();
    }
    return new EpiJobToSalvageList(
      epijobtosalvage: _epijobtosalvage,
    );
  }
}
