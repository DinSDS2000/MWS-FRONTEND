import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/epipart.dart';
import 'package:flutter_epihhinventory/data/classes/epiporeceiptdtl.dart';
import 'package:flutter_epihhinventory/ui/epipages/lotcreation.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:flutter_epihhinventory/utils/validator.dart';
import 'package:native_widgets/native_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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

  List<UOM> _uoms = new List<UOM>();

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

  loadPartInfo() async {
    EpiPart _data = await getEpiPart(widget.epiporeceiptdtl.partnum);

    setState(() {
      if (_data != null) {
        txtIUM.text = _data.ium;
        _lotEnabled = _data.tracklots;
        if (_lotEnabled == false) {
          txtLotNo.text = '';
        }
      } else {
        _lotEnabled = false;
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
                        //SizedBox(width: 10),
                        SizedBox(
                          width: 64,
                          child:RaisedButton(
                              padding: EdgeInsets.zero,
                              child: Text(
                                'Next Lot',
                                textScaleFactor: textScaleFactor,
                                style: TextStyle(color: Colors.black),
                              ),
                              //color: Colors.blue,
                              //disabledColor: Colors.grey,
                              onPressed: genLot,
                            ),
                        ),
                        SizedBox(width: 18),
                        SizedBox(
                          width: 54,
                          child: RaisedButton(
                            // Job No.
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
                          child: RaisedButton(
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
                            onPressed: () => {Navigator.pop(context, 'C')},
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

      if(_result[0] == true) {
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
      //txtWhse.text = barcode;
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
}
