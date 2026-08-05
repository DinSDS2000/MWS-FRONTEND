// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epireprint.g.dart';

@JsonSerializable()
class EpiReprintInfo {
  EpiReprintInfo({
    required this.company,
    required this.partNum,
    required this.partDesc,
    this.lotNum,
    this.fromSeq,
    this.toSeq,
    this.batch,
    this.sysDate,
    this.tranType,
    required this.tranNum,
  });

  @JsonKey(name: 'Part_Company')
  final String company;

  @JsonKey(name: 'Part_PartNum')
  final String partNum;

  @JsonKey(name: 'Part_PartDescription')
  final String partDesc;

  @JsonKey(name: 'PartTran_LotNum')
  final String? lotNum;

  // Handles numerical values safely
  @JsonKey(name: 'PartTran_SD_FromSeq_c')
  final int? fromSeq;

  @JsonKey(name: 'PartTran_SD_ToSeq_c')
  final int? toSeq;

  @JsonKey(name: 'PartLot_Batch')
  final String? batch;

  @JsonKey(name: 'PartTran_SysDate')
  final String? sysDate;

  @JsonKey(name: 'PartTran_TranType')
  final String? tranType;

  @JsonKey(name: 'PartTran_TranNum')
  final int tranNum;

  factory EpiReprintInfo.fromJson(Map<String, dynamic> json) =>
      _$EpiReprintInfoFromJson(json);

  Map<String, dynamic> toJson() => _$EpiReprintInfoToJson(this);

  @override
  String toString() {
    return "$partNum - Lot: $lotNum ($fromSeq to $toSeq)";
  }
}

class EpiReprintInfoList {
  final List<EpiReprintInfo> reprintList;

  EpiReprintInfoList({
    required this.reprintList,
  });

  // High-performance single-pass array mapper without loop nesting overhead
  factory EpiReprintInfoList.fromJson(List<dynamic> json) {
    return EpiReprintInfoList(
      reprintList: json.map((item) => EpiReprintInfo.fromJson(item)).toList(),
    );
  }
}
