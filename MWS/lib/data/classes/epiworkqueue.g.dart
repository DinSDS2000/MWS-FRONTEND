// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epiworkqueue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiWorkQueue _$EpiWorkQueueFromJson(Map<String, dynamic> json) {
  return EpiWorkQueue(
      jobno: json['JobNum'] as String,
      asmno: json['AssemblySeq'] as int,
      oprno: json['OprSeq'] as int,
      opcode: json['OpCode'] as String,
      resgroupid: json['ResourceGrpID'] as String,
      resid: json['ResourceID'] as String,
      labortype: json['LaborType'] as String,
      empid: json['EmployeeNum'] as String,
      empname: json['EmployeeName'] as String,
      clockindate: json['ClockInDate'] as String,
      clockintime: json['ClockIntime'] as String,
      transqty: json['TranQty'] as double,
      laborhedseq: json['LaborHedSeq'] as int,
      labordtlseq: json['LaborDtlSeq'] as int);
}

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
      'LaborDtlSeq': instance.labordtlseq
    };
