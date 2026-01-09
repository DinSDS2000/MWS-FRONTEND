// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/data/classes/epiporeceipt.dart';
import 'package:flutter_epihhinventory/data/classes/epiporeceiptdtl.dart';
import 'package:flutter_epihhinventory/ui/epipages/poreceiptdtl.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constants.dart';

class POReceiptList extends StatefulWidget {
  POReceiptList();

  POReceiptListState createState() => POReceiptListState();
}

class POReceiptListState extends State<POReceiptList> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _barcodeError = "";
  String _oldPONo = '';
  String _oldLegalNo = '';
  bool _saving = false;

  late EpiPOReceiptDtlList _listPO =
      EpiPOReceiptDtlList(epiporeceiptdtllist: []);

  var txtPONo = new TextEditingController();
  var txtLegalNo = new TextEditingController();
  var txtPackNo = new TextEditingController();
  var txtVendorId = new TextEditingController();

  FocusNode _textFocusPONo = new FocusNode();
  FocusNode _textFocusLegalNo = new FocusNode();

  @override
  void initState() {
    txtPONo.addListener(onChangePONo);
    _textFocusPONo.addListener(onChangePONo);

    txtLegalNo.addListener(onChangeLegalNo);
    _textFocusLegalNo.addListener(onChangeLegalNo);

    super.initState();
  }

  void onChangePONo() {
    if (!_textFocusPONo.hasFocus) {
      _oldPONo = txtPONo.text;
    } else {
      if (_oldPONo != txtPONo.text) {
        setState(() {
          _listPO.epiporeceiptdtllist.clear();
        });
        txtLegalNo.text = "";

        getPO(txtPONo.text, "");
      }
    }
  }

  void onChangeLegalNo() {
    if (!_textFocusLegalNo.hasFocus) {
      _oldLegalNo = txtLegalNo.text;
    } else {
      if (_oldLegalNo != txtLegalNo.text) {
        setState(() {
          _listPO.epiporeceiptdtllist.clear();
        });
        txtPONo.text = "";
        // getPO("", txtLegalNo.text);
      }
    }
  }

  Future getPO(String ponum, String legalnum) async {
    List<dynamic> _result;

    if (ponum == "") {
      ponum = "0";
    }

    _result = await getEpiPOReceiptList(ponum, legalnum);

    if (_result[0] == false) {
      EpiPOReceiptList _data = _result[1];

      if (legalnum != "") {
        txtPONo.text = _data.epiporeceiptlist[0].ponum.toString();
      } else {
        txtLegalNo.text = _data.epiporeceiptlist[0].legalnumber;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "PO Receipt List",
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
                          decoration: InputDecoration(labelText: 'PO No.'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtPONo,
                          focusNode: _textFocusPONo,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        // Job No.
                        child: Icon(Icons.camera_alt),
                        onPressed: barcodeScanningPONo,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Legal No.'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtLegalNo,
                          focusNode: _textFocusLegalNo,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        // Job No.
                        child: Icon(Icons.camera_alt),
                        onPressed: barcodeScanningLegalNo,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Pack No.'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtPackNo,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        // Job No.
                        child: Icon(Icons.camera_alt),
                        onPressed: barcodeScanningPackNo,
                      ),
                    ),
                  ],
                ),
                // Row(
                //   children: <Widget>[
                //     Expanded(
                //       child: ListTile(
                //         title: TextFormField(
                //           decoration: InputDecoration(labelText: 'Supplier.'),
                //           obscureText: false,
                //           keyboardType: TextInputType.text,
                //           autocorrect: false,
                //           controller: txtVendorId,
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 10),
                //     SizedBox(
                //       width: 54,
                //       child: ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //           padding: EdgeInsets.zero,
                //         ),
                //         // Job No.
                //         child: Icon(Icons.camera_alt),
                //         onPressed: barcodeScanningPackNo,
                //       ),
                //     ),
                //   ],
                // ),
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
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Cancel',
                            textScaleFactor: textScaleFactor,
                            style: TextStyle(color: Colors.white),
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

                            List<dynamic> _result =
                                await getEpiPOReceiptDtlList(txtPONo.text,
                                    txtLegalNo.text, txtVendorId.text);
                            if (_result[0] == false) {
                              _listPO = _result[1];
                            } else {
                              showAlertPopup(context, 'Error',
                                  'PO Receipt List: ' + _result[1]);
                            }

                            setState(() {
                              _saving = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            disabledBackgroundColor:
                                Colors.grey, // Disabled button color
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Retrieve',
                            textAlign: TextAlign.center,
                            textScaleFactor: textScaleFactor,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: new Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: populatePOReceiptList(context)),
                ),
              ],
            ),
          ),
          inAsyncCall: _saving),
    );
  }

  populatePOReceiptList(BuildContext context) {
    int _rowCnt = 0;
    _rowCnt = _listPO.epiporeceiptdtllist.length;
    return ListView.builder(
      itemCount: _rowCnt,
      itemBuilder: _getPOReceiptDtlListValue,
      padding: EdgeInsets.all(0.0),
    );
  }

  Widget _getPOReceiptDtlListValue(BuildContext context, int index) {
    String _listPOLine = '';
    String _listPOLineRel = '';
    String _listPartNum = '';
    String _listPartDesc = '';
    String _listPORelQty = '';
    String _listVendorId = '';
    String _listWhse = '';
    String _listBin = '';
    String _listLot = '';

    _listPOLine = _listPO.epiporeceiptdtllist[index].poline.toString();
    _listPOLineRel = _listPO.epiporeceiptdtllist[index].polinerel.toString();
    _listPartNum = _listPO.epiporeceiptdtllist[index].partnum;
    _listPartDesc = _listPO.epiporeceiptdtllist[index].partdesc;
    _listPORelQty = _listPO.epiporeceiptdtllist[index].porelqty.toString();
    _listVendorId = _listPO.epiporeceiptdtllist[index].vendorid;
    _listWhse = _listPO.epiporeceiptdtllist[index].whse ?? ' ';
    _listBin = _listPO.epiporeceiptdtllist[index].bin ?? ' ';
    _listLot = _listPO.epiporeceiptdtllist[index].lotnum ?? ' ';
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
            child: Icon(Icons.library_books, color: Colors.white),
          ),
          title: Text(
            _listPartNum + ' : ' + _listPartDesc,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Line/Rel: ' + _listPOLine + '/' + _listPOLineRel,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Rel Qty: ' + _listPORelQty,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Vendor Id: ' + _listVendorId,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                      'WH/Bin/Lot: ' +
                          _listWhse +
                          '/' +
                          _listBin +
                          '/' +
                          _listLot,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () async {
            if (txtPackNo.text == '') {
              showAlertPopup(context, 'Error', 'Please provide pack no.');
              return;
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => POReceiptDtl(txtPackNo.text,
                        _listPO.epiporeceiptdtllist[index]))).then((value) {
              if (value != 'C') {
                removeItem(index);
              }
            });
          },
        ),
      ),
    );
  }

  void removeItem(int index) {
    setState(() {
      _listPO.epiporeceiptdtllist.removeAt(index);
    });
  }

  Future barcodeScanningPONo() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtPONo.text = barcode.rawContent;
        getPO(txtPONo.text, "");
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

  Future barcodeScanningLegalNo() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtLegalNo.text = barcode.rawContent;
        getPO("", txtLegalNo.text);
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

  Future barcodeScanningPackNo() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtPackNo.text = barcode.rawContent;
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

  Future barcodeScanningVendorId() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtVendorId.text = barcode.rawContent;
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
}
