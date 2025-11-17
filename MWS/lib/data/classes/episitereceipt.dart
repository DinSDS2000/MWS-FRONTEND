import 'package:json_annotation/json_annotation.dart';

part 'episitereceipt.g.dart';

@JsonSerializable()
class EpiSiteReceipt {
  EpiSiteReceipt({
    this.token,
    this.company,
    this.trandate,
    this.whsedescription,
    this.bindescription,
    this.jobnum,
    this.partnum,
    this.partdescription,
    this.tranqty,
    this.uom,
    this.refno,
    this.seqno,
    this.rcvdqty,
    this.submitqty,
    this.fullrcv,
  });

  @JsonKey(name: "UD09_Company")
  String? company;

  @JsonKey(name: "UD09_ShortChar01")
  String? partnum;

  @JsonKey(name: "UD09_Character01")
  String? partdescription;

  @JsonKey(name: "UD09_Date01")
  String? trandate;

  @JsonKey(name: "Warehse_Description")
  String? whsedescription;

  @JsonKey(name: "WhseBin_Description")
  String? bindescription;

  @JsonKey(name: "UD09_Key3")
  String? jobnum;

  @JsonKey(name: "UD09_Number02")
  num? tranqty;

  @JsonKey(name: "UD09_ShortChar02")
  String? uom;

  @JsonKey(name: "UD09_Key1")
  String? refno;

  @JsonKey(name: "Calculated_SeqNo")
  String? seqno;

  num? rcvdqty;

  @JsonKey(name: "Calculated_TotalSubmitQty")
  num? submitqty;

  bool? fullrcv;

  String? token;

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
