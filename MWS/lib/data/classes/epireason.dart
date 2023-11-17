import 'package:json_annotation/json_annotation.dart';

part 'epireason.g.dart';

@JsonSerializable()
class EpiReason {
  EpiReason({
    this.token,
    this.reasoncode,
    this.reasondesc,
  });

  final String reasoncode;

  final String reasondesc;

  @JsonKey(nullable: true)
  String token;

  factory EpiReason.fromJson(Map<String, dynamic> json) =>
      _$EpiReasonFromJson(json);

  Map<String, dynamic> toJson() => _$EpiReasonToJson(this);

  @override
  String toString() {
    return "$reasoncode $reasondesc".toString();
  }
}

class EpiReasonList {
  final List<EpiReason> epireasonlist;

  EpiReasonList({
    this.epireasonlist,
  });

  factory EpiReasonList.fromJson(List<dynamic> json) {
    List<EpiReason> epireasonlist = new List<EpiReason>();

    for (var i = 0; i < json.length; i++) {
      epireasonlist = json.map((i) => EpiReason.fromJson(i)).toList();
    }
    return new EpiReasonList(
      epireasonlist: epireasonlist,
    );
  }
}
