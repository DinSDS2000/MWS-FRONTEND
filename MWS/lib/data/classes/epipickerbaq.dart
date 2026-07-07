import 'package:json_annotation/json_annotation.dart';

part 'epipickerbaq.g.dart';

@JsonSerializable()
class Epipickerbaq {
  Epipickerbaq({
    this.ud100aPickerC,
    this.ud100aProductC,
    this.ud100CustomerC,
    this.custName,
    this.ud100aSoNoC,
    this.ud100aTransporterC,
    this.ud100Key1,
    this.ud100aChildKey1,
    this.ud100aProductDescC,
    this.ud100aQuantityC,
    this.ud100aUomC,
    this.ud100aWarehouseC,
    this.ud100aBinC,
    this.ud100aLotC,
    this.ud100aLorryC,
    this.ud100aLoadQtyC,
    this.ud100aSOReleaseC,
    this.ud100aSOLineC,
    this.orderRelNeedByDate,
    this.orderHedOrderComment,
    this.orderRelExemptionNo,
    this.warehouseCode,
    this.rowIdent,
  });

  @JsonKey(name: 'UD100A_Picker_c')
  final String? ud100aPickerC;

  @JsonKey(name: 'UD100A_Product_c')
  final String? ud100aProductC;

  @JsonKey(name: 'UD100_Customer_c')
  final String? ud100CustomerC;

  @JsonKey(name: 'CustName')
  final String? custName;

  @JsonKey(name: 'UD100A_SONo_c')
  final String? ud100aSoNoC;

  @JsonKey(name: 'UD100A_Transporter_c')
  final String? ud100aTransporterC;

  @JsonKey(name: 'UD100_Key1')
  final String? ud100Key1;

  @JsonKey(name: 'UD100A_ChildKey1')
  final String? ud100aChildKey1;

  @JsonKey(name: 'UD100A_ProductDesc_c')
  final String? ud100aProductDescC;

  @JsonKey(name: 'UD100A_Quantity_c')
  final double? ud100aQuantityC;

  @JsonKey(name: 'UD100A_UOM_c')
  final String? ud100aUomC;

  @JsonKey(name: 'UD100A_Warehouse_c')
  final String? ud100aWarehouseC;

  @JsonKey(name: 'UD100A_Bin_c')
  final String? ud100aBinC;

  @JsonKey(name: 'UD100A_Lot_c')
  final String? ud100aLotC;

  @JsonKey(name: 'UD100A_Lorry_c')
  final String? ud100aLorryC;

  @JsonKey(name: 'UD100A_LoadQty_c')
  final double? ud100aLoadQtyC;

  @JsonKey(name: 'UD100A_SORelease_c')
  final String? ud100aSOReleaseC;

  @JsonKey(name: 'UD100A_SOLine_c')
  final String? ud100aSOLineC;

  @JsonKey(name: 'OrderRel_NeedByDate')
  final String? orderRelNeedByDate;

  @JsonKey(name: 'OrderHed_OrderComment')
  final String? orderHedOrderComment;

  @JsonKey(name: 'OrderRel_SD_ExemptionNo_c')
  final String? orderRelExemptionNo;

  @JsonKey(name: 'OrderRel_WarehouseCode')
  final String? warehouseCode;

  @JsonKey(name: 'RowIdent')
  final String? rowIdent;

  factory Epipickerbaq.fromJson(Map<String, dynamic> json) =>
      _$EpipickerbaqFromJson(json);
  Map<String, dynamic> toJson() => _$EpipickerbaqToJson(this);
}

class EpiPickerBaqList {
  final List<Epipickerbaq> items;

  EpiPickerBaqList({required this.items});

  factory EpiPickerBaqList.fromJson(Map<String, dynamic> json) {
    return EpiPickerBaqList(
      items: (json['value'] as List<dynamic>)
          .map((e) => Epipickerbaq.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
