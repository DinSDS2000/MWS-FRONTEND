import 'package:json_annotation/json_annotation.dart';

part 'epijobmtl.g.dart';

@JsonSerializable()
class EpiJobMtl {
  EpiJobMtl({
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

  factory EpiJobMtl.fromJson(Map<String, dynamic> json) =>
      _$EpiJobMtlFromJson(json);

  Map<String, dynamic> toJson() => _$EpiJobMtlToJson(this);

  @override
  String toString() {
    return "$partnum".toString();
  }
}

class EpiJobMtlList {
  final List<EpiJobMtl> epijobmtllist;

  EpiJobMtlList({
    this.epijobmtllist,
  });

  factory EpiJobMtlList.fromJson(List<dynamic> json) {
    List<EpiJobMtl> _epijobmtllist = new List<EpiJobMtl>();

    for (var i = 0; i < json.length; i++) {
      _epijobmtllist = json.map((i) => EpiJobMtl.fromJson(i)).toList();
    }
    return new EpiJobMtlList(
      epijobmtllist: _epijobmtllist,
    );
  }
}
