// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epienvironment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiEnvironment _$EpiEnvironmentFromJson(Map<String, dynamic> json) =>
    EpiEnvironment(
      token: json['token'] as String?,
      envid: json['Env_ID'] as String,
      envdescription: json['Env_Description'] as String,
      envisactive: json['Env_IsActive'] as bool,
      envappserver: json['Env_AppServer'] as String,
      envappepicor: json['Env_AppEpicor'] as String,
      envappuserid: json['Env_AppUserId'] as String,
      envapppasskey: json['Env_AppPassKey'] as String,
      envsqlserver: json['Env_SQLServer'] as String,
      envsqldb: json['Env_SQLDB'] as String,
      envsqluserid: json['Env_SQLUserId'] as String?,
      envsqlpasskey: json['Env_SQLPassKey'] as String?,
      envbarcodeseperator: json['Env_BarCodeSeperator'] as String,
      envbarcodeseperator2: json['Env_BarCodeSeperator2'] as String,
    );

Map<String, dynamic> _$EpiEnvironmentToJson(EpiEnvironment instance) =>
    <String, dynamic>{
      'Env_ID': instance.envid,
      'Env_Description': instance.envdescription,
      'Env_IsActive': instance.envisactive,
      'Env_AppServer': instance.envappserver,
      'Env_AppEpicor': instance.envappepicor,
      'Env_AppUserId': instance.envappuserid,
      'Env_AppPassKey': instance.envapppasskey,
      'Env_SQLServer': instance.envsqlserver,
      'Env_SQLDB': instance.envsqldb,
      'Env_SQLUserId': instance.envsqluserid,
      'Env_SQLPassKey': instance.envsqlpasskey,
      'Env_BarCodeSeperator': instance.envbarcodeseperator,
      'Env_BarCodeSeperator2': instance.envbarcodeseperator2,
      'token': instance.token,
    };
