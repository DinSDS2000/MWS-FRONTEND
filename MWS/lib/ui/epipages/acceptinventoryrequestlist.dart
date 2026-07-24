// ignore_for_file: deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/data/classes/epimoveinvreq.dart';
import 'package:flutter_epihhinventory/ui/epipages/acceptinventoryrequest.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class AcceptInventoryRequestList extends StatefulWidget {
  AcceptInventoryRequestList();

  AcceptInventoryRequestListState createState() =>
      AcceptInventoryRequestListState();
}

class AcceptInventoryRequestListState
    extends State<AcceptInventoryRequestList> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _barcodeError = "";
  bool _saving = false;
  late EpiMoveInvReqList _listReq;

  var txtToWhse = new TextEditingController();
  var txtToBin = new TextEditingController();

  FocusNode _textFocusToWhse = new FocusNode();

  @override
  void initState() {
    txtToWhse.addListener(onChangeToWhse);
    _listReq = EpiMoveInvReqList(epimoveinvreqlist: []);
    _textFocusToWhse.addListener(onChangeToWhse);

    super.initState();
  }

  void onChangeToWhse() {
    if (!_textFocusToWhse.hasFocus && txtToWhse.text != '') {
      splitToWhse(txtToWhse.text);
    }
  }

  bool splitToWhse(String txt) {
    bool result = false;
    var strSplit = txt.split(_globals.epibarcodeseperator);

    if (strSplit.length == 2) {
      txtToWhse.text = strSplit[0];
      txtToBin.text = strSplit[1];
      result = true;
    } else {
      var strSplit2 = txt.split(_globals.epibarcodeseperator2);
      if (strSplit2.length == 2) {
        txtToWhse.text = strSplit2[0];
        txtToBin.text = strSplit2[1];
        result = true;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Accept Inventory Request",
          textScaleFactor: textScaleFactor,
        ),
        automaticallyImplyLeading: false,
      ),
      body: ModalProgressHUD(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'To Warehouse'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtToWhse,
                          focusNode: _textFocusToWhse,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 54,
                      child: ElevatedButton(
                        onPressed: barcodeScanningToWhse,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'To Bin'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtToBin,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 54,
                      child: ElevatedButton(
                        onPressed: barcodeScanningToBin,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context, true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            disabledBackgroundColor:
                                Colors.grey, // Disabled button color
                            padding: EdgeInsets.zero, // Removes extra padding
                          ),
                          child: Text(
                            'Cancel',
                            textScaleFactor: textScaleFactor,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 0),
                    Expanded(
                      child: ListTile(
                        title: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _saving = true;
                            });

                            _listReq = EpiMoveInvReqList(epimoveinvreqlist: []);
                            List<dynamic> _result;
                            _result = await getEpiMoveInvReqList(
                                txtToWhse.text, txtToBin.text);

                            if (_result[0] == false) {
                              _listReq = _result[1];
                            } else {
                              showAlertPopup(context, 'Error',
                                  'Inventory Request List : ' + _result[1]);
                            }

                            setState(() {
                              _saving = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            disabledBackgroundColor:
                                Colors.grey, // Disabled button color
                            padding: EdgeInsets.zero, // Removes extra padding
                          ),
                          child: Text(
                            'Retrieve',
                            textScaleFactor: textScaleFactor,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: new Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: populateReqList(context)),
                ),
              ],
            ),
          ),
          inAsyncCall: _saving),
    );
  }

  populateReqList(BuildContext context) {
    int _rowCnt = 0;
    _rowCnt = _listReq.epimoveinvreqlist.length;
    return ListView.builder(
      itemCount: _rowCnt,
      itemBuilder: _getReqListValue,
      padding: EdgeInsets.all(0.0),
    );
  }

  Widget _getReqListValue(BuildContext context, int index) {
    String _listReqNum = '';
    String _listPartNum = '';
    String _listPartDesc = '';
    String _listQty = '';
    String _listFrWhse = '';
    String _listFrBin = '';
    String _listFrLot = '';
    String _listToWhse = '';
    String _listToBin = '';
    String _listToLot = '';
    // String _listLabelCount = '';

    _listReqNum = _listReq.epimoveinvreqlist[index].reqnum;
    _listPartNum = _listReq.epimoveinvreqlist[index].partnum;
    _listPartDesc = _listReq.epimoveinvreqlist[index].partdesc;
    _listQty = _listReq.epimoveinvreqlist[index].dtranqty.toString();
    _listFrWhse = _listReq.epimoveinvreqlist[index].frwhse;
    _listFrBin = _listReq.epimoveinvreqlist[index].frbin;
    _listFrLot = _listReq.epimoveinvreqlist[index].frlotnum;
    _listToWhse = _listReq.epimoveinvreqlist[index].towhse;
    _listToBin = _listReq.epimoveinvreqlist[index].tobin;
    _listToLot = _listReq.epimoveinvreqlist[index].tolotnum;
    // _listLabelCount = _listReq.epimoveinvreqlist[index].labelcount.toString();
    return new Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(47, 85, 156, .9)),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Icon(Icons.inventory, color: Colors.white),
          ),
          title: Text(
            _listReqNum,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  //Icon(Icons.linear_scale, color: Colors.yellowAccent),
                  Text('Part:  ' + _listPartNum + '  ' + _listPartDesc,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: <Widget>[
                  //Icon(Icons.linear_scale, color: Colors.yellowAccent),
                  Text('Qty:    ' + _listQty,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: <Widget>[
                  //Icon(Icons.linear_scale, color: Colors.yellowAccent),
                  Text(
                      'From: ' +
                          _listFrWhse +
                          ' / ' +
                          _listFrBin +
                          ' / ' +
                          _listFrLot,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: <Widget>[
                  //Icon(Icons.linear_scale, color: Colors.yellowAccent),
                  Text(
                      'To:      ' +
                          _listToWhse +
                          ' / ' +
                          _listToBin +
                          ' / ' +
                          _listToLot,
                      style: TextStyle(color: Colors.white)),
                ],
              )
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AcceptInventoryRequest(
                        _listReq.epimoveinvreqlist[index]))).then((value) {
              //print(value);
              if (value != 'C') {
                removeItem(index);
              }
            });
          },
        ),
      ),
    );
  }

  Future barcodeScanningToWhse() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        if (splitToWhse(barcode.rawContent) == false) {
          txtToWhse.text = barcode.rawContent;
        }
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          _barcodeError = 'No camera permission!';
        });
      } else {
        setState(() => _barcodeError = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => _barcodeError = 'Nothing captured.');
    } catch (e) {
      setState(() => _barcodeError = 'Unknown error: $e');
    }
    if (_barcodeError != '') showAlertPopup(context, 'Error', _barcodeError);
  }

  Future barcodeScanningToBin() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtToBin.text = barcode.rawContent;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          _barcodeError = 'No camera permission!';
        });
      } else {
        setState(() => _barcodeError = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => _barcodeError = 'Nothing captured.');
    } catch (e) {
      setState(() => _barcodeError = 'Unknown error: $e');
    }
    if (_barcodeError != '') showAlertPopup(context, 'Error', _barcodeError);
  }

  void removeItem(int index) {
    setState(() {
      _listReq.epimoveinvreqlist.removeAt(index);
    });
  }
}
