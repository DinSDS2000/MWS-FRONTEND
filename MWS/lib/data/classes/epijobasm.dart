import 'package:json_annotation/json_annotation.dart';

part 'epijobasm.g.dart';

@JsonSerializable()
class EpiJobAsm {
  EpiJobAsm({
    this.token,
    required this.partnum,
    required this.ium,
    required this.reqqty,
    required this.previssueqyy,
  });

  @JsonKey(name: 'PartNum')
  final String partnum;

  @JsonKey(name: 'IUM')
  final String ium;

  @JsonKey(name: 'RequiredQty')
  final double reqqty;

  @JsonKey(name: 'IssuedQty')
  final double previssueqyy;

  // ignore: deprecated_member_use
  @JsonKey(nullable: true)
  String? token;

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
    required this.epijobasmlist,
  });

  factory EpiJobAsmList.fromJson(List<dynamic> json) {
    List<EpiJobAsm> _epijobasmlist = List<EpiJobAsm>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      _epijobasmlist = json.map((i) => EpiJobAsm.fromJson(i)).toList();
    }
    return new EpiJobAsmList(
      epijobasmlist: _epijobasmlist,
    );
  }
}
