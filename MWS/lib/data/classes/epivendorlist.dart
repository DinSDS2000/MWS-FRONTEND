// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'epivendorlist.g.dart';

@JsonSerializable()
class EpiVendor {
  EpiVendor({
    required this.id,
    required this.name,
  });

  // Matches the exact "Vendor_VendorID" key returned by your Epicor BAQ
  @JsonKey(name: 'Vendor_VendorID')
  final String id;

  // Matches the exact "Vendor_Name" key returned by your Epicor BAQ
  @JsonKey(name: 'Vendor_Name')
  final String name;

  factory EpiVendor.fromJson(Map<String, dynamic> json) =>
      _$EpiVendorFromJson(json);

  Map<String, dynamic> toJson() => _$EpiVendorToJson(this);

  @override
  String toString() {
    return "$name ($id)";
  }
}

class EpiVendorList {
  final List<EpiVendor> epiVendorList;

  EpiVendorList({
    required this.epiVendorList,
  });

  // Safe constructor implementation that iterates and parses the raw JSON array cleanly
  factory EpiVendorList.fromJson(List<dynamic> json) {
    List<EpiVendor> epiVendorList =
        json.map((i) => EpiVendor.fromJson(i as Map<String, dynamic>)).toList();
    return EpiVendorList(
      epiVendorList: epiVendorList,
    );
  }
}
