import 'dart:io';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter_epihhinventory/data/classes/user.dart';
import 'package:flutter_epihhinventory/data/web_client.dart';
// import 'package:global_configuration/global_configuration.dart';
import '../utils/globals.dart' as _globals;

Future<List<dynamic>> isJobExist(String jobNo) async {
  bool result = false;

  String _params = '?strUid=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&strJobNum=' +
      jobNo;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/job/LoadJobHeadById' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.get,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.reasonPhrase];
}

Future<List<dynamic>> isJobAsmExist(String jobNo, String asmNo) async {
  bool result = false;

  String _params = '?strUid=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&strJobNum=' +
      jobNo +
      '&iAssemblySeq=' +
      asmNo;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/job/LoadJobAssemblyByAssmbSeq' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.get,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.reasonPhrase];
}

Future<List<dynamic>> isJobMtlExist(
    String jobNo, String asmNo, String mtlNo) async {
  bool result = false;

  String _params = '?strUid=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&strJobNum=' +
      jobNo +
      '&iAssemblySeq=' +
      asmNo +
      '&iMtlSeq=' +
      mtlNo;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/job/LoadJobMaterialByMtlSeq' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.get,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.reasonPhrase];
}

Future<List<dynamic>> isMtlPartExist(String partNo) async {
  bool result = false;

  String _params = '?strUid=' +
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
    _globals.epiApiBaseUrl + '/api/issuemtl/LoadPart' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.get,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.reasonPhrase];
}

Future<List<dynamic>> isPartLotExist(String partNo, String lotNo) async {
  bool result = false;

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
      '&strPartNum=' +
      partNo +
      '&strLotNum=' +
      lotNo;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/part/LoadPartLot' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.get,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.reasonPhrase];
}

Future<List<dynamic>> isPartWhseExist(String partNo, String whseCode) async {
  bool result = false;

  String _params = '?strUid=' +
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
      partNo +
      '&strWhse=' +
      whseCode;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/part/LoadPartWhseById' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.get,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.reasonPhrase];
}

Future<List<dynamic>> isPartWhseBinExist(
    String partNo, String whseCode, String binNo) async {
  bool result = false;

  String _params = '?strUid=' +
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
      partNo +
      '&strWhse=' +
      whseCode +
      '&strBinNum=' +
      binNo;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/part/LoadPartWhseBinById' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.get,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.reasonPhrase];
}

Future<List<dynamic>> isPOReceiptHeaderExist(
    String poNum, String packSlip) async {
  bool result = false;

  String _params = '?strUid=' +
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
      packSlip;

  http.Response response = await WebClient(User(token: '')).getHttpReponse(
    _globals.epiApiBaseUrl + '/api/Receipt/LoadReceiptByPackSlip' + _params,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer ",
    },
    method: HttpMethod.get,
  );

  if (response.statusCode == 200) {
    result = true;
  }

  return [result, response.reasonPhrase];
}
