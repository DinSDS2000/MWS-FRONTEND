// ignore_for_file: deprecated_member_use

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/epiemployee.dart';
import 'package:flutter_epihhinventory/data/classes/epijoboprresource.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class ProdStartOperation extends StatefulWidget {
  ProdStartOperation();

  ProdStartOperationState createState() => ProdStartOperationState();
}

class ProdStartOperationState extends State<ProdStartOperation> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Employee> _emps = List<Employee>.empty(growable: true);

  String _barcodeError = '';
  String _oldEmpId = '';
  String _oldAsmNo = '';
  String _oldOprNo = '';
  int _laborHedSeq = 0;
  bool _saving = false;

  var txtEmpId = new TextEditingController();
  var txtJobNo = new TextEditingController();
  var txtAsmNo = new TextEditingController();
  var txtOprNo = new TextEditingController();
  var txtResId = new TextEditingController();
  var txtRole = new TextEditingController();
  var txtTimeType = new TextEditingController();
  var txtResGroup = new TextEditingController();
  var txtOpCode = new TextEditingController();

  FocusNode _textFocusEmpId = new FocusNode();
  FocusNode _textFocusJobNo = new FocusNode();
  FocusNode _textFocusAsmSeq = new FocusNode();
  FocusNode _textFocusOprSeq = new FocusNode();

  @override
  void initState() {
    txtEmpId.addListener(onChangeEmpId);
    _textFocusEmpId.addListener(onChangeEmpId);

    txtJobNo.addListener(onChangeJobNo);
    _textFocusJobNo.addListener(onChangeJobNo);

    txtAsmNo.addListener(onChangeAsmSeq);
    _textFocusAsmSeq.addListener(onChangeAsmSeq);

    txtOprNo.addListener(onChangeOprSeq);
    _textFocusOprSeq.addListener(onChangeOprSeq);

    super.initState();
  }

  void onChangeEmpId() {
    if (!_textFocusEmpId.hasFocus) {
      _oldEmpId = txtEmpId.text;
    } else {
      if (_oldEmpId != txtEmpId.text) {
        if (txtEmpId.text != '') {
          print("printing");
          getClockedInEmployee();
        }
      }
    }
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
        if (txtAsmNo.text != '') {
          txtRole.text = '';
          txtTimeType.text = '';
          txtResGroup.text = '';
          txtOpCode.text = '';

          if (txtAsmNo.text != '') {
            getResource();
          }
        }
      }
    }
  }

  void onChangeOprSeq() {
    if (!_textFocusOprSeq.hasFocus) {
      _oldOprNo = txtOprNo.text;
    } else {
      if (_oldOprNo != txtOprNo.text) {
        if (txtOprNo.text != '') {
          txtRole.text = '';
          txtTimeType.text = '';
          txtResGroup.text = '';
          txtOpCode.text = '';

          if (txtOprNo.text != '') {
            getResource();
          }
        }
      }
    }
  }

  Future getResource() async {
    EpiJobOprResource _data = await getEpiJobOprResourceById(
        txtJobNo.text, txtAsmNo.text, txtOprNo.text, txtResId.text);

    txtOpCode.text = _data.opcode;
    txtResGroup.text = _data.resourcegrpid;
    txtResId.text = _data.resourceid;
  }

  Future getClockedInEmployee() async {
    EpiEmployee _data = await getEpiActiveEmployeeById(txtEmpId.text);
    print("Laborhed seq: ${_data}");
    _laborHedSeq = _data.empLaborHedSeq;
  }

  Future<bool> splitAsmNo(String txt) async {
    bool result = false;
    var strSplit = txt.split(_globals.epibarcodeseperator);

    if (strSplit.length == 2) {
      txtAsmNo.text = strSplit[0];
      txtOprNo.text = strSplit[1];
      result = true;
    } else {
      var strSplit2 = txt.split(_globals.epibarcodeseperator2);
      if (strSplit2.length == 2) {
        txtAsmNo.text = strSplit[0];
        txtOprNo.text = strSplit[1];
        result = true;
      } else {
        return false;
      }
    }
    return result;
  }

  bool splitJobNo(String txt) {
    bool result = false;
    var strSplit = txt.split(_globals.epibarcodeseperator);

    if (strSplit.length == 3) {
      txtJobNo.text = strSplit[0];
      txtAsmNo.text = strSplit[1];
      txtOprNo.text = strSplit[2];
      result = true;
    } else {
      var strSplit2 = txt.split(_globals.epibarcodeseperator2);
      if (strSplit2.length == 3) {
        txtJobNo.text = strSplit2[0];
        txtAsmNo.text = strSplit2[1];
        txtOprNo.text = strSplit2[2];
        result = true;
      }
    }

    return result;
  }

  void triggerEmpDropDown() {
    _emps.clear();

    _emps.add(new Employee('0', 'Select Employee', 0));
    getEpiEmployeeList(_emps).then((List<Employee> list) => setState(() {
          displaySelEmpDialog();
        }));
  }

  displaySelEmpDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Employee'),
            content: DropdownButton<Employee>(
              isExpanded: true,
              value: _emps[0],
              onChanged: (Employee? _newValue) {
                setState(() {
                  if (_newValue!.id != '0') {
                    txtEmpId.text = _newValue.id;
                    _laborHedSeq = _newValue.laborhedseq;
                  }
                });
                Navigator.of(context).pop();
              },
              items: _emps.map((Employee _emp) {
                return new DropdownMenuItem<Employee>(
                  value: _emp,
                  child: new Text(
                    _emp.id + ' : ' + _emp.name,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Start Operation",
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
                              decoration: InputDecoration(labelText: 'Emp Id'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtEmpId,
                              focusNode: _textFocusEmpId,
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
                            onPressed: triggerEmpDropDown,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
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
                        SizedBox(
                          width: 10,
                        )
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
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration: InputDecoration(labelText: 'Opr No.'),
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              controller: txtOprNo,
                              focusNode: _textFocusOprSeq,
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
                            // Mtl No.
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningOprNo,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Resource ID'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtResId,
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
                            onPressed: barcodeScanningResId,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    // Row(
                    //   children: <Widget>[
                    //     Expanded(
                    //       child: ListTile(
                    //         title: TextFormField(
                    //           decoration: InputDecoration(labelText: 'Role'),
                    //           obscureText: false,
                    //           keyboardType: TextInputType.text,
                    //           autocorrect: false,
                    //           controller: txtRole,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: <Widget>[
                    //     Expanded(
                    //       child: ListTile(
                    //         title: TextFormField(
                    //           decoration:
                    //               InputDecoration(labelText: 'Time Type'),
                    //           obscureText: false,
                    //           keyboardType: TextInputType.text,
                    //           autocorrect: false,
                    //           controller: txtTimeType,
                    //         ),
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
                                  InputDecoration(labelText: 'Resource Group'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtResGroup,
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
                                  InputDecoration(labelText: 'Operation Code'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtOpCode,
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
                            onPressed: submitData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Button color
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Submit',
                              textScaleFactor: textScaleFactor,
                              style: TextStyle(color: Colors.white),
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

    setState(() {
      _saving = true;
    });
    _result = await postProdStartOperation(txtEmpId.text, txtJobNo.text,
        txtAsmNo.text, txtOprNo.text, txtResId.text, _laborHedSeq.toString());

    setState(() {
      _saving = false;
    });

    if (_result[0] == false) {
      showAlertPopup(context, 'Error',
          'Process Production Start Operation : ' + _result[1]);
      return;
    }

    clearAllFields();
  }

  void clearAllFields() {
    txtEmpId.text = '';
    txtJobNo.text = '';
    txtAsmNo.text = '';
    txtOprNo.text = '';
    txtResId.text = '';
    txtRole.text = '';
    txtTimeType.text = '';
    txtResGroup.text = '';
    txtOpCode.text = '';
    _laborHedSeq = 0;
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
      bool result = await splitAsmNo(barcode.rawContent);
      setState(() {
        if (result == false) {
          txtAsmNo.text = barcode.rawContent;
        }
        // getJobMtl();
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

  Future barcodeScanningOprNo() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtOprNo.text = barcode.rawContent;
        // getJobMtl();
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

  Future barcodeScanningResId() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtResId.text = barcode.rawContent;
        // getJobMtl();
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
