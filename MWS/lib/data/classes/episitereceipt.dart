import 'package:json_annotation/json_annotation.dart';

part 'episitereceipt.g.dart';

@JsonSerializable()
class EpiSiteReceipt {
  EpiSiteReceipt({
    required this.token,
    required this.company,
    required this.trandate,
    required this.whsedescription,
    required this.bindescription,
    required this.jobnum,
    required this.partnum,
    required this.partdescription,
    required this.tranqty,
    required this.uom,
    required this.refno,
    required this.seqno,
    required this.rcvdqty,
    required this.submitqty,
    required this.fullrcv,
  });

  final String company;

  final String partnum;

  final String partdescription;

  final String trandate;

  final String whsedescription;

  final String bindescription;

  final String jobnum;

  final num tranqty;

  final String uom;

  final String refno;

  final String seqno;

  final num rcvdqty;

  num submitqty;

  bool fullrcv;

  @JsonKey(nullable: true)
  String token;

  factory EpiSiteReceipt.fromJson(Map<String, dynamic> json) =>
      _$EpiSiteReceiptFromJson(json);

  Map<String, dynamic> toJson() => _$EpiSiteReceiptToJson(this);

  @override
  String toString() {
    return "$partdescription $uom".toString();
  }
}

class EpiSiteReceiptList {
  final List<EpiSiteReceipt> episitereceiptlist;

  EpiSiteReceiptList({
    required this.episitereceiptlist,
  });

  factory EpiSiteReceiptList.fromJson(List<dynamic> json) {
    // Convert JSON list → Dart object list
    final episitereceiptlist = json
        .map((item) => EpiSiteReceipt.fromJson(item as Map<String, dynamic>))
        .toList();

    return EpiSiteReceiptList(episitereceiptlist: episitereceiptlist);
  }
}
