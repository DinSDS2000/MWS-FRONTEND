import 'package:json_annotation/json_annotation.dart';

part 'epiporeceipt.g.dart';

@JsonSerializable()
class EpiPOReceipt {
  EpiPOReceipt({
    this.token,
    this.ponum,
    this.podate,
    this.vendorid,
    this.vendorname,
    this.buyer,
    this.shipviacode,
    this.termcode,
    this.purpoint,
    this.currencycode,
    this.approve,
    this.doctoorder,
    this.legalnumber,
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
    this.epiporeceiptlist,
  });

  factory EpiPOReceiptList.fromJson(List<dynamic> json) {
    List<EpiPOReceipt> _epiporeceiptlist = new List<EpiPOReceipt>();

    for (var i = 0; i < json.length; i++) {
      _epiporeceiptlist = json.map((i) => EpiPOReceipt.fromJson(i)).toList();
    }
    return new EpiPOReceiptList(
      epiporeceiptlist: _epiporeceiptlist,
    );
  }
}
