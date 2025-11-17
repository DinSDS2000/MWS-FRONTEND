// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epiporeceipt.g.dart';

@JsonSerializable()
class EpiPOReceipt {
  EpiPOReceipt({
    required this.token,
    required this.ponum,
    required this.podate,
    required this.vendorid,
    required this.vendorname,
    required this.buyer,
    required this.shipviacode,
    required this.termcode,
    required this.purpoint,
    required this.currencycode,
    required this.approve,
    required this.doctoorder,
    required this.legalnumber,
  });

  final int ponum;

  final String podate;

  final String vendorid;

  final String vendorname;

  final String buyer;

  final String shipviacode;

  final String termcode;

  final String purpoint;

  final String currencycode;

  final bool approve;

  final double doctoorder;

  final String legalnumber;

  @JsonKey(nullable: true)
  String token;

  factory EpiPOReceipt.fromJson(Map<String, dynamic> json) =>
      _$EpiPOReceiptFromJson(json);

  Map<String, dynamic> toJson() => _$EpiPOReceiptToJson(this);

  @override
  String toString() {
    return "$ponum".toString();
  }
}

class EpiPOReceiptList {
  final List<EpiPOReceipt> epiporeceiptlist;

  EpiPOReceiptList({
    required this.epiporeceiptlist,
  });

  factory EpiPOReceiptList.fromJson(List<dynamic> json) {
    List<EpiPOReceipt> _epiporeceiptlist = List<EpiPOReceipt>.empty(growable: true);

    for (var i = 0; i < json.length; i++) {
      _epiporeceiptlist = json.map((i) => EpiPOReceipt.fromJson(i)).toList();
    }
    return new EpiPOReceiptList(
      epiporeceiptlist: _epiporeceiptlist,
    );
  }
}
