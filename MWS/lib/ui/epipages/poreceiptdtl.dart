// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/epipart.dart';
import 'package:flutter_epihhinventory/data/classes/epiporeceiptdtl.dart';
import 'package:flutter_epihhinventory/data/classes/user.dart';
import 'package:flutter_epihhinventory/data/web_client.dart';
import 'package:flutter_epihhinventory/ui/epipages/lotcreation.dart';
import 'package:flutter_epihhinventory/ui/epipages/previewscreen.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:flutter_epihhinventory/utils/validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class POReceiptDtl extends StatefulWidget {
  final String packno;
  final String userID;
  final String companyID;
  final EpiPOReceiptDtl epiporeceiptdtl;

  POReceiptDtl(this.packno, this.epiporeceiptdtl, this.userID, this.companyID);

  POReceiptDtlState createState() => POReceiptDtlState();
}

class POReceiptDtlState extends State<POReceiptDtl> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<UOM> _uoms = List<UOM>.empty(growable: true);

  EpiWhse? _selectedEpiWhse;
  List<EpiWhse> _epiwhse = [];
  String _barcodeError = "";
  bool _saving = false;
  bool _lotEnabled = false;
  String _packno = '';
  List<FileSystemEntity> file = [];
  String directory = "";

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
    loadEpiWhse();

    loadPartInfo();
    _listofFiles();
  }

  void loadEpiWhse() {
    // if(_locEnabled) {
    _epiwhse.clear();

    _epiwhse.add(new EpiWhse(
      '0',
      'Please select Warehouse',
    ));

    setState(() {
      _selectedEpiWhse = _epiwhse[0];
    });

    getEpiWhseList();
    // }
  }

  void onChangeQty() {
    if (!_textFocusQty.hasFocus && txtQty.text.isNotEmpty) {
      final qtyValue = num.tryParse(txtQty.text);
      if (qtyValue != null && qtyValue % 1 == 0) {
        // integer check
        if (_globals.epiisenableusedefaultlabelqty == false) {
          setState(() {
            txtNoofLable.text = txtQty.text;
          });
        }
      }
    }
  }

  void _listofFiles() async {
    directory = (await getApplicationDocumentsDirectory()).path;

    List<FileSystemEntity> tempFile = Directory(directory).listSync();

    file.clear();

    for (var entity in tempFile) {
      if (entity is! File) continue; // skip folders

      File f = entity as File;

      String fileName = f.path.split('/').last;

      // get part before "_"
      String fileNamePrefix = fileName.split('_').first;

      print("fileNamePrefix = $fileNamePrefix");

      // expected prefix
      String prefix =
          "${_packno}-${widget.epiporeceiptdtl.ponum}-${widget.epiporeceiptdtl.poline}-${widget.epiporeceiptdtl.polinerel}";

      print("expected prefix = $prefix");

      if (fileNamePrefix == prefix) {
        file.add(f); // now it's safe
      }
    }

    setState(() {});
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
                    // Row(
                    //   children: <Widget>[
                    //     Expanded(
                    //       child: ListTile(
                    //         title: TextFormField(
                    //           decoration:
                    //               InputDecoration(labelText: 'Warehouse'),
                    //           obscureText: false,
                    //           keyboardType: TextInputType.text,
                    //           autocorrect: false,
                    //           controller: txtWhse,
                    //           focusNode: _textFocusWhse,
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
                    //         onPressed: barcodeScanningWhse,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      children: [
                        Expanded(
                            child: ListTile(
                          title: Container(
                            height: 60,
                            child: DropdownButton<EpiWhse>(
                              isExpanded: true,
                              value: _selectedEpiWhse,
                              onChanged: (EpiWhse? _newValue) {
                                setState(() {
                                  if (_newValue != null) {
                                    _selectedEpiWhse = _newValue;
                                  }
                                });
                              },
                              items: _epiwhse.map((EpiWhse whse) {
                                return DropdownMenuItem<EpiWhse>(
                                  value: whse,
                                  child: Text(whse.name),
                                );
                              }).toList(),
                            ),
                          ),
                        ))
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
                    Container(
                      padding: const EdgeInsets.only(left: 12.0, top: 10.0),
                      child: Text('Attachment(s)'),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, top: 10.0),
                            child: Container(
                              height: 100.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              child: ListView.builder(
                                itemCount: file.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            // Expanded so the filename shrinks if too long
                                            Expanded(
                                              child: InkWell(
                                                child: Text(
                                                  file[index]
                                                      .toString()
                                                      .split('/')
                                                      .last
                                                      .replaceAll("'", ""),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PreviewScreen(
                                                        imageFile:
                                                            file[index] as File,
                                                        fileList: file,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    8), // spacing before close button
                                            SizedBox(
                                              width: 54,
                                              child: IconButton(
                                                icon: Icon(Icons.close),
                                                iconSize: 24,
                                                padding: EdgeInsets
                                                    .zero, // remove default padding
                                                constraints:
                                                    BoxConstraints(), // optional: shrink the button
                                                onPressed: () {
                                                  setState(() {
                                                    file[index].delete(
                                                        recursive: true);
                                                    _listofFiles();
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero),
                            child: Icon(Icons.add_a_photo),
                            onPressed: cameraCapture,
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
                            onPressed: submitDataRest,
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

  Future<void> cameraCapture() async {
    try {
      // Open camera
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile == null) return; // user cancelled

      // Build your existing prefix
      String prefix =
          "${_packno}-${widget.epiporeceiptdtl.ponum}-${widget.epiporeceiptdtl.poline}-${widget.epiporeceiptdtl.polinerel}";

      // Get app directory
      final directory = await getApplicationDocumentsDirectory();

      // Create unique filename
      final String fileName =
          '${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final String savePath = '${directory.path}/$fileName';

      // Save image
      final File savedFile = await File(pickedFile.path).copy(savePath);

      print("📸 Saved image: ${savedFile.path}");

      // Refresh attachment list (your UI)
      _listofFiles(); // <-- no navigation needed

      // Optional: if you want UI to update immediately
      setState(() {});
    } catch (e) {
      showAlertPopup(context, 'Error', '$e');
    }
  }

  Future<List<EpiWhse>> getEpiWhseList() async {
    final uri =
        Uri.parse('${_globals.epiApiBaseUrl}/api/Receipt/GetSLVWarehouse')
            .replace(queryParameters: {
      "company": _globals.epiCompanyId,
      "plant": _globals.epiSiteId,
      "userID": widget.userID,
    });

    var _data = await WebClient(User(token: '')).get(uri.toString());

    final List<dynamic> values = _data['value'] ?? [];

    // clear previous items except placeholder
    _epiwhse.removeRange(1, _epiwhse.length); // keep 'Please select Warehouse'

    for (var item in values) {
      _epiwhse.add(EpiWhse(item['UD04_Key1'], item['Warehse_Description']));
    }

    // Keep the placeholder as default
    _selectedEpiWhse = _epiwhse[0];

    setState(() {});
    return _epiwhse;
  }

  Future submitDataRest() async {
    List<dynamic> _result;

    // if (num.parse(txtQty.text) > widget.epiporeceiptdtl.balqty)
    // {
    //   showAlertPopup(context, 'Error', 'Transaction Block Due to Receiving More Than the Purchase Quantity.');
    //   txtQty.text = '0';
    // }

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
          _selectedEpiWhse?.id ?? "",
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
            context, 'Error', 'Process PO Receipt Detail: ' + _result[1][0]);
        return;
      } else {
        // var response = _result[2];
        // var rcvDtl = response['RcvDtl'][response['RcvDtl'].length - 1];
        // var packLine = rcvDtl['PackLine'].toString();
        if (file.length > 0) {
          //for (int i = 0; i < file.length; i++) {
          for (int i = file.length - 1; i >= 0; i--) {
            File fileItem = File(file[i].path);

            // List<int> imageBytes = fileItem.readAsBytesSync();
            // String base64Image = base64Encode(imageBytes);
            double packLineDouble = double.parse(_result[1].toString());

            _result = await uploadAttachmentRcvDtlRest(
                docTypeID: '',
                parentTable: 'RcvDtl',
                file: fileItem,
                vendorNum: widget.epiporeceiptdtl.vendornum.toDouble(),
                purPoint: widget.epiporeceiptdtl.purpoint ?? "",
                packSlip: _packno,
                packLine: packLineDouble);

            if (_result[0] == false) {
              showAlertPopup(context, 'Error',
                  'Process PO Receipt Detail: ' + _result[1][0]);
              return;
            } else {
              file[i].delete(recursive: true);
            }
          }
        }
      }
    } else {
      setState(() {
        _saving = false;
      });

      showAlertPopup(context, 'Error',
          'Process PO Receipt Detail: Pack No. cannot be blank!');
      return;
    }

    showOKDialog(context, 'Success', '‘Transaction is successful.');

    //Navigator.pop(context, 'A');
  }

  showOKDialog(BuildContext context, String title, String detail) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context, 'A');
        Navigator.pop(context, 'A');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(detail),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class EpiWhse {
  const EpiWhse(
    this.id,
    this.name,
  );

  final String id;
  final String name;

  // Override equality for DropdownButton
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EpiWhse &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => '$id - $name';
}
