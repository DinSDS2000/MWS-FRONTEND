import 'package:barcode_scan2/barcode_scan2.dart';

Future<String?> ScanQRCode() async {
  try {
    var result = await BarcodeScanner.scan();
    if (result.rawContent.isNotEmpty) {
      return result.rawContent;
    }
    return null;
  } catch (e) {
    print('Error scanning QR code: $e');
    return null;
  }
}
