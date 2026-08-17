// ignore_for_file: deprecated_member_use

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/epipart.dart';
import 'package:flutter_epihhinventory/data/classes/epireason.dart';
import 'package:flutter_epihhinventory/data/classes/epireprint.dart';
import 'package:flutter_epihhinventory/data/classes/epitrxinfo.dart';
import 'package:flutter_epihhinventory/ui/epipages/reprintlabeldtl.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class ReprintLabel extends StatefulWidget {
  ReprintLabel();

  ReprintLabelState createState() => ReprintLabelState();
}

class ReprintLabelState extends State<ReprintLabel> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<UOM> _uoms = List<UOM>.empty(growable: true);

  String _barcodeError = '';
  bool _saving = false;
  bool _lotEnabled = false;
  late EpiReprintInfoList _reprintList = EpiReprintInfoList(reprintList: []);

  var txtTrxNo = new TextEditingController();
  var txtPartNo = new TextEditingController();
  var txtToSeqNo = new TextEditingController();
  var txtFromSeqNo = new TextEditingController();
  var txtBatchNo = new TextEditingController();
  var txtLotNo = new TextEditingController();
  var txtQty = new TextEditingController();
  var txtIUM = new TextEditingController();
  var txtNoofLable = new TextEditingController();

  FocusNode _textFocusTrxNo = new FocusNode();
  FocusNode _textFocusPartNo = new FocusNode();
  FocusNode _textFocusQty = new FocusNode();
  FocusNode _textFocusToSeqNo = new FocusNode();
  FocusNode _textFocusFromSeqNo = new FocusNode();
  FocusNode _textFocusBatchNo = new FocusNode();

  String _oldTrxNo = '';
  String _oldPartNo = '';

  String _sysDate = '';
  String _tranType = '';
  String _assmSeq = '';
  String _jobNo = '';

  @override
  void initState() {
    txtTrxNo.addListener(onChangeTrxNo);
    _textFocusTrxNo.addListener(onChangeTrxNo);

    txtPartNo.addListener(onChangePartNo);
    _textFocusPartNo.addListener(onChangePartNo);

    txtQty.addListener(onChangeQty);
    _textFocusQty.addListener(onChangeQty);

    txtToSeqNo.addListener(onChangeQty);
    _textFocusToSeqNo.addListener(onChangeQty);

    txtFromSeqNo.addListener(onChangeQty);
    _textFocusFromSeqNo.addListener(onChangeQty);

    txtBatchNo.addListener(onChangeQty);
    _textFocusBatchNo.addListener(onChangeQty);

    super.initState();

    _uoms.add(new UOM('0', 'Not found'));

    txtQty.text = '1';
    txtNoofLable.text = '1';
  }

  void onChangeTrxNo() {
    if (!_textFocusTrxNo.hasFocus && txtTrxNo.text != '') {
      if (_oldTrxNo != txtTrxNo.text) {
        getTrxInfo();
        _oldTrxNo = txtTrxNo.text;
      }
    }
  }

  void onChangePartNo() {
    if (!_textFocusPartNo.hasFocus && txtPartNo.text != '') {
      if (_oldPartNo != txtPartNo.text) {
        splitPartNo(txtPartNo.text);
        getMovePart();
        _oldPartNo = txtPartNo.text;
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

  Future getTrxInfo() async {
    EpiTrxInfo _result;

    _result = await getEpiTrxInfo(txtTrxNo.text);

    txtPartNo.text = _result.partnum;
    txtLotNo.text = _result.lotnum;
    txtQty.text = _result.tranqty.toString();
    txtIUM.text = _result.uom;
    _sysDate = _result.sysdate;
    _tranType = _result.trantype;
    _assmSeq = _result.assemblyseq.toString();
    _jobNo = _result.jobnum;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Reprint",
          textScaleFactor: textScaleFactor,
        ),
        automaticallyImplyLeading: false,
      ),
      body: ModalProgressHUD(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                // Row(
                //   children: <Widget>[
                //     Expanded(
                //       child: ListTile(
                //         title: TextFormField(
                //           decoration:
                //               InputDecoration(labelText: 'Transaction No.'),
                //           obscureText: false,
                //           keyboardType: TextInputType.text,
                //           autocorrect: false,
                //           controller: txtTrxNo,
                //           focusNode: _textFocusTrxNo,
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
                //         // Part
                //         child: Icon(Icons.camera_alt),
                //         onPressed: barcodeScanningTrxNo,
                //       ),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     )
                //   ],
                // ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Part Num'),
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
                          decoration: InputDecoration(labelText: 'Lot Num'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtLotNo,
                          enabled: true,
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
                              InputDecoration(labelText: 'From Seq Num'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtFromSeqNo,
                          focusNode: _textFocusFromSeqNo,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'To Seq Num'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtToSeqNo,
                          focusNode: _textFocusToSeqNo,
                        ),
                      ),
                    ),
                    // SizedBox(width: 10),
                    // SizedBox(
                    //   width: 54,
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       padding: EdgeInsets.zero,
                    //     ),
                    //     // Part
                    //     child: Icon(Icons.camera_alt),
                    //     onPressed: barcodeScanningPartNo,
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Batch Num'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtBatchNo,
                          focusNode: _textFocusBatchNo,
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
                //           decoration:
                //               InputDecoration(labelText: 'Quantity'),
                //           obscureText: false,
                //           keyboardType: TextInputType.number,
                //           autocorrect: false,
                //           controller: txtQty,
                //           focusNode: _textFocusQty,
                //         ),
                //       ),
                //     ),
                //     //SizedBox(width: 10),
                //     SizedBox(
                //       width: 100,
                //       child: ListTile(
                //         title: TextFormField(
                //           decoration: InputDecoration(labelText: 'UOM'),
                //           obscureText: false,
                //           keyboardType: TextInputType.text,
                //           autocorrect: false,
                //           controller: txtIUM,
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       width: 54,
                //       child: ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //           padding: EdgeInsets.zero,
                //         ),
                //         child: Icon(Icons.search),
                //         onPressed: triggerUOMDropDown,
                //       ),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     )
                //   ],
                // ),
                // Row(
                //   children: <Widget>[
                //     Expanded(
                //       child: ListTile(
                //         title: TextFormField(
                //           decoration:
                //               InputDecoration(labelText: 'No. of Label'),
                //           obscureText: false,
                //           keyboardType: TextInputType.number,
                //           autocorrect: false,
                //           controller: txtNoofLable,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 30),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            foregroundColor: Colors.white, // Text color
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Cancel',
                            textScaleFactor: textScaleFactor,
                          ),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 0),
                    Expanded(
                      child: ListTile(
                        title: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            foregroundColor: Colors.white, // Text color
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Retrieve',
                            textScaleFactor: textScaleFactor,
                          ),
                          onPressed: () async {
                            setState(() {
                              _saving = true;
                            });
                            List<dynamic> _result = await getReprintInfo(
                              txtPartNo.text,
                              txtLotNo.text,
                              txtToSeqNo.text,
                              txtFromSeqNo.text,
                              txtBatchNo.text,
                            );
                            if (_result[0] == false) {
                              _reprintList = _result[1];
                            } else {
                              showAlertPopup(context, 'Error',
                                  'Reprint List: ' + _result[1]);
                            }
                            setState(
                              () {
                                _saving = false;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: populateMaterialPickingList(context),
                  ),
                ),
              ],
            ),
          ),
          inAsyncCall: _saving),
    );
  }

  populateMaterialPickingList(BuildContext context) {
    int _rowCnt = 0;
    _rowCnt = _reprintList.reprintList.length;
    return ListView.builder(
      itemCount: _rowCnt,
      itemBuilder: _getReprintInfoListValue,
      padding: EdgeInsets.all(0.0),
    );
  }

  Widget _getReprintInfoListValue(BuildContext context, int index) {
    final item = _reprintList.reprintList[index];
    final partNum = item.partNum;
    final lotNum = item.lotNum;
    final fromSeqNo = item.fromSeq;
    final toSeqNo = item.toSeq;
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(47, 85, 156, .9)),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
              border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24),
              ),
            ),
            child: Icon(
              Icons.library_books,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Part: ' + (partNum ?? ''),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            children: [
              Row(
                children: [
                  Text(
                    'LotNum: ' + ('${lotNum}'),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'SeqNo: ' + ('${fromSeqNo} - ${toSeqNo}'),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            print("printer path: ${_globals.epiPrinterPath}");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReprintLabelDtl(item),
              ),
            );
          },
        ),
      ),
    );
  }

  // Future submitData() async {
  //   List<dynamic> _result;
  // }

  // Future submitData() async {
  //   List<dynamic> _result;

  //   if (txtLotNo.text != '' && _lotEnabled == true) {
  //     setState(() {
  //       _saving = true;
  //     });

  //     _result = await isPartLotExist(txtPartNo.text, txtLotNo.text);

  //     setState(() {
  //       _saving = false;
  //     });

  //     if (_result[0] == false) {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) =>
  //                   LotCreation(txtPartNo.text, txtLotNo.text),
  //               fullscreenDialog: true));
  //       return;
  //     }
  //   }

  //   setState(() {
  //     _saving = true;
  //   });

  //   _result = await postRePrintLabel(
  //       _sysDate,
  //       txtTrxNo.text,
  //       txtPartNo.text,
  //       _tranType,
  //       txtQty.text,
  //       txtIUM.text,
  //       txtLotNo.text,
  //       _jobNo,
  //       _assmSeq,
  //       txtNoofLable.text);

  //   setState(() {
  //     _saving = false;
  //   });

  //   if (_result[0] == false) {
  //     showAlertPopup(context, 'Error', 'Reprint : ' + _result[1]);
  //     return;
  //   }

  //   clearAllFields();
  // }

  void clearAllFields() {
    txtTrxNo.text = '';
    txtPartNo.text = '';
    txtQty.text = '0.00';
    txtIUM.text = '';
    txtLotNo.text = '';
    txtNoofLable.text = '1';

    _oldPartNo = '';
    _oldTrxNo = '';

    _sysDate = '';
    _tranType = '';
    _assmSeq = '';
    _jobNo = '';
  }

  Future barcodeScanningTrxNo() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();

      setState(() {
        txtTrxNo.text = barcode.rawContent;
        getTrxInfo();
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
}
