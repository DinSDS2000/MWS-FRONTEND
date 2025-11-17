import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/episitereceipt.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SiteReceiptList extends StatefulWidget {
  const SiteReceiptList({super.key});

  @override
  State<SiteReceiptList> createState() => _SitereceiptlistState();
}

class _SitereceiptlistState extends State<SiteReceiptList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _barcodeError = "";
  String _oldRefNo = '';
  bool _saving = false;

  Map<String, int> _map = {};
  DateTime selectedDate = DateTime.now();
  DateFormat formatter = DateFormat('dd/MM/yyyy');

  EpiSiteReceiptList? _listRef;

  var txtRefNo = new TextEditingController();
  var txtDONo = new TextEditingController();
  var txtDateRcv = new TextEditingController();
  var txtRcvdQty = new TextEditingController();

  FocusNode _textFocusRefNo = new FocusNode();

  @override
  void initState() {
    txtRefNo.addListener(onChangeRefNo);
    _textFocusRefNo.addListener(onChangeRefNo);
    txtDateRcv.text = formatter.format(selectedDate);
    txtRcvdQty.text = '0';

    _listRef = EpiSiteReceiptList(episitereceiptlist: [
      EpiSiteReceipt(
        token: "ABC123",
        company: "SVL",
        trandate: "2025-11-05",
        whsedescription: "Main Warehouse",
        bindescription: "Bin A1",
        jobnum: "JOB-001",
        partnum: "P-1001",
        partdescription: "Solar Panel 550W",
        tranqty: 20,
        uom: "EA",
        refno: "REF-001",
        seqno: "1",
        rcvdqty: 5,
        submitqty: 0,
        fullrcv: false,
      ),
      EpiSiteReceipt(
        token: "XYZ789",
        company: "SVL",
        trandate: "2025-11-03",
        whsedescription: "Sub Warehouse",
        bindescription: "Bin B3",
        jobnum: "JOB-002",
        partnum: "P-2002",
        partdescription: "Inverter 5kW",
        tranqty: 10,
        uom: "EA",
        refno: "REF-002",
        seqno: "2",
        rcvdqty: 2,
        submitqty: 0,
        fullrcv: false,
      ),
      EpiSiteReceipt(
        token: "LMN456",
        company: "SVL",
        trandate: "2025-10-29",
        whsedescription: "Main Warehouse",
        bindescription: "Bin C7",
        jobnum: "JOB-003",
        partnum: "P-3005",
        partdescription: "Mounting Bracket",
        tranqty: 50,
        uom: "SET",
        refno: "REF-003",
        seqno: "3",
        rcvdqty: 10,
        submitqty: 0,
        fullrcv: true,
      ),
    ]);

    super.initState();
  }

  void onChangeRefNo() {
    if (!_textFocusRefNo.hasFocus) {
      _oldRefNo = txtRefNo.text;
    } else {
      if (_oldRefNo != txtRefNo.text) {
        if (_listRef != null) {
          setState(() {
            _listRef?.episitereceiptlist.clear();
          });
        }

        getRef(txtRefNo.text);
      }
    }
  }

  Future getRef(String refnum) async {
    // List<dynamic> _result;

    // _result = await getEpiSiteReceiptRest(refnum);

    // if (_result[0] == false) {
    //   EpiSiteReceiptList _data = _result[1];

    //   txtRefNo.text = _data.episitereceiptlist[0].refno;
    // }
  }

  Future<void> _displayQtyToSubmitDialog(
    BuildContext context,
    String seqNo,
    String description,
    num rcvdQty,
  ) async {
    txtRcvdQty.text = rcvdQty.toString();
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Quantity Received:'),
          content: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Row(children: <Widget>[Expanded(child: Text(description))]),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    SizedBox(width: 60),
                    Expanded(
                      child: TextFormField(
                        controller: txtRcvdQty,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter Quantity To Submit",
                        ),
                      ),
                    ),
                    SizedBox(width: 60),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                bool success = false;

                for (int i = 0; i < _listRef!.episitereceiptlist.length; i++) {
                  String listSeqNo = _listRef!.episitereceiptlist[i].seqno;

                  if (listSeqNo == seqNo) {
                    num totalQty = num.parse(txtRcvdQty.text) +
                        _listRef!.episitereceiptlist[i].rcvdqty;

                    if (totalQty > _listRef!.episitereceiptlist[i].tranqty) {
                      showAlertPopup(
                        context,
                        'Error',
                        'Total submit quantity is more than received quantity.',
                      );
                    } else {
                      setState(() {
                        _listRef!.episitereceiptlist[i].submitqty = num.parse(
                          txtRcvdQty.text,
                        );
                        _listRef!.episitereceiptlist[i].fullrcv = false;
                      });

                      if (totalQty == _listRef!.episitereceiptlist[i].tranqty) {
                        _listRef!.episitereceiptlist[i].fullrcv = true;
                      }
                      success = true;
                      break;
                    }
                  }
                }
                if (success) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        txtDateRcv.text = formatter.format(selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Site Receipt List",
        ),
        automaticallyImplyLeading: false,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Ref No.'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtRefNo,
                          focusNode: _textFocusRefNo,
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
                        child: Icon(Icons.camera_alt),
                        onPressed: barcodeScanningRefNo,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Date Received'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtDateRcv,
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
                        child: Icon(Icons.date_range),
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'DO No.'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtDONo,
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
                        child: Icon(Icons.camera_alt),
                        onPressed: barcodeScanningRefNo,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: ElevatedButton(
                          onPressed: () async {
                            if (txtRefNo.text != '') {
                              setState(() {
                                _saving = true;
                              });

                              // Temporarily skip API call and file fetching
                              // List<dynamic> _result = await getEpiSiteReceiptRest(txtRefNo.text);
                              // await _listofFiles();

                              // Use your mock data already in _listRef
                              setState(() {
                                _saving = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Retrieve',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: new Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: populateSiteReceiptList(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  populateSiteReceiptList(BuildContext context) {
    int _rowCnt = 0;
    if (_listRef != null) {
      _rowCnt = _listRef!.episitereceiptlist.length;
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _rowCnt,
      itemBuilder: _getSiteReceiptListValue,
      padding: EdgeInsets.all(0.0),
    );
  }

  Widget _getSiteReceiptListValue(BuildContext context, int index) {
    String _listPartNum = '';
    String _listPartDesc = '';
    String _listWhse = '';
    String _listBin = '';
    num _listQty = 0.00;
    String _listUOM = '';
    String _listSeqNo = '';
    num _listRcvdQty = 0.00;
    num _qtyToSubmit = 0.00;
    bool _fullRcv = false;

    if (_listRef != null) {
      _listPartNum = _listRef!.episitereceiptlist[index].partnum;
      _listPartDesc = _listRef!.episitereceiptlist[index].partdescription;
      _listWhse = _listRef?.episitereceiptlist[index].whsedescription == null
          ? ' '
          : _listRef!.episitereceiptlist[index].whsedescription;
      _listBin = _listRef?.episitereceiptlist[index].bindescription == null
          ? ' '
          : _listRef!.episitereceiptlist[index].bindescription;
      _listQty = _listRef!.episitereceiptlist[index].tranqty;
      _listUOM = _listRef!.episitereceiptlist[index].uom;
      _listSeqNo = _listRef!.episitereceiptlist[index].seqno;
      _listRcvdQty = _listRef!.episitereceiptlist[index].rcvdqty;
      _qtyToSubmit = _listRef?.episitereceiptlist[index].submitqty == null
          ? 0
          : _listRef!.episitereceiptlist[index].submitqty;
      _fullRcv = _listRef!.episitereceiptlist[index].fullrcv;
    }

    return new Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _displayQtyToSubmitDialog(
              context,
              _listSeqNo,
              _listPartNum + ' : ' + _listPartDesc,
              _qtyToSubmit,
            );
          });
        },
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(47, 85, 156, .9)),
          child: ListTile(
            isThreeLine: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      cameraCapture(_listSeqNo);
                    },
                    child: Icon(Icons.add_a_photo, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      // String prefix = txtRefNo.text + '-' + _listSeqNo;
                      // //final foundFile = file.where((element) => element.toString().split('/').last.split('_').first == prefix).toList();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => AttachmentList(prefix),
                      //     fullscreenDialog: true,
                      //   ),
                      // ).then((value) {
                      //   _listofFiles();
                      // });
                    },
                    child: new Stack(
                      children: <Widget>[
                        Badge(
                          isLabelVisible: _map[_listSeqNo] != 0,
                          label: _map[_listSeqNo] == 0
                              ? null
                              : Text(
                                  _map[_listSeqNo].toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                          backgroundColor: Colors.green,
                          child: Icon(Icons.view_list, color: Colors.white),
                        ),
                        new Visibility(
                          visible: false, //_map[_listSeqNo] == 0 ? false: true,
                          child: new Positioned(
                            top: 2.0,
                            right: 2.0,
                            child: new Center(
                              child: new Text(
                                _map[_listSeqNo].toString(),
                                style: new TextStyle(
                                  color: Colors.green,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            title: Text(
              _listPartNum + ' : ' + _listPartDesc,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Qty Issued:',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Qty To Submit:',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Fully Received',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          _listQty.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          _qtyToSubmit.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: CheckboxListTile(
                          onChanged: null,
                          value: _fullRcv,
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // trailing:
            //     Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
            // onTap: () {
            // },
          ),
        ),
      ),
    );
  }

  Future cameraCapture(String seqNo) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) return; // user cancelled

    final bytes = await File(pickedFile.path).readAsBytes();
    final base64Image = base64Encode(bytes);

    print("Base64 Image: $base64Image");
    // try {
    //   String prefix = txtRefNo.text + '-' + seqNo;
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => CameraScreen(cameras, prefix)),
    //   ).then((value) {
    //     if (value != '') {
    //       _listofFiles();
    //     }
    //   });
    // } catch (e) {
    //   showAlertPopup(context, 'Error', '$e');
    // }
  }

  Future barcodeScanningRefNo() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtRefNo.text = barcode.rawContent;
        getRef(txtRefNo.text);
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
