// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epiporeceiptdtl.g.dart';

@JsonSerializable()
class EpiPOReceiptDtl {
  EpiPOReceiptDtl({
    required this.ponum,
    required this.poline,
    required this.polinerel,
    required this.vendorid,
    required this.vendornum,
    required this.partnum,
    required this.partdesc,
    this.token = '',
    this.company,
    this.packslip,
    this.whse,
    this.bin,
    this.lotnum,
    this.tranqty = 0,
    this.recvuom,
    this.porelqty = 0,
    this.entryperson,
    this.openorder = false,
    this.labelcount = 0,
    this.legalnumber,
    this.porelplant,
    this.porelwarehouse,
    this.receivedqty = 0,
    this.arrivedqty = 0,
    this.balancedqty = 0,
    this.poqty = 0,
    this.approve = false,
    this.confirmed = false,
    this.podate,
    this.packline = 0,
    this.exemptionno,
    this.purpoint,
    this.ourQty,
  });

  @JsonKey(name: 'Company')
  final String? company;

  @JsonKey(name: 'PONum')
  final int ponum;

  @JsonKey(name: 'POLine')
  final int poline;

  @JsonKey(name: 'POLineRel')
  final int polinerel;

  @JsonKey(name: 'VendorID')
  final String vendorid;

  @JsonKey(name: 'VendorNum')
  final int vendornum;

  @JsonKey(name: 'PartNum')
  final String partnum;

  @JsonKey(name: 'PartDesc')
  final String partdesc;

  @JsonKey(name: 'PackSlip')
  final String? packslip;

  @JsonKey(name: 'WarehouseCode')
  final String? whse;

  @JsonKey(name: 'BinNum')
  final String? bin;

  @JsonKey(name: 'LotNum')
  final String? lotnum;

  @JsonKey(name: 'TranQty')
  final double tranqty;

  @JsonKey(name: 'RecvUOM')
  final String? recvuom;

  @JsonKey(name: 'PORelQty')
  final double porelqty;

  @JsonKey(name: 'EntryPerson')
  final String? entryperson;

  @JsonKey(name: 'OpenOrder')
  final bool openorder;

  @JsonKey(name: 'LabelCount')
  final int labelcount;

  @JsonKey(name: 'LegalNumber')
  final String? legalnumber;

  @JsonKey(name: 'PORelPlant')
  final String? porelplant;

  @JsonKey(name: 'PORelWarehouse')
  final String? porelwarehouse;

  @JsonKey(name: 'ReceivedQty')
  final double receivedqty;

  @JsonKey(name: 'ArrivedQty')
  final double arrivedqty;

  @JsonKey(name: 'BalancedQty')
  final double balancedqty;

  @JsonKey(name: 'POQty')
  final double poqty;

  @JsonKey(name: 'Approve')
  final bool approve;

  @JsonKey(name: 'Confirmed')
  final bool confirmed;

  @JsonKey(name: 'PODate')
  final String? podate;

  @JsonKey(name: 'PackLine')
  final int packline;

  @JsonKey(name: 'PurPoint')
  final String? purpoint;

  @JsonKey(name: 'ExemptionNo')
  final String? exemptionno;

  @JsonKey(name: 'OurQty')
  final double? ourQty;

  @JsonKey(ignore: true)
  String token;

  factory EpiPOReceiptDtl.fromJson(Map<String, dynamic> json) =>
      _$EpiPOReceiptDtlFromJson(json);

  Map<String, dynamic> toJson() => _$EpiPOReceiptDtlToJson(this);

  @override
  String toString() {
    return "$partnum".toString();
  }
}

class EpiPOReceiptDtlList {
  final List<EpiPOReceiptDtl> epiporeceiptdtllist;

  EpiPOReceiptDtlList({
    required this.epiporeceiptdtllist,
  });

  factory EpiPOReceiptDtlList.fromJson(List<dynamic> json) {
    List<EpiPOReceiptDtl> _epiporeceiptdtllist =
        List<EpiPOReceiptDtl>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      _epiporeceiptdtllist =
          json.map((i) => EpiPOReceiptDtl.fromJson(i)).toList();
    }
    return new EpiPOReceiptDtlList(
      epiporeceiptdtllist: _epiporeceiptdtllist,
    );
  }
}
