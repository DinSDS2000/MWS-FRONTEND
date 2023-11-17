import 'package:json_annotation/json_annotation.dart';

part 'epienvironment.g.dart';

@JsonSerializable()
class EpiEnvironment {
  EpiEnvironment({
    this.token,
    this.envid,
    this.envdescription,
    this.envisactive,
    this.envappserver,
    this.envappepicor,
    this.envappuserid,
    this.envapppasskey,
    this.envsqlserver,
    this.envsqldb,
    this.envsqluserid,
    this.envsqlpasskey,
    this.envbarcodeseperator,
    this.envbarcodeseperator2,
  });

  final String envid;

  final String envdescription;

  final bool envisactive;

  final String envappserver;

  final String envappepicor;

  final String envappuserid;

  final String envapppasskey;

  final String envsqlserver;

  final String envsqldb;

  final String envsqluserid;

  final String envsqlpasskey;

  final String envbarcodeseperator;

  final String envbarcodeseperator2;

  @JsonKey(nullable: true)
  String token;

  factory EpiEnvironment.fromJson(Map<String, dynamic> json) =>
      _$EpiEnvFromJson(json);

  Map<String, dynamic> toJson() => _$EpiEnvToJson(this);

  @override
  String toString() {
    return "$envid $envdescription".toString();
  }
}

class EpiEnvironmentList {
  final List<EpiEnvironment> epienvlist;

  EpiEnvironmentList({
    this.epienvlist,
  });

  factory EpiEnvironmentList.fromJson(List<dynamic> json) {
    List<EpiEnvironment> _epienvlist = new List<EpiEnvironment>();
    if (json != null) {
      for (var i = 0; i < json.length; i++) {
        _epienvlist = json.map((i) => EpiEnvironment.fromJson(i)).toList();
      }
    }

    return new EpiEnvironmentList(
      epienvlist: _epienvlist,
    );
  }
}
