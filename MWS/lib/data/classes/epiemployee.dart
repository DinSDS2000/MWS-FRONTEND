// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epiemployee.g.dart';

@JsonSerializable()
class EpiEmployee {
  EpiEmployee({
    this.token,
    required this.empId,
    this.empName,
    required this.empLaborHedSeq,
  });

  @JsonKey(name: 'EmployeeNum')
  final String empId;

  @JsonKey(name: 'EmployeeName')
  final String? empName;

  @JsonKey(name: 'LaborHedSeq')
  final int empLaborHedSeq;
  String? token;

  factory EpiEmployee.fromJson(Map<String, dynamic> json) =>
      _$EpiEmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EpiEmployeeToJson(this);

  @override
  String toString() {
    return "$empId $empName".toString();
  }
}

class EpiEmployeeList {
  final List<EpiEmployee> epiemployeelist;

  EpiEmployeeList({
    required this.epiemployeelist,
  });

  factory EpiEmployeeList.fromJson(List<dynamic> json) {
    List<EpiEmployee> epiemployeelist = List<EpiEmployee>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      epiemployeelist = json.map((i) => EpiEmployee.fromJson(i)).toList();
    }
    return new EpiEmployeeList(
      epiemployeelist: epiemployeelist,
    );
  }
}
