import 'package:json_annotation/json_annotation.dart';

part 'epipart.g.dart';

@JsonSerializable()
class EpiPart {
  EpiPart({
    this.token,
    this.partdescription,
    this.ium,
    this.tracklots,
    this.attbatch,
    this.attmfgbatch,
    this.attmfglot,
    this.attheat,
    this.attfirmware,
    this.attbeforedt,
    this.attmfgdt,
    this.attcuredt,
    this.attexpdt,
  });

  final String partdescription;

  final String ium;

  final bool tracklots;

  final String attbatch;

  final String attmfgbatch;

  final String attmfglot;

  final String attheat;

  final String attfirmware;

  final String attbeforedt;

  final String attmfgdt;

  final String attcuredt;

  final String attexpdt;

  @JsonKey(nullable: true)
  String token;

  factory EpiPart.fromJson(Map<String, dynamic> json) =>
      _$EpiPartFromJson(json);

  Map<String, dynamic> toJson() => _$EpiPartToJson(this);

  @override
  String toString() {
    return "$partdescription $ium".toString();
  }
}

class EpiPartList {
  final List<EpiPart> epipartlist;

  EpiPartList({
    this.epipartlist,
  });

  factory EpiPartList.fromJson(List<dynamic> json) {
    List<EpiPart> epipartlist = new List<EpiPart>();

    for (var i = 0; i < json.length; i++) {
      epipartlist = json.map((i) => EpiPart.fromJson(i)).toList();
    }
    return new EpiPartList(
      epipartlist: epipartlist,
    );
  }
}
