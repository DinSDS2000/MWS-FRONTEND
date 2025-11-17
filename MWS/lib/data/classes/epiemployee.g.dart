// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epiemployee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiEmployee _$EpiEmployeeFromJson(Map<String, dynamic> json) => EpiEmployee(
      token: json['token'] as String?,
      empId: json['EmployeeNum'] as String,
      empName: json['EmployeeName'] as String?,
      empLaborHedSeq: (json['LaborHedSeq'] as num).toInt(),
    );

Map<String, dynamic> _$EpiEmployeeToJson(EpiEmployee instance) =>
    <String, dynamic>{
      'EmployeeNum': instance.empId,
      'EmployeeName': instance.empName,
      'LaborHedSeq': instance.empLaborHedSeq,
      'token': instance.token,
    };
