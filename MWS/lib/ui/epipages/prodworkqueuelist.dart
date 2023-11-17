import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/epiworkqueue.dart';
import 'package:flutter_epihhinventory/ui/epipages/prodworkqueue.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:native_widgets/native_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class ProdWorkQueueList extends StatefulWidget {
  ProdWorkQueueList();

  ProdWorkQueueListState createState() => ProdWorkQueueListState();
}

class ProdWorkQueueListState extends State<ProdWorkQueueList> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _barcodeError = '';
  String _oldAsmNo = '';
  String _oldOprNo = '';
  bool _saving = false;
  EpiWorkQueueList _listWQ;

  var txtEmpId = new TextEditingController();
  var txtJobNo = new TextEditingController();
  var txtAsmNo = new TextEditingController();
  var txtOprNo = new TextEditingController();
  var txtResId = new TextEditingController();

  FocusNode _textFocusJobNo = new FocusNode();
  FocusNode _textFocusAsmSeq = new FocusNode();
  FocusNode _textFocusOprSeq = new FocusNode();

  @override
  void initState() {
    txtJobNo.addListener(onChangeJobNo);
    _textFocusJobNo.addListener(onChangeJobNo);

    txtAsmNo.addListener(onChangeAsmSeq);
    _textFocusAsmSeq.addListener(onChangeAsmSeq);

    txtOprNo.addListener(onChangeOprSeq);
    _textFocusOprSeq.addListener(onChangeOprSeq);

    super.initState();
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
        if (txtAsmNo.text != '') {}
      }
    }
  }

  void onChangeOprSeq() {
    if (!_textFocusOprSeq.hasFocus) {
      _oldOprNo = txtOprNo.text;
    } else {
      if (_oldOprNo != txtOprNo.text) {
        if (txtOprNo.text != '') {}
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Work Queue List",
          textScaleFactor: textScaleFactor,
        ),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Employee Id'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtEmpId,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 54,
                      child: RaisedButton(
                        // Job No.
                        child: Icon(Icons.camera_alt),
                        onPressed: barcodeScanningEmpId,
                      ),
                    ),
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
                      child: RaisedButton(
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
                      child: RaisedButton(
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
                      child: RaisedButton(
                        // Mtl No.
                        child: Icon(Icons.camera_alt),
                        onPressed: barcodeScanningOprNo,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Resource ID'),
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
                      child: RaisedButton(
                        // Asm No.
                        child: Icon(Icons.camera_alt),
                        onPressed: barcodeScanningResId,
                      ),
                    ),
                  ],
                ),
                //SizedBox(height: 30),
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
                        onPressed: () => {Navigator.pop(context, true)},
                      ),
                    ),
                  ),
                  SizedBox(width: 0),
                  Expanded(
                    child: ListTile(
                      title: NativeButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          'Retrieve',
                          textScaleFactor: textScaleFactor,
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        disabledColor: Colors.grey,
                        onPressed: retrieveWorkQueueList,
                      ),
                    ),
                  )
                ]),
                Expanded(
                  child: new Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: populateWQList(context)),
                ),
              ],
            ),
          ),
          inAsyncCall: _saving),
    );
  }

  Future retrieveWorkQueueList() async {
    setState(() {
      _saving = true;
    });

    _listWQ = null;
    List<dynamic> _result;

    _result = await getEpiWorkGroupList(txtEmpId.text, txtJobNo.text,
        txtAsmNo.text, txtOprNo.text, txtResId.text);
    if (_result[0] == false) {
      _listWQ = _result[1];
    } else {
      showAlertPopup(
          context, 'Error', 'Production Work Queue List : ' + _result[1]);
    }
    setState(() {
      _saving = false;
    });
  }

  populateWQList(BuildContext context) {
    int _rowCnt = 0;
    if (_listWQ != null) {
      _rowCnt = _listWQ.epiworkqueuelist.length;
    }
    return ListView.builder(
      itemCount: _rowCnt,
      itemBuilder: _getWQListValue,
      padding: EdgeInsets.all(0.0),
    );
  }

  Widget _getWQListValue(BuildContext context, int index) {
    String _listJobNo = '';
    String _listAsmNo = '';
    String _listOprNo = '';
    String _listOpCode = '';
    String _listResGroupId = '';
    String _listResId = '';
    String _listEmpId = '';
    String _listEmpName = '';
    String _listClockInDate = '';
    String _listClockInTime = '';
    String _listTransQty = '';

    if (_listWQ != null) {
      _listJobNo = _listWQ.epiworkqueuelist[index].jobno;
      _listAsmNo = _listWQ.epiworkqueuelist[index].asmno.toString();
      _listOprNo = _listWQ.epiworkqueuelist[index].oprno.toString();
      _listOpCode = _listWQ.epiworkqueuelist[index].opcode;
      _listResGroupId = _listWQ.epiworkqueuelist[index].resgroupid;
      _listResId = _listWQ.epiworkqueuelist[index].resid;
      _listEmpId = _listWQ.epiworkqueuelist[index].empid;
      _listEmpName = _listWQ.epiworkqueuelist[index].empname;
      _listClockInDate = _listWQ.epiworkqueuelist[index].clockindate;
      _listClockInTime = _listWQ.epiworkqueuelist[index].clockintime;
      _listTransQty = _listWQ.epiworkqueuelist[index].transqty.toString();
    }
    return new Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(47, 85, 156, .9)),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Icon(Icons.work_outline, color: Colors.white),
          ),
          title: Text(
            'Job No.: ' + _listJobNo + ' / ' + _listAsmNo + ' / ' + _listOprNo,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  //Icon(Icons.linear_scale, color: Colors.yellowAccent),
                  Text('Employee: ' + _listEmpId + ' - ' + _listEmpName,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: <Widget>[
                  //Icon(Icons.linear_scale, color: Colors.yellowAccent),
                  Text('Op Code: ' + _listOpCode + ' / Qty: ' + _listTransQty,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: <Widget>[
                  //Icon(Icons.linear_scale, color: Colors.yellowAccent),
                  Text(
                      'Res Group: ' +
                          _listResGroupId +
                          ' / Res Id: ' +
                          _listResId,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: <Widget>[
                  //Icon(Icons.linear_scale, color: Colors.yellowAccent),
                  Text('Clock In Date: ' + _listClockInDate,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: <Widget>[
                  //Icon(Icons.linear_scale, color: Colors.yellowAccent),
                  Text('Clock In Time: ' + _listClockInTime,
                      style: TextStyle(color: Colors.white)),
                ],
              )
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('End Operation'),
                    content: Text(
                        'Do you want to end the operation by Employee or Batch?',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    actions: <Widget>[
                      new FlatButton(
                        color: Colors.blue,
                        child: new Text('Batch'),
                        onPressed: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProdWorkQueue(true,
                                          _listWQ.epiworkqueuelist[index])))
                              .then((value) {
                            //print(value);
                            if (value != 'C') {
                              //retrieveWorkQueueList();
                              removeItem(index);
                            }
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      new FlatButton(
                        color: Colors.blue,
                        child: new Text('Employee'),
                        onPressed: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProdWorkQueue(false,
                                          _listWQ.epiworkqueuelist[index])))
                              .then((value) {
                            //print(value);
                            if (value != 'C') {
                              //retrieveWorkQueueList();
                              removeItem(index);
                            }
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }

  void removeItem(int index) {
    setState(() {
      _listWQ.epiworkqueuelist.removeAt(index);
    });
  }

  Future barcodeScanningEmpId() async {
    _barcodeError = '';
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        txtEmpId.text = barcode;
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

  Future barcodeScanningJobNo() async {
    _barcodeError = '';
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        if (splitJobNo(barcode) == false) {
          txtJobNo.text = barcode;
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

  Future barcodeScanningAsmNo() async {
    _barcodeError = '';
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        txtAsmNo.text = barcode;
        // getJobMtl();
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

  Future barcodeScanningOprNo() async {
    _barcodeError = '';
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        txtOprNo.text = barcode;
        // getJobMtl();
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

  Future barcodeScanningResId() async {
    _barcodeError = '';
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        txtResId.text = barcode;
        // getJobMtl();
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
