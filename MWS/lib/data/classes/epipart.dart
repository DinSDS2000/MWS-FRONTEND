import 'package:json_annotation/json_annotation.dart';

part 'epipart.g.dart';

@JsonSerializable()
class EpiPart {
  EpiPart({
    this.token,
    required this.partdescription,
    required this.ium,
    required this.tracklots,
    required this.attbatch,
    required this.attmfgbatch,
    required this.attmfglot,
    required this.attheat,
    required this.attfirmware,
    required this.attbeforedt,
    required this.attmfgdt,
    required this.attcuredt,
    required this.attexpdt,
  });

  @JsonKey(name: 'PartDescription')
  final String partdescription;

  @JsonKey(name: 'IUM')
  final String ium;

  @JsonKey(name: 'TrackLots')
  final bool tracklots;

  @JsonKey(name: 'AttBatch')
  final String attbatch;

  @JsonKey(name: 'AttMfgBatch')
  final String attmfgbatch;

  @JsonKey(name: 'AttMfgLot')
  final String attmfglot;

  @JsonKey(name: 'AttHeat')
  final String attheat;

  @JsonKey(name: 'AttFirmware')
  final String attfirmware;

  @JsonKey(name: 'AttBeforeDt')
  final String attbeforedt;

  @JsonKey(name: 'AttMfgDt')
  final String attmfgdt;

  @JsonKey(name: 'AttCureDt')
  final String attcuredt;

  @JsonKey(name: 'AttExpDt')
  final String attexpdt;

  @JsonKey(name: 'Token')
  String? token;

  factory EpiPart.fromJson(Map<String, dynamic> json) =>
      _$EpiPartFromJson(json);

  Map<String, dynamic> toJson() => _$EpiPartToJson(this);

  @override
  String toString() {
    return "$partdescription $ium";
  }
}

class EpiPartList {
  final List<EpiPart> epipartlist;

  EpiPartList({
    required this.epipartlist,
  });

  factory EpiPartList.fromJson(List<dynamic> json) {
    List<EpiPart> epipartlist = List<EpiPart>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      epipartlist = json.map((i) => EpiPart.fromJson(i)).toList();
    }
    return new EpiPartList(
      epipartlist: epipartlist,
    );
  }
}
