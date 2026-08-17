// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epishipdtl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiShipDtl _$EpiShipDtlFromJson(Map<String, dynamic> json) => EpiShipDtl(
      shipHeadSDPlanIdC: json['ShipHead_SD_PlanId_c'] as String?,
      shipDtlSDLineNoC: (json['ShipDtl_SD_LineNo_c'] as num?)?.toInt(),
      shipHeadPackNum: (json['ShipHead_PackNum'] as num?)?.toInt(),
      shipDtlPackLine: (json['ShipDtl_PackLine'] as num?)?.toInt(),
      shipDtlLineDesc: json['ShipDtl_LineDesc'] as String?,
      shipDtlCustNum: (json['ShipDtl_CustNum'] as num?)?.toInt(),
      custID: json['customerID'] as String?,
      custName: json['CustomerName'] as String?,
      shipDtlOurInventoryShipQty:
          (json['ShipDtl_OurInventoryShipQty'] as num?)?.toDouble(),
      shipDtlPartNum: json['ShipDtl_PartNum'] as String?,
      shipDtlOrderNum: (json['ShipDtl_OrderNum'] as num?)?.toInt(),
      shipDtlOrderLine: (json['ShipDtl_OrderLine'] as num?)?.toInt(),
      shipDtlOrderRelNum: (json['ShipDtl_OrderRelNum'] as num?)?.toInt(),
      ud100aQuantityC: (json['UD100A_Quantity_c'] as num?)?.toDouble(),
      ud100aLorryC: json['UD100A_Lorry_c'] as String?,
      shipDtlShipCmpl: json['ShipDtl_ShipCmpl'] as bool?,
      shipDtlSalesUM: json['ShipDtl_SalesUM'] as String?,
      shipDtlIUM: json['ShipDtl_IUM'] as String?,
    );

Map<String, dynamic> _$EpiShipDtlToJson(EpiShipDtl instance) =>
    <String, dynamic>{
      'ShipHead_SD_PlanId_c': instance.shipHeadSDPlanIdC,
      'ShipDtl_SD_LineNo_c': instance.shipDtlSDLineNoC,
      'ShipHead_PackNum': instance.shipHeadPackNum,
      'ShipDtl_PackLine': instance.shipDtlPackLine,
      'ShipDtl_LineDesc': instance.shipDtlLineDesc,
      'ShipDtl_CustNum': instance.shipDtlCustNum,
      'customerID': instance.custID,
      'CustomerName': instance.custName,
      'ShipDtl_OurInventoryShipQty': instance.shipDtlOurInventoryShipQty,
      'ShipDtl_PartNum': instance.shipDtlPartNum,
      'ShipDtl_OrderNum': instance.shipDtlOrderNum,
      'ShipDtl_OrderLine': instance.shipDtlOrderLine,
      'ShipDtl_OrderRelNum': instance.shipDtlOrderRelNum,
      'UD100A_Quantity_c': instance.ud100aQuantityC,
      'UD100A_Lorry_c': instance.ud100aLorryC,
      'ShipDtl_ShipCmpl': instance.shipDtlShipCmpl,
      'ShipDtl_SalesUM': instance.shipDtlSalesUM,
      'ShipDtl_IUM': instance.shipDtlIUM,
    };
