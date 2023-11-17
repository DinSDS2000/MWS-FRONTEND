import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/epipart.dart';
import 'package:flutter_epihhinventory/ui/epipages/lotcreation.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:flutter_epihhinventory/utils/validator.dart';
import 'package:native_widgets/native_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class QtyAdjustment extends StatefulWidget {
  QtyAdjustment();

  QtyAdjustmentState createState() => QtyAdjustmentState();
}

class QtyAdjustmentState extends State<QtyAdjustment> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<UOM> _uoms = new List<UOM>();
  List<ReasonItem> _reasons = new List<ReasonItem>();

  String _barcodeError = '';
  String _oldPartNo = '';
  bool _saving = false;
  bool _lotEnabled = false;

  var txtPartNo = new TextEditingController();
  var txtPartDesc = new TextEditingController();
  var txtQty = new TextEditingController();
  var txtIUM = new TextEditingController();
  var txtLotNo = new TextEditingController();
  var txtWhse = new TextEditingController();
  var txtBin = new TextEditingController();
  var txtReason = new TextEditingController();
  var txtRef = new TextEditingController();
  var txtNoofLable = new TextEditingController();

  FocusNode _textFocusPartNo = new FocusNode();
  FocusNode _textFocusQty = new FocusNode();
  FocusNode _textFocusWhse = new FocusNode();

  @override
  void initState() {
    txtPartNo.addListener(onChangePartNo);
    _textFocusPartNo.addListener(onChangePartNo);

    txtQty.addListener(onChangeQty);
    _textFocusQty.addListener(onChangeQty);

    txtWhse.addListener(onChangeWhse);
    _textFocusWhse.addListener(onChangeWhse);

    super.initState();

    _uoms.add(new UOM('0', 'Not found'));

    txtQty.text = '1';
    txtNoofLable.text = '1';
  }

  void onChangePartNo() {
    if (!_textFocusPartNo.hasFocus) {
      _oldPartNo = txtPartNo.text;
    } else {
      if (_oldPartNo != txtPartNo.text) {
        txtPartDesc.text = '';
        txtIUM.text = '';
        if (txtPartNo.text != '') {
          splitPartNo(txtPartNo.text);
        }
      }
    }
  }

  void onChangeQty() {
    if (!_textFocusQty.hasFocus && txtQty.text != '') {
      if (_globals.epiisenableusedefaultlabelqty == false) {
        setState(() {
          txtNoofLable.text = txtQty.text;
        });
      }
    }
  }

  void onChangeWhse() {
    if (!_textFocusWhse.hasFocus && txtWhse.text != '') {
      splitWhse(txtWhse.text);
    }
  }

  void triggerUOMDropDown() {
    _uoms.clear();

    if (txtPartNo.text != '') {
      _uoms.add(new UOM('0', 'Select UOM'));
      getEpiUOMList(txtPartNo.text, _uoms)
          .then((List<UOM> list) => setState(() {
                displaySelUOMDialog();
              }));
    } else {
      _uoms.add(new UOM('0', 'Not found'));
      setState(() {
        displaySelUOMDialog();
      });
    }
  }

  displaySelUOMDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select UOM'),
            content: DropdownButton<UOM>(
              isExpanded: true,
              value: _uoms[0],
              onChanged: (UOM _newValue) {
                setState(() {
                  if (_newValue.id != '0') {
                    txtIUM.text = _newValue.id;
                  }
                });
                Navigator.of(context).pop();
              },
              items: _uoms.map((UOM _uom) {
                return new DropdownMenuItem<UOM>(
                  value: _uom,
                  child: new Text(
                    _uom.name,
                    style: new TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void triggerReasonDropDown() {
    _reasons.clear();

    if (txtPartNo.text != '') {
      _reasons.add(new ReasonItem('0', 'Select Reason'));
      getEpiReasonList('M', _reasons)
          .then((List<ReasonItem> list) => setState(() {
                displaySelReasonDialog();
              }));
    } else {
      _reasons.add(new ReasonItem('0', 'Not found'));
      setState(() {
        displaySelReasonDialog();
      });
    }
  }

  displaySelReasonDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Reason'),
            content: DropdownButton<ReasonItem>(
              isExpanded: true,
              value: _reasons[0],
              onChanged: (ReasonItem _newValue) {
                setState(() {
                  if (_newValue.id != '0') {
                    txtReason.text = _newValue.id;
                  }
                });
                Navigator.of(context).pop();
              },
              items: _reasons.map((ReasonItem _reason) {
                return new DropdownMenuItem<ReasonItem>(
                  value: _reason,
                  child: new Text(
                    _reason.name,
                    style: new TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<bool> splitPartNo(String txt) async {
    bool result = false;
    var strSplit = txt.split(_globals.epibarcodeseperator);

    if (strSplit.length == 2) {
      txtPartNo.text = strSplit[0];
      txtLotNo.text = strSplit[1];
      result = true;
    } else {
      var strSplit2 = txt.split(_globals.epibarcodeseperator2);
      if (strSplit2.length == 2) {
        txtPartNo.text = strSplit2[0];
        txtLotNo.text = strSplit2[1];
        result = true;
      }
    }

    EpiPart _data = await getEpiPart(txtPartNo.text);

    setState(() {
      if (_data != null) {
        _lotEnabled = _data.tracklots;
        txtIUM.text = _data.ium;
        txtPartDesc.text = _data.partdescription;
        if (_lotEnabled == false) {
          txtLotNo.text = '';
        }
      } else {
        _lotEnabled = false;
      }
    });

    return result;
  }

  bool splitWhse(String txt) {
    bool result = false;
    var strSplit = txt.split(_globals.epibarcodeseperator);

    if (strSplit.length == 2) {
      txtWhse.text = strSplit[0];
      txtBin.text = strSplit[1];
      result = true;
    } else {
      var strSplit2 = txt.split(_globals.epibarcodeseperator2);
      if (strSplit2.length == 2) {
        txtWhse.text = strSplit2[0];
        txtBin.text = strSplit2[1];
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
          "Quantity Adjustment",
          textScaleFactor: textScaleFactor,
        ),
        automaticallyImplyLeading: false,
      ),
      body: ModalProgressHUD(
          child: SafeArea(
            child: Container(
                margin: const EdgeInsets.all(10.0),
                child: ListView(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration: InputDecoration(labelText: 'Part'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtPartNo,
                              focusNode: _textFocusPartNo,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 54,
                          child: RaisedButton(
                            // Part
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningPartNo,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Description'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtPartDesc,
                              enabled: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Quantity'),
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              controller: txtQty,
                              focusNode: _textFocusQty,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: ListTile(
                            title: TextFormField(
                              decoration: InputDecoration(labelText: 'UOM'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtIUM,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 54,
                          child: RaisedButton(
                            child: Icon(Icons.search),
                            onPressed: triggerUOMDropDown,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration: InputDecoration(labelText: 'Lot'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtLotNo,
                              enabled: _lotEnabled,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 54,
                          child: RaisedButton(
                            // Lot
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningLotNo,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Warehouse'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtWhse,
                              focusNode: _textFocusWhse,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 54,
                          child: RaisedButton(
                            // From Warehouse
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningWhse,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration: InputDecoration(labelText: 'Bin'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtBin,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 54,
                          child: RaisedButton(
                            // From Bin
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningBin,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration: InputDecoration(labelText: 'Reason'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtReason,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 54,
                          child: RaisedButton(
                            child: Icon(Icons.search),
                            onPressed: triggerReasonDropDown,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Reference'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtRef,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 54,
                          child: RaisedButton(
                            // To Bin
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningRef,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'No. of Label'),
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              controller: txtNoofLable,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: NativeButton(
                            padding: EdgeInsets.zero,
                            child: Text(
                              'Cancel',
                              textScaleFactor: textScaleFactor,
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                            disabledColor: Colors.grey,
                            onPressed: () => {Navigator.pop(context, true)},
                          ),
                        ),
                      ),
                      SizedBox(width: 0),
                      Expanded(
                        child: ListTile(
                          title: NativeButton(
                            padding: EdgeInsets.zero,
                            child: Text(
                              'Submit',
                              textScaleFactor: textScaleFactor,
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                            disabledColor: Colors.grey,
                            onPressed: submitData,
                          ),
                        ),
                      )
                    ])
                  ],
                )),
          ),
          inAsyncCall: _saving),
    );
  }

  Future submitData() async {
    List<dynamic> _result;

    if (txtLotNo.text != '' && _lotEnabled == true) {
      setState(() {
        _saving = true;
      });

      _result = await isPartLotExist(txtPartNo.text, txtLotNo.text);

      setState(() {
        _saving = false;
      });

      if (_result[0] == false) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LotCreation(txtPartNo.text, txtLotNo.text),
                fullscreenDialog: true));
        return;
      }
    }

    setState(() {
      _saving = true;
    });

    _result = await postQtyAdjustment(
        txtPartNo.text,
        txtIUM.text,
        txtQty.text,
        txtWhse.text,
        txtBin.text,
        txtLotNo.text,
        txtReason.text,
        txtRef.text,
        txtNoofLable.text);

    setState(() {
      _saving = false;
    });

    if (_result[0] == false) {
      showAlertPopup(
          context, 'Error', 'Process Qty Adjustment : ' + _result[1]);
      return;
    }

    //Navigator.pop(context, true);
    clearAllFields();
  }

  void clearAllFields() {
    txtPartNo.text = '';
    txtPartDesc.text = '';
    txtQty.text = '0.00';
    txtIUM.text = '';
    txtLotNo.text = '';
    txtWhse.text = '';
    txtBin.text = '';
    txtReason.text = '';
    txtRef.text = '';
    txtNoofLable.text = '1';
  }

  Future barcodeScanningPartNo() async {
    _barcodeError = '';
    try {
      String barcode = await BarcodeScanner.scan();
      bool isSplitPartNo = await splitPartNo(barcode);

      setState(() {
        if (isSplitPartNo == false) {
          // if not split part no. means barcode only contains part no.
          txtPartNo.text = barcode;
        }
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
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

  Future barcodeScanningLotNo() async {
    _barcodeError = '';
    try {
      if (_lotEnabled == true) {
        String barcode = await BarcodeScanner.scan();
        setState(() {
          txtLotNo.text = barcode;
        });
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
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

  Future barcodeScanningWhse() async {
    _barcodeError = '';
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        if (splitWhse(barcode) == false) {
          txtWhse.text = barcode;
        }
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
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

  Future barcodeScanningBin() async {
    _barcodeError = '';
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        txtBin.text = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
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

  Future barcodeScanningRef() async {
    _barcodeError = '';
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        txtRef.text = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
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
