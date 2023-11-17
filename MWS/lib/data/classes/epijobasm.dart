import 'package:json_annotation/json_annotation.dart';

part 'epijobasm.g.dart';

@JsonSerializable()
class EpiJobAsm {
  EpiJobAsm({
    this.token,
    this.partnum,
    this.ium,
    this.reqqty,
    this.previssueqyy,
  });

  final String partnum;

  final String ium;

  final double reqqty;

  final double previssueqyy;

  @JsonKey(nullable: true)
  String token;

  factory EpiJobAsm.fromJson(Map<String, dynamic> json) =>
      _$EpiJobAsmFromJson(json);

  Map<String, dynamic> toJson() => _$EpiJobAsmToJson(this);

  @override
  String toString() {
    return "$partnum".toString();
  }
}

class EpiJobAsmList {
  final List<EpiJobAsm> epijobasmlist;

  EpiJobAsmList({
    this.epijobasmlist,
  });

  factory EpiJobAsmList.fromJson(List<dynamic> json) {
    List<EpiJobAsm> _epijobasmlist = new List<EpiJobAsm>();

    for (var i = 0; i < json.length; i++) {
      _epijobasmlist = json.map((i) => EpiJobAsm.fromJson(i)).toList();
    }
    return new EpiJobAsmList(
      epijobasmlist: _epijobasmlist,
    );
  }
}
