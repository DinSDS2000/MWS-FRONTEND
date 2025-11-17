// ignore_for_file: deprecated_member_use

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/epiworkqueue.dart';
import 'package:flutter_epihhinventory/ui/epipages/prodworkqueue.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
  late EpiWorkQueueList _listWQ = EpiWorkQueueList(epiworkqueuelist: []);

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
            child: Container(
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
                            controller: txtEmpId,
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
                          onPressed: barcodeScanningEmpId,
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
                  //SizedBox(height: 30),
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
                          onPressed: retrieveWorkQueueList,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Retrieve',
                            textScaleFactor: textScaleFactor,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ]),
                  Row(
                    children: [
                      Expanded(
                        child: new Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                          child: SizedBox(
                            height: 300, // Set appropriate height
                            child: populateWQList(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          inAsyncCall: _saving),
    );
  }

  Future retrieveWorkQueueList() async {
    setState(() {
      _saving = true;
    });

    _listWQ = EpiWorkQueueList(epiworkqueuelist: []);
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
    _rowCnt = _listWQ.epiworkqueuelist.length;
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
                      new ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue, // Button background color
                          foregroundColor: Colors.white, // Text color
                        ),
                        child: Text('Batch'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProdWorkQueue(
                                  true, _listWQ.epiworkqueuelist[index]),
                            ),
                          ).then((value) {
                            if (value != 'C') {
                              removeItem(index);
                            }
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      new ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue, // Button background color
                          foregroundColor: Colors.white, // Text color
                        ),
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
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtEmpId.text = barcode.rawContent;
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
