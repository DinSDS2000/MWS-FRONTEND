// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constants.dart';

class ProdClockIn extends StatefulWidget {
  ProdClockIn();

  ProdClockInState createState() => ProdClockInState();
}

class ProdClockInState extends State<ProdClockIn> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _barcodeError = '';
  bool _saving = false;

  var txtEmpName = new TextEditingController();
  var txtEmpShift = new TextEditingController();
  var txtProdDate = new TextEditingController();
  var txtProdTime = new TextEditingController();

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

    super.initState();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = _formatTime(now);
    final String formattedDate = _formatDate(now);
    if (!mounted) return;
    setState(() {
      txtProdTime.text = formattedTime;
      txtProdDate.text = formattedDate;
    });
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Clock In / Clock Out",
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
                              decoration:
                                  InputDecoration(labelText: 'Employee Id'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtEmpName,
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
                            onPressed: barcodeScanningName,
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
                              decoration: InputDecoration(labelText: 'Shift'),
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              controller: txtEmpShift,
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
                            onPressed: barcodeScanningShift,
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
                              decoration: InputDecoration(labelText: 'Date'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtProdDate,
                              enabled: false,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration: InputDecoration(labelText: 'Time'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtProdTime,
                              enabled: false,
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
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
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
                      SizedBox(width: 8),
                      Expanded(
                        child: ListTile(
                          title: ElevatedButton(
                            onPressed: submitClockIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Button color
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Clock In',
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
                            onPressed: submitClockOut,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Button color
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Clock Out',
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

  Future submitClockIn() async {
    List<dynamic> _result;

    setState(() {
      _saving = true;
    });

    _result = await postProdClockIn(txtEmpName.text, txtEmpShift.text);

    setState(() {
      _saving = false;
    });

    if (_result[0] == false) {
      showAlertPopup(
          context, 'Error', 'Process Production Clock In : ' + _result[1]);
      return;
    }

    clearAllFields();
  }

  Future submitClockOut() async {
    List<dynamic> _result;

    setState(() {
      _saving = true;
    });

    _result = await postProdClockOut(txtEmpName.text);

    setState(() {
      _saving = false;
    });

    if (_result[0] == false) {
      showAlertPopup(
          context, 'Error', 'Process Production Clock Out : ' + _result[1]);
      return;
    }

    clearAllFields();
  }

  void clearAllFields() {
    txtEmpName.text = '';
    txtEmpShift.text = '';
    // txtProdDate.text = '';
    // txtProdTime.text = '';
  }

  Future barcodeScanningName() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();

      setState(() {
        txtEmpName.text = barcode.rawContent;
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

  Future barcodeScanningShift() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();

      setState(() {
        txtEmpName.text = barcode.rawContent;
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
