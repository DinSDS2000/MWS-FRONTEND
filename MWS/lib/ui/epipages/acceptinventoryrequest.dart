// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/data/classes/epimoveinvreq.dart';
import 'package:flutter_epihhinventory/data/classes/epipart.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class AcceptInventoryRequest extends StatefulWidget {
  final EpiMoveInvReq epimoveinvreq;

  AcceptInventoryRequest(this.epimoveinvreq);

  AcceptInventoryRequestState createState() => AcceptInventoryRequestState();
}

class AcceptInventoryRequestState extends State<AcceptInventoryRequest> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<UOM> _uoms = List<UOM>.empty(growable: true);

  //String _barcodeError = "";
  String _reqNum = '';
  bool _saving = false;
  bool _lotEnabled = false;

  var txtPartNo = new TextEditingController();
  var txtPartDesc = new TextEditingController();
  var txtQty = new TextEditingController();
  var txtIUM = new TextEditingController();
  var txtFrWhse = new TextEditingController();
  var txtFrBin = new TextEditingController();
  var txtFrLotNo = new TextEditingController();
  var txtToWhse = new TextEditingController();
  var txtToBin = new TextEditingController();
  var txtToLotNo = new TextEditingController();
  var txtRef = new TextEditingController();
  var txtNoofLable = new TextEditingController();

  FocusNode _textFocusPartNo = new FocusNode();
  FocusNode _textFocusQty = new FocusNode();
  FocusNode _textFocusFrWhse = new FocusNode();
  FocusNode _textFocusToWhse = new FocusNode();

  @override
  void initState() {
    txtPartNo.addListener(onChangePartNo);
    _textFocusPartNo.addListener(onChangePartNo);

    txtQty.addListener(onChangeQty);
    _textFocusQty.addListener(onChangeQty);

    txtFrWhse.addListener(onChangeFrWhse);
    _textFocusFrWhse.addListener(onChangeFrWhse);

    txtToWhse.addListener(onChangeToWhse);
    _textFocusToWhse.addListener(onChangeToWhse);

    super.initState();

    _uoms.add(new UOM('0', 'Not found'));

    _reqNum = widget.epimoveinvreq.reqnum;
    txtPartNo.text = widget.epimoveinvreq.partnum;
    txtPartDesc.text = widget.epimoveinvreq.partdesc;
    txtQty.text = widget.epimoveinvreq.dtranqty.toString();
    txtFrWhse.text = widget.epimoveinvreq.frwhse;
    txtFrBin.text = widget.epimoveinvreq.frbin;
    txtFrLotNo.text = widget.epimoveinvreq.frlotnum;
    txtToWhse.text = widget.epimoveinvreq.towhse;
    txtToBin.text = widget.epimoveinvreq.tobin;
    txtToLotNo.text = widget.epimoveinvreq.tolotnum;
    txtNoofLable.text = widget.epimoveinvreq.labelcount.toString();
  }

  void onChangePartNo() {
    if (!_textFocusPartNo.hasFocus && txtPartNo.text != '') {
      splitPartNo(txtPartNo.text);
      getMovePart();
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

  void onChangeFrWhse() {
    if (!_textFocusFrWhse.hasFocus && txtFrWhse.text != '') {
      splitFrWhse(txtFrWhse.text);
    }
  }

  void onChangeToWhse() {
    if (!_textFocusToWhse.hasFocus && txtToWhse.text != '') {
      splitToWhse(txtToWhse.text);
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
              onChanged: (UOM? _newValue) {
                setState(() {
                  if (_newValue != null && _newValue.id != '0') {
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
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  Future getMovePart() async {
    List<dynamic> _result;

    _result = await getEpiMovInvPart(txtPartNo.text);

    if (_result[0] == false) {
      EpiPart _data = _result[1];

      txtIUM.text = '';
      txtIUM.text = _data.ium;
    }
  }

  Future<bool> splitPartNo(String txt) async {
    bool result = false;
    var strSplit = txt.split(_globals.epibarcodeseperator);

    if (strSplit.length == 2) {
      txtPartNo.text = strSplit[0];
      txtFrLotNo.text = strSplit[1];
      txtToLotNo.text = strSplit[1];
      result = true;
    } else {
      var strSplit2 = txt.split(_globals.epibarcodeseperator2);
      if (strSplit2.length == 2) {
        txtPartNo.text = strSplit2[0];
        txtFrLotNo.text = strSplit2[1];
        txtToLotNo.text = strSplit2[1];
        result = true;
      } else {
        txtPartNo.text = txt;
      }
    }

    EpiPart _data = await getEpiPart(txtPartNo.text);

    setState(() {
      _lotEnabled = _data.tracklots;
      if (_lotEnabled == false) {
        txtFrLotNo.text = '';
        txtToLotNo.text = '';
      }
    });

    return result;
  }

  bool splitFrWhse(String txt) {
    bool result = false;
    var strSplit = txt.split(_globals.epibarcodeseperator);

    if (strSplit.length == 2) {
      txtFrWhse.text = strSplit[0];
      txtFrBin.text = strSplit[1];
      result = true;
    } else {
      var strSplit2 = txt.split(_globals.epibarcodeseperator2);
      if (strSplit2.length == 2) {
        txtFrWhse.text = strSplit2[0];
        txtFrBin.text = strSplit2[1];
        result = true;
      }
    }

    return result;
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
                              enabled: false,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 54,
/*                           child: RaisedButton(
                            // Part
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningPartNo,                            
                          ),
 */
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
                              enabled: true,
                              focusNode: _textFocusQty,
                            ),
                          ),
                        ),
                        //SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: ListTile(
                            title: TextFormField(
                              decoration: InputDecoration(labelText: 'UOM'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtIUM,
                              enabled: false,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 54,
                          child: ElevatedButton(
                            onPressed: triggerUOMDropDown,
                            style: ElevatedButton.styleFrom(
                              padding:
                                  EdgeInsets.zero, // Removes default padding
                            ),
                            child: const Icon(Icons.search),
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
                                  InputDecoration(labelText: 'From Warehouse'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtFrWhse,
                              focusNode: _textFocusFrWhse,
                              enabled: false,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 54,
/*                           child: RaisedButton(
                            // From Warehouse
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningFrWhse,
                          ),
 */
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'From Bin'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtFrBin,
                              enabled: false,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 54,
/*                           child: RaisedButton(
                            // From Bin
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningFrBin,
                          ),
 */
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'From Lot'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtFrLotNo,
                              enabled: false,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 54,
/*                           child: RaisedButton(
                            // Lot
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningFrLotNo,
                          ),
 */
                        ),
                      ],
                    ),
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
                              enabled: false,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 54,
/*                           child: RaisedButton(
                            // To Warehouse
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningToWhse,
                          ),
 */
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
                              enabled: true,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 54,
/*                           child: RaisedButton(
                            // To Bin
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningToBin,
                          ),
 */
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration: InputDecoration(labelText: 'To Lot'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtToLotNo,
                              enabled: _lotEnabled,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 54,
/*                           child: RaisedButton(
                            // Lot
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningToLotNo,
                          ),
 */
                        ),
                      ],
                    ),
/*                     Row(
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
                            // Lot
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningRef,
                          ),
                        ),
                      ],
                    ),
 */
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
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context, 'C');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, // Button color
                                disabledForegroundColor: Colors.grey
                                    .withOpacity(0.38), // Disabled text color
                                disabledBackgroundColor:
                                    Colors.grey, // Disabled button color
                                padding:
                                    EdgeInsets.zero, // Removes extra padding
                              ),
                              child: Text(
                                'Cancel',
                                textScaleFactor: textScaleFactor,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: ElevatedButton(
                              onPressed: () async {
                                submitData(false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, // Button color
                                disabledBackgroundColor:
                                    Colors.grey, // Disabled button color
                                padding:
                                    EdgeInsets.zero, // Removes extra padding
                              ),
                              child: Text(
                                'Reject',
                                textScaleFactor: textScaleFactor,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: ElevatedButton(
                              onPressed: () async {
                                submitData(true);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, // Button color
                                disabledBackgroundColor:
                                    Colors.grey, // Disabled button color
                                padding:
                                    EdgeInsets.zero, // Removes default padding
                              ),
                              child: Text(
                                'Approve',
                                textScaleFactor: textScaleFactor,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                        // Expanded(
                        //   child: ListTile(
                        //     title: NativeButton(
                        //       child: Text(
                        //         'Cancel',
                        //         textScaleFactor: textScaleFactor,
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //       color: Colors.blue,
                        //       onPressed: () async {
                        //         Navigator.pop(context, 'C');
                        //       },
                        //     ),
                        //   ),
                        // ),
                        // Expanded(
                        //   child: ListTile(
                        //     title: NativeButton(
                        //       child: Text(
                        //         'Reject',
                        //         textScaleFactor: textScaleFactor,
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //       color: Colors.blue,
                        //       onPressed: () async {
                        //         submitData(false);
                        //       },
                        //     ),
                        //   ),
                        // ),
                        // Expanded(
                        //   child: ListTile(
                        //     title: NativeButton(
                        //       child: Text(
                        //         'Approve',
                        //         textScaleFactor: textScaleFactor,
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //       color: Colors.blue,
                        //       onPressed: () async {
                        //         submitData(true);
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                )),
          ),
          inAsyncCall: _saving),
    );
  }

  Future submitData(bool isApproved) async {
    List<dynamic> _result;
    String _returnData = '';

/*     if (txtToLotNo.text != '' && _lotEnabled == true) {
      setState(() {
        _saving = true;
      });

      _result = await isPartLotExist(txtPartNo.text, txtToLotNo.text);

      setState(() {
        _saving = false;
      });

      if (_result[0] == false) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LotCreation(txtPartNo.text, txtToLotNo.text),
                fullscreenDialog: true));
        return;
      }
    }
 */
    setState(() {
      _saving = true;
    });

    String _reqStatus = '';

    if (isApproved == true) {
      _reqStatus = '1';
      _returnData = 'A';
    } else {
      _reqStatus = '2';
      _returnData = 'R';
    }

    _result = await postMoveInventoryRequestApproval(
        _reqNum, _reqStatus, txtQty.text, txtToBin.text, txtNoofLable.text);
    if (_result[0] == false) {
      showAlertPopup(
          context, 'Error', 'Process Accept Inventory Request : ' + _result[1]);
      return;
    }

    setState(() {
      _saving = false;
    });

    Navigator.pop(context, _returnData);
  }

/*   Future barcodeScanningPartNo() async {
    try {
      String barcode = await BarcodeScanner.scan();
      bool isOnlyPartNo = await splitPartNo(barcode);
      if (isOnlyPartNo == false) {
        setState(() {
          txtPartNo.text = barcode;
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
  }

  Future barcodeScanningFrLotNo() async {
    try {
      if (_lotEnabled == true) {
        String barcode = await BarcodeScanner.scan();
        setState(() {
          txtFrLotNo.text = barcode;
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
  }

  Future barcodeScanningFrWhse() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        if (splitFrWhse(barcode) == false) {
          txtFrWhse.text = barcode;
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
  }

  Future barcodeScanningFrBin() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        txtFrBin.text = barcode;
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
  }

  Future barcodeScanningToLotNo() async {
    try {
      if (_lotEnabled == true) {
        String barcode = await BarcodeScanner.scan();
        setState(() {
          txtFrLotNo.text = barcode;
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
  }

  Future barcodeScanningToWhse() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        if (splitToWhse(barcode) == false) {
          txtToWhse.text = barcode;
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
  }

  Future barcodeScanningToBin() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        txtToBin.text = barcode;
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
  }

  Future barcodeScanningRef() async {
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
  } */
}
