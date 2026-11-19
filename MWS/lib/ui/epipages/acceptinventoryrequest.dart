// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<ReasonItem> _reasons = List<ReasonItem>.empty(growable: true);

  var txtPartNo = new TextEditingController();
  var txtPartDesc = new TextEditingController();
  var txtQty = new TextEditingController();
  var txtTransQty = new TextEditingController();
  var txtDiscrepQty = new TextEditingController();
  var txtIUM = new TextEditingController();
  var txtTransIum = new TextEditingController();
  var txtDiscrepIum = new TextEditingController();
  var txtFrWhse = new TextEditingController();
  var txtFrBin = new TextEditingController();
  var txtFrLotNo = new TextEditingController();
  var txtToWhse = new TextEditingController();
  var txtToBin = new TextEditingController();
  var txtToLotNo = new TextEditingController();
  var txtRef = new TextEditingController();
  var txtNoofLable = new TextEditingController();
  var txtDummyPart = new TextEditingController();
  var txtTaxCatId = new TextEditingController();
  var txtTaxRef = new TextEditingController();

  FocusNode _textFocusPartNo = new FocusNode();
  FocusNode _textFocusQty = new FocusNode();
  FocusNode _textFocusFrWhse = new FocusNode();
  FocusNode _textFocusToWhse = new FocusNode();
  final FocusNode _scannerFocusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scannerFocusNode.requestFocus();
    });
    txtPartNo.addListener(onChangePartNo);
    _textFocusPartNo.addListener(onChangePartNo);

    txtQty.addListener(onChangeQty);
    _textFocusQty.addListener(onChangeQty);

    txtFrWhse.addListener(onChangeFrWhse);
    _textFocusFrWhse.addListener(onChangeFrWhse);

    txtToWhse.addListener(onChangeToWhse);
    _textFocusToWhse.addListener(onChangeToWhse);

    txtTransQty.addListener(_calculateDiscrepancy);
    super.initState();

    _uoms.add(new UOM('0', 'Not found'));
    _reqNum = widget.epimoveinvreq.reqnum;
    txtPartNo.text = widget.epimoveinvreq.partnum;
    txtPartDesc.text = widget.epimoveinvreq.partdesc;
    txtTransQty.text = widget.epimoveinvreq.dtranqty.toString();
    txtFrWhse.text = widget.epimoveinvreq.frwhse;
    txtFrBin.text = widget.epimoveinvreq.frbin;
    txtFrLotNo.text = widget.epimoveinvreq.frlotnum;
    txtToWhse.text = widget.epimoveinvreq.towhse;
    txtToBin.text = widget.epimoveinvreq.tobin;
    txtToLotNo.text = widget.epimoveinvreq.tolotnum;
    txtTaxCatId.text = widget.epimoveinvreq.taxCatID;
    txtTaxRef.text = widget.epimoveinvreq.taxRef;
    txtRef.text = widget.epimoveinvreq.reference;
    txtNoofLable.text = widget.epimoveinvreq.labelcount.toString();
  }

  @override
  void dispose() {
    _scannerFocusNode.dispose();
    super.dispose();
  }

  bool splitDummyPart(String rawBarcode) {
    final pattern = RegExp(
        '${RegExp.escape(_globals.epibarcodeseperator)}|${RegExp.escape(_globals.epibarcodeseperator2)}');

    var strSplit = rawBarcode.split(pattern);

    if (strSplit.length >= 2) {
      String scannedPart = strSplit[0]; // The first split value
      String expectedPart =
          txtPartNo.text; // The original part number in txtPart

      if (scannedPart != expectedPart) {
        txtDummyPart.clear();

        // Show the Error Alert Dialog
        showDialog(
          context: context,
          barrierDismissible: false, // Prevents closing by tapping outside
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error', style: TextStyle(color: Colors.red)),
              content: Text(
                  'Scanned part ($scannedPart) does not match expected part ($expectedPart)!'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismisses the dialog

                    // Re-lock focus onto the hidden field so they can scan again immediately
                    _scannerFocusNode.requestFocus();
                  },
                ),
              ],
            );
          },
        );

        return false; // Stop execution here so the wrong code doesn't fill the fields
      }

      setState(() {
        txtDummyPart.text = scannedPart; // First value stays here
        txtToLotNo.text = strSplit[1]; // Second value goes to lot field
      });

      return true;
    }

    // If the barcode doesn't even have a valid separator format, clear it out too!
    txtDummyPart.clear();
    return false;
  }

  void onChangePartNo() {
    if (!_textFocusPartNo.hasFocus && txtPartNo.text != '') {
      splitPartNo(txtPartNo.text);
      getMovePart();
    }
  }

  void onChangeQty() {
    setState(() {
      _calculateDiscrepancy();

      if (!_textFocusQty.hasFocus && txtQty.text.isNotEmpty) {
        if (_globals.epiisenableusedefaultlabelqty == false) {
          txtNoofLable.text = txtQty.text;
        }
      }
    });
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

  void triggerUOMDropDown(TextEditingController targetController) {
    _uoms.clear();

    if (txtPartNo.text != '') {
      _uoms.add(new UOM('0', 'Select UOM'));
      getEpiUOMList(txtPartNo.text, _uoms)
          .then((List<UOM> list) => setState(() {
                displaySelUOMDialog(targetController);
              }));
    } else {
      _uoms.add(new UOM('0', 'Not found'));
      setState(() {
        displaySelUOMDialog(targetController);
      });
    }
  }

  displaySelUOMDialog(TextEditingController targetController) async {
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
                    targetController.text = _newValue.id;
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
      txtTransIum.text = _data.ium;
      txtDiscrepIum.text = _data.ium;
    }
  }

  void _calculateDiscrepancy() {
    final transText = txtTransQty.text;
    final actualText = txtQty.text;

    // Rule: Only calculate if Transferred Quantity has an input
    if (transText.isEmpty) {
      setState(() {
        txtDiscrepQty.text = ''; // Keep it empty if no trans qty
      });
      return;
    }

    // Parse strings to numbers (int or double depending on your needs)
    final double transQty = double.tryParse(transText) ?? 0.0;
    final double actualQty = double.tryParse(actualText) ?? 0.0;

    // Formula: Discrepancy = Actual - Transferred
    final double discrepancy = actualQty - transQty;

    setState(() {
      // Format to remove trailing zeros if they are integers (e.g., 5.0 -> 5)
      txtDiscrepQty.text = discrepancy % 1 == 0
          ? discrepancy.toInt().toString()
          : discrepancy.toString();
    });
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();

          _scannerFocusNode.requestFocus();
        },
        child: ModalProgressHUD(
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
                      SizedBox(
                        width: 0,
                        height: 0,
                        child: TextFormField(
                          controller: txtDummyPart,
                          focusNode: _scannerFocusNode,
                          autofocus: true,
                          keyboardType: TextInputType
                              .none, // Keeps screen keyboard hidden
                          showCursor: false,
                          style: const TextStyle(color: Colors.transparent),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onFieldSubmitted: (value) {
                            print("Complete raw barcode received: $value");

                            if (value.isNotEmpty) {
                              // 1. Split the data safely without looping crashes
                              splitDummyPart(value);
                            }

                            // 3. Keep the focus locked here
                            _scannerFocusNode.requestFocus();
                          },
                        ),
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
                                decoration: InputDecoration(
                                    labelText: 'Actual Quantity'),
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
                              onPressed: () => triggerUOMDropDown(txtIUM),
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
                                decoration: InputDecoration(
                                    labelText: 'Transferred Quantity'),
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                autocorrect: false,
                                controller: txtTransQty,
                                enabled: true,
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
                                controller: txtTransIum,
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
                                    labelText: 'Discrepancy Quantity'),
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                autocorrect: false,
                                controller: txtDiscrepQty,
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
                                controller: txtDiscrepIum,
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
                                    labelText: 'From Warehouse'),
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
                                decoration:
                                    InputDecoration(labelText: 'To Bin'),
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
                                decoration:
                                    InputDecoration(labelText: 'To Lot'),
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
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ListTile(
                              title: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Tax Category'),
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                controller: txtTaxCatId,
                                enabled: false,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: ListTile(
                              title: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Tax Reference'),
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                controller: txtTaxRef,
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
                            // child: ElevatedButton(
                            //   // Lot
                            //   child: Icon(Icons.camera_alt),
                            //   onPressed: barcodeScanningRef,
                            // ),
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
                          SizedBox(
                            width: 64,
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
                                  padding: EdgeInsets
                                      .zero, // Removes default padding
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
      ),
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

    try {
      if (txtDiscrepQty.text != "0") {
        List<ReasonItem> reasonList = await getEpiReasonList('M', _reasons);
        String reasonCode =
            reasonList.isNotEmpty ? reasonList.first.name : "DEFAULT";
        await postQtyAdjustment(
            txtPartNo.text,
            txtIUM.text,
            txtDiscrepQty.text,
            txtFrWhse.text,
            txtFrBin.text,
            txtFrLotNo.text,
            reasonCode,
            txtRef.text,
            txtNoofLable.text);
      }

      String _reqStatus = '';

      if (isApproved == true) {
        _reqStatus = '1';
        _returnData = 'A';
      } else {
        _reqStatus = '2';
        _returnData = 'R';
      }
      print("QUANTIY: ${txtQty.text}");
      _result = await postMoveInventoryRequestApproval(
          _reqNum,
          _reqStatus,
          txtQty.text,
          txtToBin.text,
          txtDiscrepQty.text,
          txtTransQty.text,
          txtRef.text,
          txtTaxCatId.text,
          txtTaxRef.text,
          txtNoofLable.text);
      if (_result[0] == false) {
        showAlertPopup(context, 'Error',
            'Process Accept Inventory Request : ' + _result[1]);
        return;
      }
    } catch (error) {
      print("Inventory transaction failed:" + error.toString());
      showAlertPopup(context, 'Error',
          'Network or system error occurred: ' + error.toString());
      // Alert user that a failure occurred mid-transaction
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
  }  */
}
