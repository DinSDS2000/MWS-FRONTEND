// ignore_for_file: deprecated_member_use

import 'package:barcode_scan2/model/scan_result.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/epijobasm.dart';
import 'package:flutter_epihhinventory/data/classes/epipart.dart';
import 'package:flutter_epihhinventory/ui/epipages/lotcreation.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:flutter_epihhinventory/utils/validator.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class IssueAssembly extends StatefulWidget {
  IssueAssembly();

  IssueAssemblyState createState() => IssueAssemblyState();
}

class IssueAssemblyState extends State<IssueAssembly> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _ccy = new NumberFormat("##,##0.00", "en_US");

  List<UOM> _uoms = List<UOM>.empty(growable: true);

  String _barcodeError = '';
  String _oldAsmNo = '';
  String _oldPartNo = '';
  bool _saving = false;
  bool _lotEnabled = false;

  var txtJobNo = new TextEditingController();
  var txtAsmNo = new TextEditingController();
  var txtPartNo = new TextEditingController();
  var txtPartDesc = new TextEditingController();
  var txtReqQty = new TextEditingController();
  var txtReqIUM = new TextEditingController();
  var txtPrevIssQty = new TextEditingController();
  var txtPrevIssIUM = new TextEditingController();
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
    if (!_textFocusAsmSeq.hasFocus) {
      _oldAsmNo = txtAsmNo.text;
    } else {
      if (_oldAsmNo != txtAsmNo.text) {
        txtPartDesc.text = '';
        txtReqIUM.text = '';
        txtReqQty.text = '0.00';
        txtPrevIssIUM.text = '';
        txtPrevIssQty.text = '0.00';
        txtIUM.text = '';

        if (txtAsmNo.text != '') {
          getJobAsm();
        }
      }
    }
  }

  void onChangePartNo() {
    if (_oldPartNo != txtPartNo.text) {
      txtPartDesc.text = '';
      txtReqIUM.text = '';
      txtReqQty.text = '0.00';
      txtPrevIssIUM.text = '';
      txtPrevIssQty.text = '0.00';
      txtIUM.text = '';
      if (txtPartNo.text.isNotEmpty) {
        splitPartNo(txtPartNo.text);
        getJobAsm();
      }
      _oldPartNo = txtPartNo.text;
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
                  if (_newValue!.id != '0') {
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

  Future getJobAsm() async {
    EpiJobAsm _data = await getEpiJobAsm(txtJobNo.text, txtAsmNo.text);

    if (_data.partnum.toUpperCase() == txtPartNo.text.toUpperCase()) {
      txtReqIUM.text = _data.ium;
      txtPrevIssIUM.text = _data.ium;
      txtReqQty.text = _ccy.format(_data.reqqty);
      txtPrevIssQty.text = _ccy.format(_data.previssueqyy);
      txtIUM.text = _data.ium;
    }
  }

  bool splitJobNo(String txt) {
    bool result = false;
    var strSplit = txt.split(_globals.epibarcodeseperator);
    print(
        "SPEERRREARFESF: ${_globals.epibarcodeseperator} and ${_globals.epibarcodeseperator2}");
    if (strSplit.length == 2) {
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
      txtPartDesc.text = _data.partdescription;
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
          "Issue Assembly",
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
                            onPressed: barcodeScanningJobNo,
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
                            onPressed: barcodeScanningAsmNo,
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
                              decoration: InputDecoration(labelText: 'Part'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtPartNo,
                              focusNode: _textFocusPartNo,
                              onEditingComplete: onChangePartNo,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 54,
                          child: ElevatedButton(
                            onPressed: barcodeScanningPartNo,
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
                              decoration: InputDecoration(labelText: 'Req Qty'),
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              controller: txtReqQty,
                              enabled: false,
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
                              controller: txtReqIUM,
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
                              decoration: InputDecoration(
                                  labelText: 'Previous Issue Qty'),
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              controller: txtPrevIssQty,
                              enabled: false,
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
                              controller: txtPrevIssIUM,
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
                          child: ElevatedButton(
                            onPressed: triggerUOMDropDown,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
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
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 54,
                          child: ElevatedButton(
                            onPressed: barcodeScanningFrWhse,
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
                              decoration:
                                  InputDecoration(labelText: 'From Bin'),
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
                            onPressed: barcodeScanningFrBin,
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
                            onPressed: barcodeScanningLotNo,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.camera_alt),
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
                    //       child: RaisedButton(
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
                    //       child: RaisedButton(
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
                            onPressed: barcodeScanningRef,
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
                            onPressed: submitData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Button color
                              disabledBackgroundColor:
                                  Colors.grey, // Disabled button color
                              padding: EdgeInsets
                                  .zero, // Ensures compact layout like NativeButton
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

    _result = await postIssueAssembly(
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
          context, 'Error', 'Process Issue Assembly : ' + _result[1]);
      return;
    }

    //Navigator.pop(context, true);
    clearAllFields();
  }

  void clearAllFields() {
    txtJobNo.text = '';
    txtAsmNo.text = '';
    txtPartNo.text = '';
    txtReqQty.text = '0.00';
    txtReqIUM.text = '';
    txtPrevIssQty.text = '0.00';
    txtPrevIssIUM.text = '';
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
      ScanResult scanResult = await BarcodeScanner.scan();
      setState(() {
        if (splitJobNo(scanResult.rawContent) == false) {
          txtJobNo.text = scanResult.rawContent;
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
        getJobAsm();
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
        getJobAsm();
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
