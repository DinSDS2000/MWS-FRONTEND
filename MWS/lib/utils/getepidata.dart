import 'dart:convert';

import 'package:flutter_epihhinventory/data/classes/epidocustinfo.dart';
import 'package:flutter_epihhinventory/data/classes/epiemployee.dart';
import 'package:flutter_epihhinventory/data/classes/epigetlot.dart';
import 'package:flutter_epihhinventory/data/classes/epijobasm.dart';
import 'package:flutter_epihhinventory/data/classes/epijobhead.dart';
import 'package:flutter_epihhinventory/data/classes/epijobmtl.dart';
import 'package:flutter_epihhinventory/data/classes/epijoboprresource.dart';
import 'package:flutter_epihhinventory/data/classes/epijobtosalvage.dart';
import 'package:flutter_epihhinventory/data/classes/epimoveinvreq.dart';
import 'package:flutter_epihhinventory/data/classes/epipart.dart';
import 'package:flutter_epihhinventory/data/classes/epipartwhse.dart';
import 'package:flutter_epihhinventory/data/classes/epipartwhsebin.dart';
import 'package:flutter_epihhinventory/data/classes/epipickerbaq.dart';
import 'package:flutter_epihhinventory/data/classes/epiporeceipt.dart';
import 'package:flutter_epihhinventory/data/classes/epiporeceiptdtl.dart';
import 'package:flutter_epihhinventory/data/classes/epireason.dart';
import 'package:flutter_epihhinventory/data/classes/epireprint.dart';
import 'package:flutter_epihhinventory/data/classes/epishipdtl.dart';
import 'package:flutter_epihhinventory/data/classes/episplitmergeuom.dart';
import 'package:flutter_epihhinventory/data/classes/epitrxinfo.dart';
import 'package:flutter_epihhinventory/data/classes/epiuom.dart';
import 'package:flutter_epihhinventory/data/classes/epiusercodes.dart';
import 'package:flutter_epihhinventory/data/classes/epivendorlist.dart';
import 'package:flutter_epihhinventory/data/classes/epiworkqueue.dart';
import 'package:flutter_epihhinventory/data/classes/user.dart';
import 'package:flutter_epihhinventory/data/web_client.dart';
import 'package:intl/intl.dart';
// import 'package:global_configuration/global_configuration.dart';

import '../utils/globals.dart' as _globals;

Future<List<dynamic>> getEpiJobHead(String jobNo) async {
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

  var _data = await WebClient(User(token: ''))
      .get(_globals.epiApiBaseUrl + '/api/job/LoadJobHeadById' + _params);

  if (_data[0] == null) {
    return [true, _data['Message']];
  } else {
    EpiJobHead _envData = EpiJobHead.fromJson(_data);

    return [false, _envData];
  }
}

Future<EpiJobMtl> getEpiJobMtl(String jobNo, String asmNo, String mtlNo) async {
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

  var _data = await WebClient(User(token: '')).get(
      _globals.epiApiBaseUrl + '/api/job/LoadJobMaterialByMtlSeq' + _params);

  EpiJobMtl _envData = EpiJobMtl.fromJson(_data);

  return _envData;
}

Future<EpiJobOprResource> getEpiJobOprResourceById(
    String jobNo, String asmNo, String oprNo, String resId) async {
  String _params = '?strUid=' +
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
      '&iOperation=' +
      oprNo +
      '&StrResourceId=' +
      resId;

  var _data = await WebClient(User(token: '')).get(_globals.epiApiBaseUrl +
      '/api/Productions/LoadJobOperationResourceById' +
      _params);

  EpiJobOprResource _envData = EpiJobOprResource.fromJson(_data);

  return _envData;
}

Future<EpiJobAsm> getEpiJobAsm(String jobNo, String asmNo) async {
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
      '&strJobNum=' +
      jobNo +
      '&iAssemblySeq=' +
      asmNo;

  var _data = await WebClient(User(token: '')).get(
      _globals.epiApiBaseUrl + '/api/Job/LoadJobAssemblyByAssmbSeq' + _params);

  EpiJobAsm _envData = EpiJobAsm.fromJson(_data);

  return _envData;
}

Future<List<dynamic>> getEpiMovInvPart(String partNo) async {
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
      Uri.encodeComponent(partNo);

  var _data = await WebClient(User(token: ''))
      .get(_globals.epiApiBaseUrl + '/api/moveinventory/LoadPart' + _params);

  if (_data['Parts'] == null) {
    return [true, _data['Message']];
  } else {
    EpiPart _envData = EpiPart.fromJson(_data['Parts']);
    return [false, _envData];
  }
}

Future<List<dynamic>> getReprintInfo(
  String? partNum,
  String? lotNum,
  String? toSeqNo,
  String? fromSeqNo,
  String? batchNum,
) async {
  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&strEnvId=' +
      _globals.epiEnvId;

  if (partNum != null && partNum.isNotEmpty) {
    _params += '&partNum=' + Uri.encodeComponent(partNum);
  }
  if (lotNum != null && lotNum.isNotEmpty) {
    _params += '&lotNum=' + Uri.encodeComponent(lotNum);
  }
  if (toSeqNo != null && toSeqNo.isNotEmpty) {
    _params += '&toSeqNo=' + Uri.encodeComponent(toSeqNo);
  }
  if (fromSeqNo != null && fromSeqNo.isNotEmpty) {
    _params += '&fromSeqNo=' + Uri.encodeComponent(fromSeqNo);
  }
  if (batchNum != null && batchNum.isNotEmpty) {
    _params += '&batchNum=' + Uri.encodeComponent(batchNum);
  }

  // 1. Call your custom WebClient matching your routing endpoint path
  // NOTE: Changed route folder to '/api/receipt/GetReprintInfo' based on your previous C# steps
  var _data = await WebClient(User(token: ''))
      .get(_globals.epiApiBaseUrl + '/api/Reprint/GetReprintInfo' + _params);

  // 2. Mirror your pattern: check if data is null or empty
  if (_data['value'] == null) {
    return [
      true,
      _data['Errors'] != null ? _data['Errors'][0] : 'No data found.'
    ];
  } else {
    // 3. Pass the array directly to your list model's fromJson method
    EpiReprintInfoList _envData = EpiReprintInfoList.fromJson(_data['value']);

    // 4. Return [false, data] to signal a successful fetch (mirroring your array return pattern)
    return [false, _envData];
  }
}

Future<EpiTrxInfo> getEpiTrxInfo(String trxNo) async {
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
      '&TranNo=' +
      trxNo;

  var _data = await WebClient(User(token: ''))
      .get(_globals.epiApiBaseUrl + '/api/Reprint/LoadTranInfo' + _params);

  EpiTrxInfo _result = EpiTrxInfo.fromJson(_data);

  return _result;
}

Future<List<dynamic>> getEpiPartWhse(String partNo, String whseCode) async {
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
      '&strWhse=' +
      whseCode;

  var _data = await WebClient(User(token: '')).get(_globals.epiApiBaseUrl +
      '/api/moveinventory/LoadPartWhseWithBin' +
      _params);

  if (_data['PartWhse'] == null) {
    return [true, _data['Message']];
  } else {
    EpiPartWhse _envData = EpiPartWhse.fromJson(_data['PartWhse']);
    EpiPartWhseBinList _envDataList =
        EpiPartWhseBinList.fromJson(_data['WhseBinList']);

    _envData.whsebinlist = _envDataList.epipartwhsebinlist;

    return [false, _envData];
  }
}

Future<List<dynamic>> getEpiJobToSalvage(String jobNo) async {
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

  var _data = await WebClient(User(token: '')).get(
      _globals.epiApiBaseUrl + '/api/salvage/LoadJobForSalvageById' + _params);

  if (_data[0] == null) {
    return [true, _data['Message']];
  } else {
    EpiJobToSalvage _envData = EpiJobToSalvage.fromJson(_data);

    return [false, _envData];
  }
}

Future<EpiPart> getEpiPart(String partNo) async {
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
      '&strPartNum=' +
      Uri.encodeComponent(partNo);

  var _data = await WebClient(User(token: ''))
      .get(_globals.epiApiBaseUrl + '/api/MoveInventory/LoadPart' + _params);
  print("PARTTTT: ${_data}");
  if (_data['Parts'] == null) {
    throw Exception(_data);
  } else {
    EpiPart _envData = EpiPart.fromJson(_data['Parts']);
    return _envData;
  }
}

Future<List<dynamic>> getEpiMoveInvReqList(String toWhse, String toBin) async {
  String _params = '?strUid=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&iReqStatus=0' +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strToWarehouse=' +
      toWhse +
      '&strToBin=' +
      toBin;

  var _data = await WebClient(User(token: '')).get(_globals.epiApiBaseUrl +
      '/api/moveinventory/LoadMoveInventoryRequest' +
      _params);

  if (_data[0] == null) {
    return [true, _data['Message']];
  } else {
    EpiMoveInvReqList _envData = EpiMoveInvReqList.fromJson(_data);

    return [false, _envData];
  }
}

Future<List<dynamic>> getEpiPickerList({
  String? picker,
  String? orderNum,
  String? transporter,
  DateTime? fromRelDate,
  DateTime? toRelDate,
  DateTime? fromOrderDate,
  DateTime? toOrderDate,
  String? fromLegalNum,
  String? toLegalNum,
}) async {
  // Base params (required)
  String params = '?strUid=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strCurPlant=' +
      _globals.epiSiteId;

  // Append optional filters if provided
  if (picker != null && picker.isNotEmpty) {
    params += '&picker=' + Uri.encodeComponent(picker);
  }
  if (orderNum != null && orderNum.isNotEmpty) {
    params += '&orderNum=' + Uri.encodeComponent(orderNum);
  }
  if (transporter != null && transporter.isNotEmpty) {
    params += '&transporter=' + Uri.encodeComponent(transporter);
  }

  if (fromRelDate != null) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(fromRelDate);
    params += '&fromRelDate=' + Uri.encodeComponent(formattedDate);
  }
  if (toRelDate != null) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(toRelDate);
    params += '&toRelDate=' + Uri.encodeComponent(formattedDate);
  }
  if (fromOrderDate != null) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(fromOrderDate);
    params += '&fromOrderDate=' + Uri.encodeComponent(formattedDate);
  }
  if (toOrderDate != null) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(toOrderDate);
    params += '&toOrderDate=' + Uri.encodeComponent(formattedDate);
  }
  if (fromLegalNum != null && fromLegalNum.isNotEmpty) {
    params += '&fromLegalNum=' + Uri.encodeComponent(fromLegalNum);
  }
  if (toLegalNum != null && toLegalNum.isNotEmpty) {
    params += '&toLegalNum=' + Uri.encodeComponent(toLegalNum);
  }
  var _data = await WebClient(User(token: '')).get(_globals.epiApiBaseUrl +
      '/api/DeliveryTracking/LoadPickerDelivery' +
      params);

  if (_data == null) {
    return [true, 'Picker BAQ no result'];
  } else {
    EpiPickerBaqList _envData = EpiPickerBaqList.fromJson(_data);

    return [false, _envData];
  }
}

Future<List<Transporter>> getTransporters() async {
  final String params =
      '?strUid=${_globals.epiUsername}&strPass=${Uri.encodeComponent(_globals.epiPassword)}'
      '&strEnvId=${_globals.epiEnvId}&strCurCompany=${_globals.epiCompanyId}&strCurPlant=${_globals.epiSiteId}';

  var response = await WebClient(User(token: '')).get(
      '${_globals.epiApiBaseUrl}/api/DeliveryTracking/GetTransporterList$params');

  if (response == null || response['success'] != true) {
    throw Exception('Failed to load transporters');
  }

  List<dynamic> data = response['value'];
  return data.map((json) => Transporter.fromJson(json)).toList();
}

Future<List<dynamic>> getShipmentDetails({
  String? lorryID,
  String? planID,
  String? doNum,
}) async {
  // Build base query string
  String params = '?username=' +
      _globals.epiUsername +
      '&password=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&company=' +
      _globals.epiCompanyId +
      '&plant=' +
      _globals.epiSiteId +
      '&envID=' +
      _globals.epiEnvId;

  // Add optional filters
  if (lorryID != null && lorryID.isNotEmpty) {
    params += '&lorryID=' + Uri.encodeComponent(lorryID);
  }
  if (planID != null && planID.isNotEmpty) {
    params += '&planID=' + Uri.encodeComponent(planID);
  }
  if (doNum != null && doNum.isNotEmpty) {
    params += '&donum=' + Uri.encodeComponent(doNum);
  }

  // Call API
  var _data = await WebClient(User(token: '')).get(
    _globals.epiApiBaseUrl + '/api/CustShip/ShipmentDetail' + params,
  );

  // Handle response
  if (_data == null || _data['value'] == null) {
    return [true, 'Shipment detail BAQ no result'];
  } else {
    EpiShipDtlList shipmentList = EpiShipDtlList.fromJson(_data);
    return [false, shipmentList];
  }
}

Future<List<dynamic>> getEpiPOReceiptDtlList(
    String? ponum, String? legalNum, String? vendorId) async {
  Map<String, String> queryParams = {
    'strUid': _globals.epiUsername,
    'strPass': _globals.epiPassword,
    'strEnvId': _globals.epiEnvId,
    'strCurCompany': _globals.epiCompanyId,
    'strCurPlant': _globals.epiSiteId,
  };

  if (ponum != null && ponum.isNotEmpty) {
    queryParams['iPONum'] = ponum;
  }
  if (legalNum != null && legalNum.isNotEmpty) {
    queryParams['strLegalNumber'] = legalNum;
  }
  if (vendorId != null && vendorId.isNotEmpty) {
    queryParams['vendorId'] = vendorId;
  }

  // Build the full query string
  String queryString = '?' +
      queryParams.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');

  var _data = await WebClient(User(token: '')).get(_globals.epiApiBaseUrl +
      '/api/Receipt/LoadReceiptsDetailsByPONum' +
      queryString);

  if (_data[0] == null) {
    return [true, 'PO Receipts not found'];
  } else {
    EpiPOReceiptDtlList _envData = EpiPOReceiptDtlList.fromJson(_data);
    return [false, _envData];
  }
}

Future<List<dynamic>> getEpiPOReceiptList(String ponum, String legalnum) async {
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
      ponum +
      '&strLegalNumber=' +
      legalnum;

  var _data = await WebClient(User(token: '')).get(_globals.epiApiBaseUrl +
      '/api/Receipt/LoadPurchaseOrdersByLegalId' +
      _params);

  if (_data[0] == null) {
    return [true, 'PO Receipts not found'];
  } else {
    EpiPOReceiptList _envData = EpiPOReceiptList.fromJson(_data);

    return [false, _envData];
  }
}

Future<String> getPORelTranType(int poNum, int poLine, int poRel) async {
  // Build query parameters
  String params = '?strUid=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strCurPlant=' +
      _globals.epiSiteId +
      '&PONum=' +
      poNum.toString() +
      '&POLine=' +
      poLine.toString() +
      '&PORel=' +
      poRel.toString();

  // Call your backend
  var response = await WebClient(User(token: ''))
      .get(_globals.epiApiBaseUrl + '/api/Receipt/GetPORelTranType' + params);

  String tranType = '';

  if (response != null) {
    tranType = response.toString();
  }

  return tranType;
}

Future<List<UOM>> getEpiUOMList(String partno, List<UOM> _uoms) async {
  _uoms.removeWhere((item) => item.id != '0');

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
      partno;

  var _data = await WebClient(User(token: ''))
      .get(_globals.epiApiBaseUrl + '/api/part/LoadUOMByPart' + _params);

  if (_data[0] != null) {
    EpiUOMList _envData = EpiUOMList.fromJson(_data);

    for (var i = 0; i < _envData.epiuomlist.length; i++) {
      UOM _epidata = new UOM(
          _envData.epiuomlist[i].uomcode, _envData.epiuomlist[i].uomcode);
      _uoms.add(_epidata);
    }
  }

  return _uoms;
}

class Transporter {
  final String id;
  final String name;

  Transporter({required this.id, required this.name});

  factory Transporter.fromJson(Map<String, dynamic> json) {
    return Transporter(
      id: json['UDCodes_CodeID'] ?? '',
      name: json['UDCodes_CodeDesc'] ?? '',
    );
  }

  @override
  String toString() => name;
}

class UOM {
  const UOM(this.id, this.name);

  final String name;
  final String id;
}

Future<List<EpiReason>> getEpiReasonList2(String reasonType) async {
  String params = '?strUid=${_globals.epiUsername}'
      '&strPass=${Uri.encodeComponent(_globals.epiPassword)}'
      '&strEnvId=${_globals.epiEnvId}'
      '&strCurCompany=${_globals.epiCompanyId}'
      '&strReasonType=$reasonType';

  final data = await WebClient(User(token: '')).get(
      _globals.epiApiBaseUrl + '/api/Productions/LoadReasonCodes' + params);

  if (data == null || data.isEmpty) {
    return [];
  }

  return data.map<EpiReason>((json) => EpiReason.fromJson(json)).toList();
}

Future<List<ReasonItem>> getEpiReasonList(
    String _reasonType, List<ReasonItem> _reasonItems) async {
  _reasonItems.removeWhere((item) => item.id != '0');

  String _params = '?strUid=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strReasonType=' +
      _reasonType;

  var _data = await WebClient(User(token: '')).get(
      _globals.epiApiBaseUrl + '/api/Productions/LoadReasonCodes' + _params);

  if (_data[0] != null) {
    EpiReasonList _envData = EpiReasonList.fromJson(_data);

    for (var i = 0; i < _envData.epireasonlist.length; i++) {
      ReasonItem _epidata = new ReasonItem(_envData.epireasonlist[i].reasoncode,
          _envData.epireasonlist[i].reasoncode);
      _reasonItems.add(_epidata);
    }
  }

  return _reasonItems;
}

class ReasonItem {
  const ReasonItem(this.id, this.name);

  final String name;
  final String id;
}

Future<List<Employee>> getEpiEmployeeList(List<Employee> _emps) async {
  _emps.removeWhere((item) => item.id != '0');

  String _params = '?strUid=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strCurPlant=' +
      _globals.epiSiteId;

  var _data = await WebClient(User(token: '')).get(
      _globals.epiApiBaseUrl + '/api/Productions/LoadActiveEmployee' + _params);

  if (_data[0] != null) {
    EpiEmployeeList _envData = EpiEmployeeList.fromJson(_data);

    for (var i = 0; i < _envData.epiemployeelist.length; i++) {
      Employee _epidata = new Employee(
          _envData.epiemployeelist[i].empId,
          (_envData.epiemployeelist[i].empName ?? ''),
          _envData.epiemployeelist[i].empLaborHedSeq);
      _emps.add(_epidata);
    }
  }

  return _emps;
}

class Employee {
  const Employee(this.id, this.name, this.laborhedseq);

  final String name;
  final String id;
  final int laborhedseq;
}

Future<EpiDOCustInfo?> getEpiDOCustInfo(String legalNo) async {
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
      '&strLegalNumber=' +
      legalNo;

  var _data = await WebClient(User(token: '')).get(_globals.epiApiBaseUrl +
      '/api/DeliveryTracking/LoadDOCustInfo' +
      _params);

  if (_data == null) {
    return null;
  } else {
    EpiDOCustInfo _envData = EpiDOCustInfo.fromJson(_data);
    return _envData;
  }
}

Future<List<dynamic>> getEpiSplitMergeUOMList(
    String proccode,
    String partnum,
    String whsecode,
    String binnum,
    String lotnum,
    String qty,
    String ium) async {
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
      ium;

  var _data = await WebClient(User(token: '')).get(_globals.epiApiBaseUrl +
      '/api/SplitMergeUOM/GetSplitMergeList' +
      _params);

  if (_data[0] == null) {
    return [true, 'record not found'];
  } else {
    EpiSplitMergeUOMList _envData = EpiSplitMergeUOMList.fromJson(_data);

    return [false, _envData];
  }
}

Future<EpiEmployee> getEpiActiveEmployeeById(String empId) async {
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
      '&strEmpId=' +
      empId;

  var _data = await WebClient(User(token: '')).get(_globals.epiApiBaseUrl +
      '/api/Productions/LoadActiveEmployeeById' +
      _params);

  EpiEmployee _envData = EpiEmployee.fromJson(_data);

  return _envData;
}

Future<List<dynamic>> getEpiWorkGroupList(String empId, String jobNo,
    String asmNo, String oprNo, String resId) async {
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
      '&strEmpId=' +
      empId +
      '&strResourceGrp=' +
      '&strJobNum=' +
      jobNo +
      '&iassemblyseq=' +
      asmNo +
      '&ioperation=' +
      oprNo +
      '&strResourceId=' +
      resId;

  var _data = await WebClient(User(token: ''))
      .get(_globals.epiApiBaseUrl + '/api/Productions/LoadWorkQueue' + _params);

  if (_data[0] == null) {
    return [true, _data['Message']];
  } else {
    EpiWorkQueueList _envData = EpiWorkQueueList.fromJson(_data);

    return [false, _envData];
  }
}

Future<List<EpiVendor>> getVendorList() async {
  String _params = '?strUID=' +
      _globals.epiUsername +
      '&strPass=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&strEnvId=' +
      _globals.epiEnvId +
      '&strCurCompany=' +
      _globals.epiCompanyId +
      '&strCurPlant=' +
      _globals.epiSiteId;

  try {
    var _data = await WebClient(User(token: ''))
        .get(_globals.epiApiBaseUrl + '/api/Receipt/GetVendorList' + _params);

    // If your backend returns the raw JSON array wrapped inside a specific structure or directly as an array:
    if (_data == null) {
      return [];
    }

    EpiVendorList _envData = EpiVendorList.fromJson(_data);
    return _envData.epiVendorList; // Returns a clean List<EpiVendor>
  } catch (e) {
    print("Error fetching vendor list: $e");
    return []; // Return empty list on failure gracefully
  }
}

Future<UserCodesResponse> getUserCodes({
  required String codeTypeId,
}) async {
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
      '&CodeTypeId=' +
      codeTypeId;

  try {
    var _data = await WebClient(User(token: ''))
        .get(_globals.epiApiBaseUrl + '/api/Receipt/GetUserCodes' + _params);
    if (_data == null) {
      return UserCodesResponse(
        value: [],
        success: false,
        errors: ['User Code Not Found'],
      );
    }
    Map<String, dynamic> jsonMap;

    if (_data is String) {
      // If WebClient returns a raw string body, decode it first
      jsonMap = jsonDecode(_data);
    } else if (_data is Map<String, dynamic>) {
      // If WebClient already decodes JSON automatically inside its .get method
      jsonMap = _data;
    } else {
      throw Exception('Unexpected data format returned from server');
    }

    // Return the successfully mapped object
    return UserCodesResponse.fromJson(jsonMap);
  } catch (e) {
    // Return error state if something crashes during extraction or network request
    return UserCodesResponse(
      value: [],
      success: false,
      errors: ['Failed to extract codes: $e'],
    );
  }
}

Future<bool> checkHeaderExist({
  required String packSlip,
  required int vendorNum,
  required String purPoint,
}) async {
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
      '&strPackSlip=' +
      Uri.encodeComponent(packSlip) +
      '&vendorNum=' +
      vendorNum.toString() +
      '&purPoint=' +
      Uri.encodeComponent(purPoint);

  try {
    var _data = await WebClient(User(token: '')).get(
        _globals.epiApiBaseUrl + '/api/Receipt/CheckHeaderExist' + _params);

    // If data is null or execution fails, it dropped into the backend catch block
    if (_data == null) {
      return false;
    }

    if (_data is Map<String, dynamic>) {
      return _data['exists'] ?? false;
    }

    if (_data is String) {
      final Map<String, dynamic> parsedJson = jsonDecode(_data);
      return parsedJson['exists'] ?? false;
    }

    return false;
  } catch (e) {
    // If WebClient throws a 404/400 exception error, the header does not exist
    print('CheckHeaderExist Error: $e');
    return false;
  }
}

Future<List<EpiGetLot>> getLotList({
  required String partNum,
}) async {
  String _params = '?username=' +
      _globals.epiUsername +
      '&password=' +
      Uri.encodeComponent(_globals.epiPassword) +
      '&company=' +
      _globals.epiCompanyId +
      '&plant=' +
      _globals.epiSiteId +
      '&envId=' +
      _globals.epiEnvId +
      '&partNum=' +
      partNum;

  try {
    // 1. Fetch your dynamic map response payload structure
    var _data = await WebClient(User(token: ''))
        .get(_globals.epiApiBaseUrl + '/api/CustShip/GetLotList' + _params);

    if (_data == null) {
      return [];
    }

    // 2. FIX: Check if the response contains the 'value' array field property
    if (_data is Map<String, dynamic> && _data.containsKey('value')) {
      final List<dynamic> rawLotArray = _data['value'] ?? [];

      // Pass the inner array directly into your model constructor
      EpiGetLotList _envData = EpiGetLotList.fromJson(rawLotArray);
      return _envData.epigetliotlist;
    }

    print("Unexpected JSON response envelope format");
    return [];
  } catch (e) {
    print("Error fetching Lot list: $e");
    return [];
  }
}
