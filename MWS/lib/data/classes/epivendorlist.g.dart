// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epivendorlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpiVendor _$EpiVendorFromJson(Map<String, dynamic> json) => EpiVendor(
      id: json['Vendor_VendorID'] as String,
      name: json['Vendor_Name'] as String,
    );

Map<String, dynamic> _$EpiVendorToJson(EpiVendor instance) => <String, dynamic>{
      'Vendor_VendorID': instance.id,
      'Vendor_Name': instance.name,
    };
