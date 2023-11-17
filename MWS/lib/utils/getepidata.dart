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
import 'package:flutter_epihhinventory/data/classes/epiporeceipt.dart';
import 'package:flutter_epihhinventory/data/classes/epiporeceiptdtl.dart';
import 'package:flutter_epihhinventory/data/classes/epireason.dart';
import 'package:flutter_epihhinventory/data/classes/episplitmergeuom.dart';
import 'package:flutter_epihhinventory/data/classes/epitrxinfo.dart';
import 'package:flutter_epihhinventory/data/classes/epiuom.dart';
import 'package:flutter_epihhinventory/data/classes/epiworkqueue.dart';
import 'package:flutter_epihhinventory/data/classes/user.dart';
import 'package:flutter_epihhinventory/data/web_client.dart';
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

  var _data = await WebClient(User(token: null))
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

  var _data = await WebClient(User(token: null)).get(
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

  var _data = await WebClient(User(token: null)).get(_globals.epiApiBaseUrl +
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

  var _data = await WebClient(User(token: null)).get(
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
      partNo;

  var _data = await WebClient(User(token: null))
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

  var _data = await WebClient(User(token: null))
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

  var _data = await WebClient(User(token: null)).get(_globals.epiApiBaseUrl +
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

  var _data = await WebClient(User(token: null)).get(
      _globals.epiApiBaseUrl + '/api/salvage/LoadJobForSalvageById' + _params);

  if (_data[0] == null) {
    return [true, _data['Message']];
  } else {
    EpiJobToSalvage _envData = EpiJobToSalvage.fromJson(_data);

    return [false, _envData];
  }
}

Future<EpiPart> getEpiPart(String partNo) async {
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
      partNo;

  var _data = await WebClient(User(token: null))
      .get(_globals.epiApiBaseUrl + '/api/moveinventory/LoadPart' + _params);

  if (_data['Parts'] == null) {
    return null;
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

  var _data = await WebClient(User(token: null)).get(_globals.epiApiBaseUrl +
      '/api/moveinventory/LoadMoveInventoryRequest' +
      _params);

  if (_data[0] == null) {
    return [true, _data['Message']];
  } else {
    EpiMoveInvReqList _envData = EpiMoveInvReqList.fromJson(_data);

    return [false, _envData];
  }
}

Future<List<dynamic>> getEpiPOReceiptDtlList(
    String ponum, String legalNum) async {
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
      '&strLegalNum=' +
      legalNum;

  var _data = await WebClient(User(token: null)).get(_globals.epiApiBaseUrl +
      '/api/Receipt/LoadReceiptsDetailsByPONum' +
      _params);

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

  var _data = await WebClient(User(token: null)).get(_globals.epiApiBaseUrl +
      '/api/Receipt/LoadPurchaseOrdersByLegalId' +
      _params);

  if (_data[0] == null) {
    return [true, 'PO Receipts not found'];
  } else {
    EpiPOReceiptList _envData = EpiPOReceiptList.fromJson(_data);

    return [false, _envData];
  }
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

  var _data = await WebClient(User(token: null))
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

class UOM {
  const UOM(this.id, this.name);

  final String name;
  final String id;
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

  var _data = await WebClient(User(token: null)).get(
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

  var _data = await WebClient(User(token: null)).get(
      _globals.epiApiBaseUrl + '/api/Productions/LoadActiveEmployee' + _params);

  if (_data[0] != null) {
    EpiEmployeeList _envData = EpiEmployeeList.fromJson(_data);

    for (var i = 0; i < _envData.epiemployeelist.length; i++) {
      Employee _epidata = new Employee(
          _envData.epiemployeelist[i].empId,
          _envData.epiemployeelist[i].empName,
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

Future<EpiDOCustInfo> getEpiDOCustInfo(String legalNo) async {
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

  var _data = await WebClient(User(token: null)).get(_globals.epiApiBaseUrl +
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

  var _data = await WebClient(User(token: null)).get(_globals.epiApiBaseUrl +
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

  var _data = await WebClient(User(token: null)).get(_globals.epiApiBaseUrl +
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

  var _data = await WebClient(User(token: null))
      .get(_globals.epiApiBaseUrl + '/api/Productions/LoadWorkQueue' + _params);

  if (_data[0] == null) {
    return [true, _data['Message']];
  } else {
    EpiWorkQueueList _envData = EpiWorkQueueList.fromJson(_data);

    return [false, _envData];
  }
}
