// ignore_for_file: deprecated_member_use

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/epipart.dart';
import 'package:flutter_epihhinventory/ui/epipages/lotcreation.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:flutter_epihhinventory/utils/validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class JobtoInventory extends StatefulWidget {
  JobtoInventory();

  JobtoInventoryState createState() => JobtoInventoryState();
}

class JobtoInventoryState extends State<JobtoInventory> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<UOM> _uoms = List<UOM>.empty(growable: true);

  String _barcodeError = "";
  bool _saving = false;
  bool _lotEnabled = false;

  var txtJobNo = new TextEditingController();
  var txtAsmNo = new TextEditingController();
  var txtPartNo = new TextEditingController();
  var txtPartDesc = new TextEditingController();
  var txtQty = new TextEditingController();
  var txtIUM = new TextEditingController();
  var txtLotNo = new TextEditingController();
  var txtFrWhse = new TextEditingController();
  var txtFrBin = new TextEditingController();
  var txtToWhse = new TextEditingController();
  var txtToBin = new TextEditingController();
  var txtRef = new TextEditingController();
  var txtNoofLable = new TextEditingController();

  FocusNode _textFocusJobNo = new FocusNode();
  FocusNode _textFocusAsmSeq = new FocusNode();
  FocusNode _textFocusPartNo = new FocusNode();
  FocusNode _textFocusQty = new FocusNode();
  FocusNode _textFocusFrWhse = new FocusNode();
  FocusNode _textFocusToWhse = new FocusNode();

  @override
  void initState() {
    txtJobNo.addListener(onChangeJobNo);
    _textFocusJobNo.addListener(onChangeJobNo);

    txtAsmNo.addListener(onChangeAsmSeq);
    _textFocusAsmSeq.addListener(onChangeAsmSeq);

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

    txtQty.text = '1';
    txtNoofLable.text = '1';
  }

  void onChangeJobNo() {
    if (!_textFocusJobNo.hasFocus && txtJobNo.text != '') {
      splitJobNo(txtJobNo.text);
    }
  }

  void onChangeAsmSeq() {
    if (!_textFocusAsmSeq.hasFocus && txtAsmNo.text != '') {}
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
              new TextButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
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
      txtPartDesc.text = _data.partdescription;
    }
  }

  bool splitJobNo(String txt) {
    bool result = false;
    var strSplit = txt.split(_globals.epibarcodeseperator);

    if (strSplit.length == 3) {
      txtJobNo.text = strSplit[0];
      txtAsmNo.text = strSplit[1];
      txtPartNo.text = strSplit[2];
      result = true;
    } else if (strSplit.length == 2) {
      txtJobNo.text = strSplit[0];
      txtAsmNo.text = strSplit[1];
      result = true;
    } else {
      var strSplit2 = txt.split(_globals.epibarcodeseperator2);
      if (strSplit2.length == 2) {
        txtJobNo.text = strSplit2[0];
        txtAsmNo.text = strSplit2[1];
        result = true;
      }
    }

    return result;
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
      } else {
        txtPartNo.text = txt;
      }
    }

    EpiPart _data = await getEpiPart(txtPartNo.text);

    setState(() {
      _lotEnabled = _data.tracklots;
      if (_lotEnabled == false) {
        txtLotNo.text = '';
      }
    });

    return result;
  }

  bool splitFrWhse(String txt) {
    bool result = false;

    var strSplit = txt.split(_globals.epibarcodeseperator);
    if (strSplit.length >= 2) {
      txtFrWhse.text = strSplit[0];
      txtFrBin.text = strSplit[1];

      if (strSplit.length >= 3 && _lotEnabled) {
        txtLotNo.text = strSplit[2];
      }

      result = true;
    } else {
      var strSplit2 = txt.split(_globals.epibarcodeseperator2);
      if (strSplit2.length >= 2) {
        txtFrWhse.text = strSplit2[0];
        txtFrBin.text = strSplit2[1];

        if (strSplit2.length >= 3) {
          txtLotNo.text = strSplit2[2];
        }

        result = true;
      }
    }
    return result;
  }

  bool splitToWhse(String txt) {
    bool result = false;

    var strSplit = txt.split(_globals.epibarcodeseperator);
    if (strSplit.length >= 2) {
      txtFrWhse.text = strSplit[0];
      txtFrBin.text = strSplit[1];

      if (strSplit.length >= 3 && _lotEnabled) {
        txtLotNo.text = strSplit[2];
      }

      result = true;
    } else {
      var strSplit2 = txt.split(_globals.epibarcodeseperator2);
      if (strSplit2.length >= 2) {
        txtFrWhse.text = strSplit2[0];
        txtFrBin.text = strSplit2[1];

        if (strSplit2.length >= 3) {
          txtLotNo.text = strSplit2[2];
        }

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
          "Job Receipt to Inventory",
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
                              decoration: InputDecoration(labelText: 'Job No.'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtJobNo,
                              focusNode: _textFocusJobNo,
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
                            onPressed: barcodeScanningJobNo,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration: InputDecoration(labelText: 'Asm No.'),
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              controller: txtAsmNo,
                              focusNode: _textFocusAsmSeq,
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
                            // Asm No.
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningAsmNo,
                          ),
                        ),
                      ],
                    ),
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
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
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
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
                              decoration:
                                  InputDecoration(labelText: 'To Warehouse'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtFrWhse,
                              focusNode: _textFocusFrWhse,
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
                            // From Warehouse
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningFrWhse,
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
                              controller: txtFrBin,
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
                            // From Bin
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningFrBin,
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            // Lot
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningLotNo,
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: <Widget>[
                    //     Expanded(
                    //       child: ListTile(
                    //         title: TextFormField(
                    //           decoration:
                    //               InputDecoration(labelText: 'To Warehouse'),
                    //           obscureText: false,
                    //           keyboardType: TextInputType.text,
                    //           autocorrect: false,
                    //           controller: txtToWhse,
                    //           focusNode: _textFocusToWhse,
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(width: 10),
                    //     SizedBox(
                    //       width: 54,
                    //       child: ElevatedButton(
                    //         // To Warehouse
                    //         child: Icon(Icons.camera_alt),
                    //         onPressed: barcodeScanningToWhse,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: <Widget>[
                    //     Expanded(
                    //       child: ListTile(
                    //         title: TextFormField(
                    //           decoration: InputDecoration(labelText: 'To Bin'),
                    //           obscureText: false,
                    //           keyboardType: TextInputType.text,
                    //           autocorrect: false,
                    //           controller: txtToBin,
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(width: 10),
                    //     SizedBox(
                    //       width: 54,
                    //       child: ElevatedButton(
                    //         // To Bin
                    //         child: Icon(Icons.camera_alt),
                    //         onPressed: barcodeScanningToBin,
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
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
                          title: ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Button color
                              disabledBackgroundColor:
                                  Colors.grey, // Disabled button color
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Cancel',
                              textScaleFactor: textScaleFactor,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ListTile(
                          title: ElevatedButton(
                            onPressed: submitData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Button color
                              disabledBackgroundColor:
                                  Colors.grey, // Disabled button color
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Submit',
                              textScaleFactor: textScaleFactor,
                              style: const TextStyle(color: Colors.white),
                            ),
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

    _result = await postJobtoInventory(
        txtJobNo.text,
        txtAsmNo.text,
        txtPartNo.text,
        txtIUM.text,
        txtQty.text,
        txtFrWhse.text,
        txtFrBin.text,
        txtToWhse.text,
        txtToBin.text,
        txtLotNo.text,
        txtRef.text,
        txtNoofLable.text);

    setState(() {
      _saving = false;
    });

    if (_result[0] == false) {
      showAlertPopup(
          context, 'Error', 'Process Job Receipt to Inventory : ' + _result[1]);
      return;
    }

    //Navigator.pop(context, true);
    clearAllFields();
  }

  void clearAllFields() {
    txtJobNo.text = '';
    txtAsmNo.text = '';
    txtPartNo.text = '';
    txtPartDesc.text = '';
    txtQty.text = '0.00';
    txtIUM.text = '';
    txtLotNo.text = '';
    txtFrWhse.text = '';
    txtFrBin.text = '';
    txtToWhse.text = '';
    txtToBin.text = '';
    txtRef.text = '';
    txtNoofLable.text = '1';
  }

  Future barcodeScanningJobNo() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        if (splitJobNo(barcode.rawContent) == false) {
          txtJobNo.text = barcode.rawContent;
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

  Future barcodeScanningAsmNo() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtAsmNo.text = barcode.rawContent;
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

  Future barcodeScanningPartNo() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      bool isSplitPartNo = await splitPartNo(barcode.rawContent);
      setState(() {
        if (isSplitPartNo == false) {
          txtPartNo.text = barcode.rawContent;
        }
        getMovePart();
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

  Future barcodeScanningLotNo() async {
    _barcodeError = '';
    try {
      if (_lotEnabled == true) {
        ScanResult barcode = await BarcodeScanner.scan();
        setState(() {
          txtLotNo.text = barcode.rawContent;
        });
      }
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

  Future barcodeScanningFrWhse() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        if (splitFrWhse(barcode.rawContent) == false) {
          txtFrWhse.text = barcode.rawContent;
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

  Future barcodeScanningFrBin() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtFrBin.text = barcode.rawContent;
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

  Future barcodeScanningRef() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtRef.text = barcode.rawContent;
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
