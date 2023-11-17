import 'package:json_annotation/json_annotation.dart';

part 'epijoboprresource.g.dart';

@JsonSerializable()
class EpiJobOprResource {
  EpiJobOprResource({
    this.token,
    this.resourceid,
    this.resourcedesc,
    this.opcode,
    this.resourcegrpid,
    this.resourcegrpdesc,
  });

  final String resourceid;

  final String resourcedesc;

  final String opcode;

  final String resourcegrpid;

  final String resourcegrpdesc;

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
    this.epijoboprresourcelist,
  });

  factory EpiJobOprResourceList.fromJson(List<dynamic> json) {
    List<EpiJobOprResource> _epijoboprresourcelist =
        new List<EpiJobOprResource>();

    for (var i = 0; i < json.length; i++) {
      _epijoboprresourcelist =
          json.map((i) => EpiJobOprResource.fromJson(i)).toList();
    }
    return new EpiJobOprResourceList(
      epijoboprresourcelist: _epijoboprresourcelist,
    );
  }
}
