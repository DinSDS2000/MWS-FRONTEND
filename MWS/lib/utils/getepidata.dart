import 'package:flutter_epihhinventory/data/classes/epidocustinfo.dart';
import 'package:flutter_epihhinventory/data/classes/epiemployee.dart';
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
import 'package:flutter_epihhinventory/data/classes/epishipdtl.dart';
import 'package:flutter_epihhinventory/data/classes/episplitmergeuom.dart';
import 'package:flutter_epihhinventory/data/classes/epitrxinfo.dart';
import 'package:flutter_epihhinventory/data/classes/epiuom.dart';
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
  DateTime? date,
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

  if (date != null) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    params += '&date=' + Uri.encodeComponent(formattedDate);
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
