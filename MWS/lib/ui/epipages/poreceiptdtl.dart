// ignore_for_file: deprecated_member_use

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/epipart.dart';
import 'package:flutter_epihhinventory/data/classes/epiporeceiptdtl.dart';
import 'package:flutter_epihhinventory/ui/epipages/lotcreation.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:flutter_epihhinventory/utils/validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class POReceiptDtl extends StatefulWidget {
  final String packno;
  final EpiPOReceiptDtl epiporeceiptdtl;

  POReceiptDtl(this.packno, this.epiporeceiptdtl);

  POReceiptDtlState createState() => POReceiptDtlState();
}

class POReceiptDtlState extends State<POReceiptDtl> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<UOM> _uoms = List<UOM>.empty(growable: true);

  String _barcodeError = "";
  bool _saving = false;
  bool _lotEnabled = false;
  String _packno = '';

  var txtPartNo = new TextEditingController();
  var txtPartDesc = new TextEditingController();
  var txtQty = new TextEditingController();
  var txtIUM = new TextEditingController();
  var txtLotNo = new TextEditingController();
  var txtWhse = new TextEditingController();
  var txtBin = new TextEditingController();
  var txtNoofLable = new TextEditingController();
  var txtDriverName = new TextEditingController();
  var txtDriverIC = new TextEditingController();
  var txtLorry = new TextEditingController();

  FocusNode _textFocusWhse = new FocusNode();
  FocusNode _textFocusQty = new FocusNode();

  @override
  void initState() {
    txtWhse.addListener(onChangeWhse);
    _textFocusWhse.addListener(onChangeWhse);

    txtQty.addListener(onChangeQty);
    _textFocusQty.addListener(onChangeQty);

    super.initState();

    _uoms.add(new UOM('0', 'Not found'));

    _packno = widget.packno;
    txtPartNo.text = widget.epiporeceiptdtl.partnum;
    txtPartDesc.text = widget.epiporeceiptdtl.partdesc;
    /* txtWhse.text = widget.epiporeceiptdtl.whse;
    txtBin.text = widget.epiporeceiptdtl.bin;
    txtLotNo.text = widget.epiporeceiptdtl.lotnum; */

    txtQty.text = '1';
    txtNoofLable.text = '1';

    loadPartInfo();
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

  bool splitWhse(String txt) {
    bool result = false;

    var strSplit = txt.split(_globals.epibarcodeseperator);
    if (strSplit.length >= 2) {
      txtWhse.text = strSplit[0];
      txtBin.text = strSplit[1];

      if (strSplit.length >= 3 && _lotEnabled) {
        txtLotNo.text = strSplit[2];
      }

      result = true;
    } else {
      var strSplit2 = txt.split(_globals.epibarcodeseperator2);
      if (strSplit2.length >= 2) {
        txtWhse.text = strSplit2[0];
        txtBin.text = strSplit2[1];

        if (strSplit2.length >= 3) {
          txtLotNo.text = strSplit2[2];
        }

        result = true;
      }
    }
    return result;
  }

  loadPartInfo() async {
    EpiPart _data = await getEpiPart(widget.epiporeceiptdtl.partnum);

    setState(() {
      txtIUM.text = _data.ium;
      _lotEnabled = _data.tracklots;
      if (_lotEnabled == false) {
        txtLotNo.text = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "PO Receipt",
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
                              enabled: false,
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            // Job No.
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            // Job No.
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
                              decoration: InputDecoration(labelText: 'Lot'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtLotNo,
                              enabled: _lotEnabled,
                            ),
                          ),
                        ),
                        //SizedBox(width: 10),
                        SizedBox(
                          width: 64,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Next Lot',
                              textScaleFactor: textScaleFactor,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            //color: Colors.blue,
                            //disabledColor: Colors.grey,
                            onPressed: genLot,
                          ),
                        ),
                        SizedBox(width: 18),
                        SizedBox(
                          width: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            // Job No.
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningLotNo,
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: <Widget>[
                    // Expanded(
                    //   child: ListTile(
                    //     title: TextFormField(
                    //       decoration:
                    //           InputDecoration(labelText: 'Driver Name'),
                    //       obscureText: false,
                    //       keyboardType: TextInputType.text,
                    //       autocorrect: false,
                    //       controller: txtDriverName,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(width: 10),
                    // SizedBox(
                    //   width: 54,
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       padding: EdgeInsets.zero,
                    //     ),
                    //     // Job No.
                    //     child: Icon(Icons.camera_alt),
                    //     onPressed: barcodeScanningDriverName,
                    //   ),
                    // ),
                    //   ],
                    // ),
                    // Row(
                    //   children: <Widget>[
                    //     Expanded(
                    //       child: ListTile(
                    //         title: TextFormField(
                    //           decoration:
                    //               InputDecoration(labelText: 'Driver IC'),
                    //           obscureText: false,
                    //           keyboardType: TextInputType.text,
                    //           autocorrect: false,
                    //           controller: txtDriverIC,
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
                    //         onPressed: barcodeScanningDriverIc,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: <Widget>[
                    //     Expanded(
                    //       child: ListTile(
                    //         title: TextFormField(
                    //           decoration: InputDecoration(labelText: 'Lorry'),
                    //           obscureText: false,
                    //           keyboardType: TextInputType.text,
                    //           autocorrect: false,
                    //           controller: txtLorry,
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
                    //         onPressed: barcodeScanningLorry,
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
                            onPressed: () => Navigator.pop(context, 'C'),
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
                      SizedBox(width: 0),
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

  Future genLot() async {
    if (txtPartNo.text != '' && _lotEnabled == true) {
      List<dynamic> _result;

      setState(() {
        _saving = true;
      });

      _result = await postNewLot(txtPartNo.text);

      setState(() {
        _saving = false;
      });

      print(_result);

      if (_result[0] == true) {
        txtLotNo.text = _result[1].replaceAll('"', '');
      }
    }
  }

  Future submitData() async {
    List<dynamic> _result;

    //Create lot if Track Lot = true and Lot does not exist
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

    // Update PO Receiot
    setState(() {
      _saving = true;
    });

    /* if (widget.packno != '') {
      _result = await isPOReceiptHeaderExist(
          widget.epiporeceiptdtl.ponum.toString(), widget.packno);
      if (_result[0] == false) {
        _result = await postNewPOReceiptHead(
            widget.epiporeceiptdtl.ponum.toString(),
            widget.packno,
            widget.epiporeceiptdtl.vendorid);

        if (_result[0] == false) {
          setState(() {
            _saving = false;
          });

          showAlertPopup(
              context, 'Error', 'Process PO Receipt Head : ' + _result[1]);
          return;
        }
      }
    } */

    if (widget.packno != '') {
      _result = await postNewPOReceiptDtl(
          widget.epiporeceiptdtl.ponum.toString(),
          widget.epiporeceiptdtl.poline.toString(),
          widget.epiporeceiptdtl.polinerel.toString(),
          _packno,
          widget.epiporeceiptdtl.vendornum.toString(),
          txtPartNo.text,
          txtWhse.text,
          txtBin.text,
          txtLotNo.text,
          txtQty.text,
          txtIUM.text,
          txtDriverName.text,
          txtDriverIC.text,
          txtLorry.text,
          txtNoofLable.text);

      setState(() {
        _saving = false;
      });

      if (_result[0] == false) {
        showAlertPopup(
            context, 'Error', 'Process PO Receipt Detail: ' + _result[1]);
        return;
      }
    } else {
      setState(() {
        _saving = false;
      });

      showAlertPopup(context, 'Error',
          'Process PO Receipt Detail: Pack No. cannot be blank!');
      return;
    }

    Navigator.pop(context, 'A');
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

  Future barcodeScanningWhse() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      //txtWhse.text = barcode.rawContent;
      setState(() {
        if (splitWhse(barcode.rawContent) == false) {
          txtWhse.text = barcode.rawContent;
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

  Future barcodeScanningBin() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtBin.text = barcode.rawContent;
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

  Future barcodeScanningDriverName() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtDriverName.text = barcode.rawContent;
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

  Future barcodeScanningDriverIc() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtDriverIC.text = barcode.rawContent;
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

  Future barcodeScanningLorry() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtLorry.text = barcode.rawContent;
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
