import 'package:json_annotation/json_annotation.dart';

part 'epijobtosalvage.g.dart';

@JsonSerializable()
class EpiJobToSalvage {
  EpiJobToSalvage({
    this.token,
    this.company,
    this.plant,
    this.jobnum,
    this.jobpartnum,
    this.partnum,
    this.asmseq,
    this.mtlseq,
    this.dtranqty,
    this.ium,
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
    this.epijobtosalvage,
  });

  factory EpiJobToSalvageList.fromJson(List<dynamic> json) {
    List<EpiJobToSalvage> _epijobtosalvage = new List<EpiJobToSalvage>();

    for (var i = 0; i < json.length; i++) {
      _epijobtosalvage = json.map((i) => EpiJobToSalvage.fromJson(i)).toList();
    }
    return new EpiJobToSalvageList(
      epijobtosalvage: _epijobtosalvage,
    );
  }
}
