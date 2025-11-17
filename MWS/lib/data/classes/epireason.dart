// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epireason.g.dart';

@JsonSerializable()
class EpiReason {
  EpiReason({
    this.token,
    required this.reasoncode,
    required this.reasondesc,
  });

  @JsonKey(name: 'ReasonCode')
  final String reasoncode;

  @JsonKey(name: 'Description')
  final String reasondesc;

  String? token;

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
    required this.epireasonlist,
  });

  factory EpiReasonList.fromJson(List<dynamic> json) {
    List<EpiReason> epireasonlist = List<EpiReason>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      epireasonlist = json.map((i) => EpiReason.fromJson(i)).toList();
    }
    return new EpiReasonList(
      epireasonlist: epireasonlist,
    );
  }
}
