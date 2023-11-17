import 'package:json_annotation/json_annotation.dart';

part 'epiemployee.g.dart';

@JsonSerializable()
class EpiEmployee {
  EpiEmployee({
    this.token,
    this.empId,
    this.empName,
    this.empLaborHedSeq,
  });

  final String empId;

  final String empName;

  final int empLaborHedSeq;

  @JsonKey(nullable: true)
  String token;

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
    this.epiemployeelist,
  });

  factory EpiEmployeeList.fromJson(List<dynamic> json) {
    List<EpiEmployee> epiemployeelist = new List<EpiEmployee>();

    for (var i = 0; i < json.length; i++) {
      epiemployeelist = json.map((i) => EpiEmployee.fromJson(i)).toList();
    }
    return new EpiEmployeeList(
      epiemployeelist: epiemployeelist,
    );
  }
}
