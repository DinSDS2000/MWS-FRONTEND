import 'package:json_annotation/json_annotation.dart';

part 'epiporeceiptdtl.g.dart';

@JsonSerializable()
class EpiPOReceiptDtl {
  EpiPOReceiptDtl({
    this.token,
    this.ponum,
    this.poline,
    this.polinerel,
    this.partnum,
    this.partdesc,
    this.dporelqty,
    this.vendorid,
    this.vendornum,
    this.whse,
    this.bin,
    this.lotnum,
  });

  final int ponum;

  final int poline;

  final int polinerel;

  final String partnum;

  final String partdesc;

  final double dporelqty;

  final String vendorid;

  final int vendornum;

  final String whse;

  final String bin;

  final String lotnum;

  @JsonKey(nullable: true)
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
    this.epiporeceiptdtllist,
  });

  factory EpiPOReceiptDtlList.fromJson(List<dynamic> json) {
    List<EpiPOReceiptDtl> _epiporeceiptdtllist = new List<EpiPOReceiptDtl>();

    for (var i = 0; i < json.length; i++) {
      _epiporeceiptdtllist = json.map((i) => EpiPOReceiptDtl.fromJson(i)).toList();
    }
    return new EpiPOReceiptDtlList(
      epiporeceiptdtllist: _epiporeceiptdtllist,
    );
  }
}
