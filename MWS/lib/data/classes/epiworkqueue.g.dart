// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epiworkqueue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiWorkQueue _$EpiWorkQueueFromJson(Map<String, dynamic> json) => EpiWorkQueue(
      token: json['token'] as String?,
      jobno: json['JobNum'] as String,
      asmno: (json['AssemblySeq'] as num).toInt(),
      oprno: (json['OprSeq'] as num).toInt(),
      opcode: json['OpCode'] as String,
      resgroupid: json['ResourceGrpID'] as String,
      resid: json['ResourceID'] as String,
      labortype: json['LaborType'] as String,
      empid: json['EmployeeNum'] as String,
      empname: json['EmployeeName'] as String,
      clockindate: json['ClockInDate'] as String,
      clockintime: json['ClockIntime'] as String,
      transqty: (json['TranQty'] as num).toDouble(),
      laborhedseq: (json['LaborHedSeq'] as num).toInt(),
      labordtlseq: (json['LaborDtlSeq'] as num).toInt(),
    );

Map<String, dynamic> _$EpiWorkQueueToJson(EpiWorkQueue instance) =>
    <String, dynamic>{
      'JobNum': instance.jobno,
      'AssemblySeq': instance.asmno,
      'OprSeq': instance.oprno,
      'OpCode': instance.opcode,
      'ResourceGrpID': instance.resgroupid,
      'ResourceID': instance.resid,
      'LaborType': instance.labortype,
      'EmployeeNum': instance.empid,
      'EmployeeName': instance.empname,
      'ClockInDate': instance.clockindate,
      'ClockIntime': instance.clockintime,
      'TranQty': instance.transqty,
      'LaborHedSeq': instance.laborhedseq,
      'LaborDtlSeq': instance.labordtlseq,
      'token': instance.token,
    };
