import 'package:json_annotation/json_annotation.dart';

part 'epijobmtlreqqty.g.dart';

@JsonSerializable()
class EpiJobMtlReqQty {
  EpiJobMtlReqQty({
    this.token,
    required this.partnum,
    required this.qtyper,
    required this.IUM,
  });

  @JsonKey(name: 'PartNum')
  final String partnum;

  @JsonKey(name: 'QtyPer')
  final int qtyper;

  final String IUM;

  String? token;

  factory EpiJobMtlReqQty.fromJson(Map<String, dynamic> json) =>
      _$EpiJobMtlReqQtyFromJson(json);

  Map<String, dynamic> toJson() => _$EpiJobMtlReqQtyToJson(this);
}
