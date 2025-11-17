import 'package:json_annotation/json_annotation.dart';

part 'epijoboprresource.g.dart';

@JsonSerializable()
class EpiJobOprResource {
  EpiJobOprResource({
    required this.token,
    required this.resourceid,
    required this.resourcedesc,
    required this.opcode,
    required this.resourcegrpid,
    required this.resourcegrpdesc,
  });

  final String resourceid;

  final String resourcedesc;

  final String opcode;

  final String resourcegrpid;

  final String resourcegrpdesc;

  // ignore: deprecated_member_use
  @JsonKey(nullable: true)
  String token;

  factory EpiJobOprResource.fromJson(Map<String, dynamic> json) =>
      _$EpiJobOprResourceFromJson(json);

  Map<String, dynamic> toJson() => _$EpiJobOprResourceToJson(this);

  @override
  String toString() {
    return "$resourceid".toString() + "$resourcedesc".toString();
  }
}

class EpiJobOprResourceList {
  final List<EpiJobOprResource> epijoboprresourcelist;

  EpiJobOprResourceList({
    required this.epijoboprresourcelist,
  });

  factory EpiJobOprResourceList.fromJson(List<dynamic> json) {
    List<EpiJobOprResource> _epijoboprresourcelist =
        List<EpiJobOprResource>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      _epijoboprresourcelist =
          json.map((i) => EpiJobOprResource.fromJson(i)).toList();
    }
    return new EpiJobOprResourceList(
      epijoboprresourcelist: _epijoboprresourcelist,
    );
  }
}
