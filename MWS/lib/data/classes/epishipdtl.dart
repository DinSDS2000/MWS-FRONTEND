import 'package:json_annotation/json_annotation.dart';

part 'epishipdtl.g.dart';

@JsonSerializable()
class EpiShipDtl {
  EpiShipDtl({
    this.shipHeadSDPlanIdC,
    this.shipDtlSDLineNoC,
    this.shipHeadPackNum,
    this.shipDtlPackLine,
    this.shipDtlLineDesc,
    this.shipDtlCustNum,
    this.custID,
    this.custName,
    this.shipDtlOurInventoryShipQty,
    this.shipDtlPartNum,
    this.shipDtlOrderNum,
    this.shipDtlOrderLine,
    this.shipDtlOrderRelNum,
    this.ud100aQuantityC,
    this.ud100aLorryC,
    this.shipDtlShipCmpl,
    this.shipDtlSalesUM,
    this.shipDtlIUM,
  });

  @JsonKey(name: 'ShipHead_SD_PlanId_c')
  final String? shipHeadSDPlanIdC;

  @JsonKey(name: 'ShipDtl_SD_LineNo_c')
  final int? shipDtlSDLineNoC;

  @JsonKey(name: 'ShipHead_PackNum')
  final int? shipHeadPackNum;

  @JsonKey(name: 'ShipDtl_PackLine')
  final int? shipDtlPackLine;

  @JsonKey(name: 'ShipDtl_LineDesc')
  final String? shipDtlLineDesc;

  @JsonKey(name: 'ShipDtl_CustNum')
  final int? shipDtlCustNum;

  @JsonKey(name: 'customerID')
  final String? custID;

  @JsonKey(name: 'CustomerName')
  final String? custName;

  @JsonKey(name: 'ShipDtl_OurInventoryShipQty')
  final double? shipDtlOurInventoryShipQty;

  @JsonKey(name: 'ShipDtl_PartNum')
  final String? shipDtlPartNum;

  @JsonKey(name: 'ShipDtl_OrderNum')
  final int? shipDtlOrderNum;

  @JsonKey(name: 'ShipDtl_OrderLine')
  final int? shipDtlOrderLine;

  @JsonKey(name: 'ShipDtl_OrderRelNum')
  final int? shipDtlOrderRelNum;

  @JsonKey(name: 'UD100A_Quantity_c')
  final double? ud100aQuantityC;

  @JsonKey(name: 'UD100A_Lorry_c')
  final String? ud100aLorryC;

  @JsonKey(name: 'ShipDtl_ShipCmpl')
  final bool? shipDtlShipCmpl;

  @JsonKey(name: 'ShipDtl_SalesUM')
  final String? shipDtlSalesUM;

  @JsonKey(name: 'ShipDtl_IUM')
  final String? shipDtlIUM;

  factory EpiShipDtl.fromJson(Map<String, dynamic> json) =>
      _$EpiShipDtlFromJson(json);

  Map<String, dynamic> toJson() => _$EpiShipDtlToJson(this);
}

class EpiShipDtlList {
  final List<EpiShipDtl> items;

  EpiShipDtlList({required this.items});

  factory EpiShipDtlList.fromJson(Map<String, dynamic> json) {
    return EpiShipDtlList(
      items: (json['value'] as List<dynamic>)
          .map((e) => EpiShipDtl.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
