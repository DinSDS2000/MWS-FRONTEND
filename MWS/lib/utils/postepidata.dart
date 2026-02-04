import 'dart:convert';

import 'package:flutter_epihhinventory/data/classes/episplitmergeuom.dart';
import 'package:flutter_epihhinventory/data/classes/user.dart';
import 'package:flutter_epihhinventory/data/web_client.dart';
// import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';
import '../utils/globals.dart' as _globals;
import 'package:http/http.dart' as http;
import 'dart:io';

Future<List<dynamic>> postIssueMaterial(
    String jobNo,
    String asmNo,
    String partNo,
    String ium,
    String tranQty,
    String frWhse,
    String frBin,
    String toWhse,
    String toBin,
    String mtlNo,
    String lotNo,
    String refNo,
    String noofLabel) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strJobNum=' +
      jobNo +
      '&iAssemblySeq=' +
      asmNo +
      '&strPartNum=' +
      partNo +
      '&strIUM=' +
      ium +
      '&dTranQty=' +
      tranQty +
      '&strFromWarehouseCode=' +
      frWhse +
      '&strFromBinNum=' +
      frBin +
      '&strToWarehouseCode=' +
      toWhse +
      '&strToBinNum=' +
      toBin +
      '&iMaterialSeq=' +
      mtlNo +
      '&strLotNum=' +
      lotNo +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&iLabelCount=' +
      noofLabel +
      '&strReference=' +
      refNo;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/issuemtl/PerformIssueMaterial' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postReturnMaterial(
    String jobNo,
    String asmNo,
    String partNo,
    String ium,
    String tranQty,
    String frWhse,
    String frBin,
    String toWhse,
    String toBin,
    String mtlNo,
    String lotNo,
    String refNo,
    String noofLabel) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strJobNum=' +
      jobNo +
      '&iAssemblySeq=' +
      asmNo +
      '&iMaterialSeq=' +
      mtlNo +
      '&strPartNum=' +
      partNo +
      '&strLotNum=' +
      lotNo +
      '&dTranQty=' +
      tranQty +
      '&strIUM=' +
      ium +
      '&strFromWarehouseCode=' +
      frWhse +
      '&strFromBinNum=' +
      frBin +
      '&strToWarehouseCode=' +
      toWhse +
      '&strToBinNum=' +
      toBin +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&iLabelCount=' +
      noofLabel +
      '&strReference=' +
      refNo;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl +
        '/api/jobtoinventory/PerformMaterialToInventory' +
        _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<Map<String, dynamic>> createCustShipHeader({
  required int orderNum,
  required String custId,
  required String planId,
  required int lineNo,
}) async {
  final url =
      Uri.parse('${_globals.epiApiBaseUrl}/api/CustShip/CreateCustShipHeader'
          '?username=${_globals.epiUsername}'
          '&password=${Uri.encodeComponent(_globals.epiPassword)}'
          '&company=${_globals.epiCompanyId}'
          '&envID=${_globals.epiEnvId}'
          '&plant=${_globals.epiSiteId}'
          '&orderNum=$orderNum'
          '&custId=$custId'
          '&shipPerson=${_globals.epiUsername}'
          '&planId=$planId'
          '&lineNo=$lineNo');

  print("url: $url");

  final headers = {
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  final response = await http.post(
    url,
    headers: headers,
  );
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);

    if (jsonData is Map && jsonData['Success'] == false) {
      // Handle error

      throw Exception(jsonData['Errors']?.join(', ') ?? 'Unknown error');
    }
    print("testtest:${jsonData}");
    return jsonData;
  } else {
    throw Exception('HTTP error: ${response.statusCode}, ${response.body}');
  }
}

Future<Map<String, dynamic>> createCustShipDtl({
  required int packNum,
  required int orderNum,
  required int orderLine,
  required int orderReleaseNum,
  required String whse,
  required String binNum,
  required String lotNum,
  required String planID,
  required String childKey1,
  required int quantity,
}) async {
  final uri =
      Uri.parse('${_globals.epiApiBaseUrl}/api/CustShip/CreateCustShipDtl')
          .replace(
    queryParameters: {
      'username': _globals.epiUsername,
      'password': _globals.epiPassword,
      'company': _globals.epiCompanyId,
      'plant': _globals.epiSiteId,
      'envID': _globals.epiEnvId,
      'packNum': packNum.toString(),
      'orderNum': orderNum.toString(),
      'orderLine': orderLine.toString(),
      'orderReleaseNum': orderReleaseNum.toString(),
      'whse': whse,
      'binNum': binNum,
      'lotNum': lotNum,
      'planId': planID,
      'childKey': childKey1,
      'quantity': quantity.toString(),
    },
  );
  print("url shipdtl: $uri");
  final response = await http.post(
    uri,
    headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json',
    },
  );
  print("RESPONSE SHIPDTL1 : ${response.body}");
  if (response.statusCode == 200) {
    print("RESPONSE SHIPDTL: ${response.body}");

    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    print("error creating ship dtl");
    throw Exception('Failed to create CustShipDtl: ${response.body}');
  }
}

Future<List<dynamic>> updateShipDtlQty({
  required int packLine,
  required int packNum,
  required double qty,
  required String lorry,
  required String driver,
  required String transporter,
  required String planID,
  required String childKey,
}) async {
  final url = Uri.parse(
    '${_globals.epiApiBaseUrl}/api/CustShip/UpdateShipDtlQty'
    '?username=${_globals.epiUsername}'
    '&password=${Uri.encodeComponent(_globals.epiPassword)}'
    '&company=${_globals.epiCompanyId}'
    '&plant=${_globals.epiSiteId}'
    '&envID=${_globals.epiEnvId}'
    '&packNum=${packNum}'
    '&packLine=${packLine}'
    '&qty=${qty}'
    '&lorry=${Uri.encodeComponent(lorry)}'
    '&driver=${Uri.encodeComponent(driver)}'
    '&transporter=${Uri.encodeComponent(transporter)}'
    '&planID=${Uri.encodeComponent(planID)}'
    '&childKey=${Uri.encodeComponent(childKey)}',
  );

  print("URL: $url");

  try {
    final response = await http.post(
      url,
    );

    print('Raw response: ${response.statusCode} | ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return [
        true,
        jsonResponse['Message'] ?? 'ShipDtl updated successfully',
        jsonResponse['Updated']
      ];
    } else {
      final errorResponse = jsonDecode(response.body);
      return [false, errorResponse['Errors'] ?? 'Unknown error'];
    }
  } catch (e) {
    return [false, e.toString()];
  }
}

Future<List<dynamic>> updatePickerDelivery({
  required String key1,
  required String childKey1,
  required double quantityC,
  required String warehouseC,
  required String binC,
  required String lotC,
}) async {
  final url = Uri.parse(
    '${_globals.epiApiBaseUrl}/api/DeliveryTracking/UpdatePickerDelivery'
    '?strUID=${_globals.epiUsername}'
    '&strPass=${Uri.encodeComponent(_globals.epiPassword)}'
    '&strCurCompany=${_globals.epiCompanyId}'
    '&strCurPlant=${_globals.epiSiteId}'
    '&strEnvId=${_globals.epiEnvId}'
    '&key1=$key1'
    '&childKey1=$childKey1',
  );

  final body = {
    "LoadQty_c": quantityC,
    "Warehouse_c": warehouseC,
    "Bin_c": binC,
    "Lot_c": lotC,
  };

  print("QUANTITY: $quantityC");

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  final response = await http.patch(
    url,
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode == 200 || response.statusCode == 204) {
    return [true, response.body];
  } else {
    return [false, response.body];
  }
}

Future<List<dynamic>> postIssueMiscMaterial(
    String partNo,
    String ium,
    String tranQty,
    String frWhse,
    String frBin,
    String toWhse,
    String toBin,
    String lotNo,
    String reason,
    String refNo,
    String noofLabel) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strPartNum=' +
      partNo +
      '&strIUM=' +
      ium +
      '&dTranQty=' +
      tranQty +
      '&strWarehouseCode=' +
      frWhse +
      '&strBinNum=' +
      frBin +
      '&strLotNum=' +
      lotNo +
      '&strReason=' +
      reason +
      '&strReference=' +
      refNo +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&iLabelCount=' +
      noofLabel;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/IssueMtl/PerformIssueMiscMaterial' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postReturnMiscMaterial(
    String partNo,
    String ium,
    String tranQty,
    String frWhse,
    String frBin,
    String toWhse,
    String toBin,
    String lotNo,
    String reason,
    String refNo,
    String noofLabel) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strPartNum=' +
      partNo +
      '&strIUM=' +
      ium +
      '&dTranQty=' +
      tranQty +
      '&strWarehouseCode=' +
      frWhse +
      '&strBinNum=' +
      frBin +
      '&strLotNum=' +
      lotNo +
      '&strReason=' +
      reason +
      '&strReference=' +
      refNo +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&iLabelCount=' +
      noofLabel;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl +
        '/api/IssueMtl/PerformReturnMiscMaterial' +
        _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postIssueAssembly(
    String jobNo,
    String asmNo,
    String partNo,
    String ium,
    String tranQty,
    String frWhse,
    String frBin,
    String toWhse,
    String toBin,
    String lotNo,
    String refNo,
    String noofLabel) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strJobNum=' +
      jobNo +
      '&iAssemblySeq=' +
      asmNo +
      '&strPartNum=' +
      partNo +
      '&strIUM=' +
      ium +
      '&dTranQty=' +
      tranQty +
      '&strFromWarehouseCode=' +
      frWhse +
      '&strFromBinNum=' +
      frBin +
      '&strToWarehouseCode=' +
      toWhse +
      '&strToBinNum=' +
      toBin +
      '&strLotNum=' +
      lotNo +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&iLabelCount=' +
      noofLabel +
      '&strReference=' +
      refNo;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/IssueMtl/PerformIssueAssembly' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postReturnAssembly(
    String jobNo,
    String asmNo,
    String partNo,
    String ium,
    String tranQty,
    String frWhse,
    String frBin,
    String toWhse,
    String toBin,
    String lotNo,
    String refNo,
    String noofLabel) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strJobNum=' +
      jobNo +
      '&iAssemblySeq=' +
      asmNo +
      '&strPartNum=' +
      partNo +
      '&strLotNum=' +
      lotNo +
      '&dTranQty=' +
      tranQty +
      '&strIUM=' +
      ium +
      '&strFromWarehouseCode=' +
      frWhse +
      '&strFromBinNum=' +
      frBin +
      '&strToWarehouseCode=' +
      toWhse +
      '&strToBinNum=' +
      toBin +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&iLabelCount=' +
      noofLabel +
      '&strReference=' +
      refNo;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl +
        '/api/JobToInventory/PerformAssemblyToInventory' +
        _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postMoveInventory(
    String partNo,
    String ium,
    String tranQty,
    String frWhse,
    String frBin,
    String frLotNo,
    String toWhse,
    String toBin,
    String toLotNo,
    String refNo,
    String noofLabel) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strPartNum=' +
      partNo +
      '&strIUM=' +
      ium +
      '&dTranQty=' +
      tranQty +
      '&strFromWarehouseCode=' +
      frWhse +
      '&strFromBinNum=' +
      frBin +
      '&strFromLotNum=' +
      frLotNo +
      '&strToWarehouseCode=' +
      toWhse +
      '&strToBinNum=' +
      toBin +
      '&strToLotNum=' +
      toLotNo +
      '&strReference=' +
      refNo +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&iLabelCount=' +
      noofLabel;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl +
        '/api/moveinventory/PerformMoveInventory' +
        _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postJobtoInventory(
    String jobNo,
    String asmNo,
    String partNo,
    String ium,
    String tranQty,
    String frWhse,
    String frBin,
    String toWhse,
    String toBin,
    String lotNo,
    String refNo,
    String noofLabel) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strJobNum=' +
      jobNo +
      '&iAssemblySeq=' +
      asmNo +
      '&strPartNum=' +
      partNo +
      '&strLotNum=' +
      lotNo +
      '&dTranQty=' +
      tranQty +
      '&strIUM=' +
      ium +
      '&strFromWarehouseCode=' +
      frWhse +
      '&strFromBinNum=' +
      frBin +
      '&strToWarehouseCode=' +
      toWhse +
      '&strToBinNum=' +
      toBin +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&iLabelCount=' +
      noofLabel +
      '&strReference=' +
      refNo;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl +
        '/api/jobtoinventory/PerformReceiptsToInventory' +
        _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );
  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postJobtoSalvage(
    String jobNo,
    String partNo,
    String ium,
    String asmSeq,
    String mtlSeq,
    String tranQty,
    String toWhse,
    String toBin,
    String lotNo,
    String refNo,
    String noofLabel) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strJobNum=' +
      jobNo +
/*       '&iAssemblySeq=' +
      asmSeq +
      '&iMaterialSeq=' +
      mtlSeq + */
      '&strPartNum=' +
      partNo +
      '&dTranQty=' +
      tranQty +
      '&strIUM=' +
      ium +
      '&strReference=' +
      refNo +
      '&strLotNum=' +
      lotNo +
      '&strToWarehouseCode=' +
      toWhse +
      '&strToBinNum=' +
      toBin +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&iLabelCount=' +
      noofLabel;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/Salvage/PerformReceiptsToSalvage' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );
  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postMoveInventoryRequest(
    String partNo,
    String ium,
    String tranQty,
    String frWhse,
    String frBin,
    String frLotNo,
    String toWhse,
    String toBin,
    String toLotNo,
    String refNo,
    String noofLabel) async {
  bool result = false;

  String _params = '?strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strPartNum=' +
      partNo +
      '&strIUM=' +
      ium +
      '&dTranQty=' +
      tranQty +
      '&strFromWarehouseCode=' +
      frWhse +
      '&strFromBinNum=' +
      frBin +
      '&strFromLotNum=' +
      frLotNo +
      '&strToWarehouseCode=' +
      toWhse +
      '&strToBinNum=' +
      toBin +
      '&strToLotNum=' +
      toLotNo +
      '&strReference=' +
      refNo +
      '&strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&iLabelCount=' +
      noofLabel +
      '&strCurPlant=' +
      _globals.epiSiteId;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl +
        '/api/moveinventory/PerformMoveInventoryRequest' +
        _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postCreateLot(
    String partNo,
    String lotNo,
    String lotDesc,
    String batch,
    String mfgBatch,
    String mfgLot,
    String heatNum,
    String firmWare,
    String bestBeforeDt,
    String mfgDt,
    String cureDt,
    String expireDt,
    String noofLabel) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strPartNum=' +
      partNo +
      '&strLotNum=' +
      lotNo +
      '&strLotDesc=' +
      lotDesc +
      '&strBatch=' +
      batch +
      '&strMfgBatch=' +
      mfgBatch +
      '&strMfgLot=' +
      mfgLot +
      '&strHeatNum=' +
      heatNum +
      '&strFirmWare=' +
      firmWare +
      '&dtBestBeforeDt=' +
      bestBeforeDt +
      '&dtMfgDt=' +
      mfgDt +
      '&dtCureDt=' +
      cureDt +
      '&dtExpireDt=' +
      expireDt +
      '&iLabelCount=' +
      noofLabel;

  // if (lotDesc != '') {
  //   _params = _params + '&strLotDesc=' + lotDesc;
  // }
  // if (batch != '') {
  //   _params = _params + '&strBatch=' + batch;
  // }
  // if (mfgBatch != '') {
  //   _params = _params + '&strMfgBatch=' + mfgBatch;
  // }
  // if (mfgLot != '') {
  //   _params = _params + '&strMfgLot=' + mfgLot;
  // }
  // if (heatNum != '') {
  //   _params = _params + '&strHeatNum=' + heatNum;
  // }
  // if (firmWare != '') {
  //   _params = _params + '&strFirmWare=' + firmWare;
  // }
  // if (bestBeforeDt != '') {
  //   _params = _params + '&dtBestBeforeDt=' + bestBeforeDt;
  // }
  // if (mfgDt != '') {
  //   _params = _params + '&dtMfgDt=' + mfgDt;
  // }
  // if (cureDt != '') {
  //   _params = _params + '&dtCureDt=' + cureDt;
  // }
  // if (expireDt != '') {
  //   _params = _params + '&dtExpireDt=' + expireDt;
  // }
  // if (noofLabel != '') {
  //   _params = _params + '&iLabelCount=' + noofLabel;
  // }

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/part/PerformPartLotUpdate' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );
  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postNewLot(String partNo) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&strPartNum=' +
      partNo;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/receipt/PerformNewLot' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );
  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postMoveInventoryRequestApproval(
    String reqNo, String reqStatus, String trxQty, String noofLabel) async {
  bool result = false;

  String _params = '?strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strReqNum=' +
      reqNo +
      '&iReqStatus=' +
      reqStatus +
      '&strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&dTranQty=' +
      trxQty +
      '&iLabelCount=' +
      noofLabel;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl +
        '/api/MoveInventory/PerformMoveInventoryRequestApproval' +
        _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postNewPOReceiptDtl(
    String poNum,
    String poLine,
    String poLineRel,
    String packSlip,
    String vendorNum,
    String partNo,
    String whse,
    String bin,
    String lotNum,
    String tranQty,
    String ium,
    String driverName,
    String driverIC,
    String lorry,
    String noofLabel) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&iVendNum=' +
      vendorNum +
      '&strPackSlip=' +
      packSlip +
      '&iPONum=' +
      poNum +
      '&iPOLine=' +
      poLine +
      '&iPORel=' +
      poLineRel +
      '&strPartNum=' +
      partNo +
      '&strWarehouseCode=' +
      whse +
      '&strBinNum=' +
      bin +
      '&strLotNum=' +
      lotNum +
      '&dTranQty=' +
      tranQty +
      '&strUOM=' +
      ium +
      '&strDriverName=' +
      driverName +
      '&strDriverIC=' +
      driverIC +
      '&strLorry=' +
      lorry +
      '&iLabelCount=' +
      noofLabel;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/Receipt/PerformNewReceiptDetail' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postNewPOReceiptHead(
    String poNum, String packSlip, String vendorId) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&iPONum=' +
      poNum +
      '&strPackSlip=' +
      packSlip +
      '&strVendId=' +
      vendorId;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/Receipt/PerformNewReceiptHead' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postPerformReceiveTimeStamp(String legalNumber) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strLegalNumber=' +
      legalNumber;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl +
        '/api/DeliveryTracking/PerformReceiveTimeStamp' +
        _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postRePrintLabel(
    String sysDate,
    String tranNo,
    String partNo,
    String tranType,
    String tranQty,
    String ium,
    String lotNo,
    String jobNo,
    String assemblySeq,
    String noofLabel) async {
  bool result = false;

  String _transNo = tranNo == '' ? '0' : tranNo;
  String _sysDate =
      sysDate == '' ? DateFormat('yyyy-MM-dd').format(DateTime.now()) : sysDate;
  String _assmNo = assemblySeq == '' ? '0' : assemblySeq;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&SysDate=' +
      _sysDate +
      '&TranNum=' +
      _transNo +
      '&strPartNum=' +
      partNo +
      '&TranType=' +
      tranType +
      '&dtranQty=' +
      tranQty +
      '&strIUM=' +
      ium +
      '&strLotNum=' +
      lotNo +
      '&strJobNum=' +
      jobNo +
      '&iAssemblySeq=' +
      _assmNo +
      '&iLabelCount=' +
      noofLabel;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/Reprint/PerformReprint' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postQtyAdjustment(
    String partNo,
    String ium,
    String tranQty,
    String whse,
    String bin,
    String lotNo,
    String reason,
    String refNo,
    String noofLabel) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strPartNum=' +
      partNo +
      '&strIUM=' +
      ium +
      '&dTranQty=' +
      tranQty +
      '&strWarehouseCode=' +
      whse +
      '&strBinNum=' +
      bin +
      '&strLotNum=' +
      lotNo +
      '&strReason=' +
      reason +
      '&strReference=' +
      refNo +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&iLabelCount=' +
      noofLabel;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/IssueMtl/PerformQtyAdjustment' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postSplitMergeUOM(
    String proccode,
    String partnum,
    String whsecode,
    String binnum,
    String lotnum,
    String qty,
    String ium,
    String noofLabel,
    EpiSplitMergeUOMList epilist) async {
  bool result = false;

  List<Map<String, dynamic>> _arrayJson =
      List<Map<String, dynamic>>.empty(growable: true);
  var _count = epilist.episplitmergeuomlist.length;

  for (var i = 0; i < _count; i++) {
    var _rowData = epilist.episplitmergeuomlist[i];
    _arrayJson.add(_rowData.toJson());
    //print("Qty : " + _rowData.qty.toString() + ", UOM : " + _rowData.ium);
  }

  String _params = '?strUid=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strProc=' +
      proccode +
      '&strPartNum=' +
      partnum +
      '&strWarehouseCode=' +
      whsecode +
      '&strBinNum=' +
      binnum +
      '&strLotNum=' +
      lotnum +
      '&dQty=' +
      qty +
      '&strUOM=' +
      ium +
      '&strSplitArray=' +
      Uri.encodeComponent(jsonEncode(_arrayJson)) +
      '&iLabelCount=' +
      noofLabel;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/SplitMergeUOM/PostSplitMergeList' + _params,
    //'http://sds.privatedns.org:8088/api/SplitMergeUOM/PostSplitMergeList?strUid=epicor&strPass=epicor&strCurCompany=EPIC06&strCurPlant=MfgSys&strEnvId=Epic01&strProc=S&strPartNum=split&strWarehouseCode=chi&strBinNum=00-00-00&strLotNum=&dQty=12&strUOM=EA&strSplitArray=[{"RowNo":0,"Company":"EPIC06","PartNum":"SPLIT","WarehouseCode":"CHI","BinNum":"00-00-00","LotNum":"","OnHandQty":0.0,"Qty":0.0,"UOM":"BX","ConvFact":24.0,"ConvFactUOM":"EA","AllocatedQty":0.0},{"RowNo":1,"Company":"EPIC06","PartNum":"SPLIT","WarehouseCode":"CHI","BinNum":"00-00-00","LotNum":"","OnHandQty":0.0,"Qty":0.0,"UOM":"CS","ConvFact":48.0,"ConvFactUOM":"EA","AllocatedQty":0.0},{"RowNo":2,"Company":"EPIC06","PartNum":"SPLIT","WarehouseCode":"CHI","BinNum":"00-00-00","LotNum":"","OnHandQty":0.0,"Qty":0.0,"UOM":"DP","ConvFact":24.0,"ConvFactUOM":"EA","AllocatedQty":0.0},{"RowNo":3,"Company":"EPIC06","PartNum":"SPLIT","WarehouseCode":"CHI","BinNum":"00-00-00","LotNum":"","OnHandQty":1.00000000,"Qty":1.0,"UOM":"DZ","ConvFact":12.0,"ConvFactUOM":"EA","AllocatedQty":0.0},{"RowNo":4,"Company":"EPIC06","PartNum":"SPLIT","WarehouseCode":"CHI","BinNum":"00-00-00","LotNum":"","OnHandQty":0.0,"Qty":0.0,"UOM":"GS","ConvFact":144.0,"ConvFactUOM":"EA","AllocatedQty":0.0}]&iLabelCount=0',
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postProdClockIn(String empId, String ishift) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strEmpId=' +
      empId +
      '&iShift=' +
      ishift;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl +
        '/api/Productions/PerformEmployeeClockIn' +
        _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postProdClockOut(String empId) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strEmpId=' +
      empId;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl +
        '/api/Productions/PerformEmployeeClockOut' +
        _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postProdStartOperation(String empId, String jobNo,
    String asmNo, String oprNo, String resId, String empLaborHedSeq) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strEmpId=' +
      empId +
      '&strJobNum=' +
      jobNo +
      '&iAssemblySeq=' +
      asmNo +
      '&iOperation=' +
      oprNo +
      '&strResourceId=' +
      resId +
      '&iLaborHedSeq=' +
      empLaborHedSeq +
      '&strCurPlant=' +
      _globals.epiSiteId;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl +
        '/api/Productions/PerformEmployeeStartActivity' +
        _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postProdEndOperationByBatch(String empId, String jobNo,
    String asmNo, String oprNo, String resId, String transQty) async {
  bool result = false;

  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strEmpId=' +
      empId +
      '&strJobNum=' +
      jobNo +
      '&iAssemblySeq=' +
      asmNo +
      '&iOperation=' +
      oprNo +
      '&strResourceId=' +
      resId +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&dTranQty=' +
      transQty;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl +
        '/api/Productions/PerformEndActivitiesByJobOperation' +
        _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}

Future<List<dynamic>> postProdEndOperationByEmp(
  String laborHedSeq,
  String laborDtlSeq,
  String? transQty, {
  String? nonConQty,
  String? reason,
}) async {
  bool result = false;

  final String finalTransQty =
      (transQty == null || transQty.isEmpty) ? '0' : transQty;

  final Map<String, String> params = {
    'strUID': _globals.epiUsername,
    'strPass': Uri.encodeComponent(_globals.epiPassword),
    'strEnvId': _globals.epiEnvId,
    'strCurCompany': _globals.epiCompanyId,
    'iLaborHedSeq': laborHedSeq,
    'iLaborDtlSeq': laborDtlSeq,
    'strCurPlant': _globals.epiSiteId,
    'dTranQty': finalTransQty, // always send, default 0
  };

  if (nonConQty != null && nonConQty.isNotEmpty) {
    params['discQty'] = nonConQty;
    if (nonConQty != '0' && reason != null && reason.isNotEmpty) {
      params['discReason'] = reason;
    }
  }

  final Uri uri = Uri.parse(
    _globals.epiApiBaseUrl + '/api/Productions/PerformEmployeeEndActivity',
  ).replace(queryParameters: params);

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    uri.toString(),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.post,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.body];
}
