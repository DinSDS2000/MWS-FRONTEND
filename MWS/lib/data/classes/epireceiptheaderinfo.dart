class ReceiptHeaderInfo {
  final bool exists;
  final String driverName;
  final String lorry;
  final String driverIC;

  ReceiptHeaderInfo({
    required this.exists,
    required this.driverName,
    required this.lorry,
    required this.driverIC,
  });

  // Factory constructor to safely parse data from your updated C# backend
  factory ReceiptHeaderInfo.fromJson(Map<String, dynamic> json) {
    return ReceiptHeaderInfo(
      exists: json['exists'] ?? false,
      driverName: json['SD_DriverName_c'] ??
          '', // Match backend JSON serialization case
      lorry: json['SD_Lorry_c'] ?? '',
      driverIC: json['SD_DriverIC_c'] ?? '',
    );
  }
}
