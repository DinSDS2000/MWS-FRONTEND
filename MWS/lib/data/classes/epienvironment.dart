// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epienvironment.g.dart';

@JsonSerializable()
class EpiEnvironment {
  EpiEnvironment({
    this.token,
    required this.envid,
    required this.envdescription,
    required this.envisactive,
    required this.envappserver,
    required this.envappepicor,
    required this.envappuserid,
    required this.envapppasskey,
    required this.envsqlserver,
    required this.envsqldb,
    this.envsqluserid,
    this.envsqlpasskey,
    required this.envbarcodeseperator,
    required this.envbarcodeseperator2,
  });

  @JsonKey(name: 'Env_ID')
  final String envid;

  @JsonKey(name: 'Env_Description')
  final String envdescription;

  @JsonKey(name: 'Env_IsActive')
  final bool envisactive;

  @JsonKey(name: 'Env_AppServer')
  final String envappserver;

  @JsonKey(name: 'Env_AppEpicor')
  final String envappepicor;

  @JsonKey(name: 'Env_AppUserId')
  final String envappuserid;

  @JsonKey(name: 'Env_AppPassKey')
  final String envapppasskey;

  @JsonKey(name: 'Env_SQLServer')
  final String envsqlserver;

  @JsonKey(name: 'Env_SQLDB')
  final String envsqldb;

  @JsonKey(name: 'Env_SQLUserId')
  final String? envsqluserid;

  @JsonKey(name: 'Env_SQLPassKey')
  final String? envsqlpasskey;

  @JsonKey(name: 'Env_BarCodeSeperator')
  final String envbarcodeseperator;

  @JsonKey(name: 'Env_BarCodeSeperator2')
  final String envbarcodeseperator2;

  String? token;

  factory EpiEnvironment.fromJson(Map<String, dynamic> json) =>
      _$EpiEnvironmentFromJson(json);

  Map<String, dynamic> toJson() => _$EpiEnvironmentToJson(this);

  @override
  String toString() => "$envid $envdescription";
}

class EpiEnvironmentList {
  final List<EpiEnvironment> epienvlist;

  EpiEnvironmentList({required this.epienvlist});

  factory EpiEnvironmentList.fromJson(List<dynamic> json) {
    final _epienvlist = json
        .map((item) => EpiEnvironment.fromJson(item as Map<String, dynamic>))
        .toList();

    return EpiEnvironmentList(epienvlist: _epienvlist);
  }
}
