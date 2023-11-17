import 'package:json_annotation/json_annotation.dart';

part 'epijobhead.g.dart';

@JsonSerializable()
class EpiJobHead {
  EpiJobHead({
    this.token,
    this.company,
    this.plant,
    this.jobnum,
    this.jobtype,
    this.partnum,
    this.partdescription,
    this.revisionnum,
    this.prodqty,
    this.ium,
  });

  final String company;

  final String plant;

  final String jobnum;

  final String jobtype;

  final String partnum;

  final String partdescription;

  final String revisionnum;

  final double prodqty;

  final String ium;

  @JsonKey(nullable: true)
  String token;

  factory EpiJobHead.fromJson(Map<String, dynamic> json) =>
      _$EpiJobHeadFromJson(json);

  Map<String, dynamic> toJson() => _$EpiJobHeadToJson(this);

  @override
  String toString() {
    return "$jobnum".toString();
  }
}

class EpiJobHeadList {
  final List<EpiJobHead> epijobheadlist;

  EpiJobHeadList({
    this.epijobheadlist,
  });

  factory EpiJobHeadList.fromJson(List<dynamic> json) {
    List<EpiJobHead> _epijobheadlist = new List<EpiJobHead>();

    for (var i = 0; i < json.length; i++) {
      _epijobheadlist = json.map((i) => EpiJobHead.fromJson(i)).toList();
    }
    return new EpiJobHeadList(
      epijobheadlist: _epijobheadlist,
    );
  }
}
