// ignore_for_file: deprecated_member_use

import 'package:barcode_scan2/model/scan_result.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/data/classes/epidocustinfo.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constants.dart';

class DeliveryTracking extends StatefulWidget {
  DeliveryTracking();

  DeliveryTrackingState createState() => DeliveryTrackingState();
}

class DeliveryTrackingState extends State<DeliveryTracking> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _barcodeError = "";
  bool _saving = false;

  var txtDONo = new TextEditingController();

  FocusNode _textFocusDONo = new FocusNode();

  EpiDOCustInfo? _doCustInfo;

  String _oldDONo = '';

  @override
  void initState() {
    txtDONo.addListener(onChangeDONo);
    _textFocusDONo.addListener(onChangeDONo);

    super.initState();
  }

  void onChangeDONo() {
    if (!_textFocusDONo.hasFocus && txtDONo.text == '') {
      _doCustInfo = null;
    }
    if (!_textFocusDONo.hasFocus && txtDONo.text != '') {
      if (_oldDONo != txtDONo.text) {
        getDOCustInfo();
        _oldDONo = txtDONo.text;
      }
    }
  }

  Future getDOCustInfo() async {
    setState(() {
      _saving = true;
    });

    if (txtDONo.text != '') {
      _doCustInfo = await getEpiDOCustInfo(txtDONo.text);

      if (_doCustInfo?.company == null) {
        showAlertPopup(context, 'Error', 'Customer information not found');
        clearAllFields();
      }
    } else {
      _doCustInfo = null;
    }

    setState(() {
      _saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Delivery Tracking",
          textScaleFactor: textScaleFactor,
        ),
        automaticallyImplyLeading: false,
      ),
      body: ModalProgressHUD(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'DO No.'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtDONo,
                          focusNode: _textFocusDONo,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 54,
                      child: ElevatedButton(
                        onPressed: barcodeScanningDONo,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
                Expanded(
                  child: populateDOCustInfo(context),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context, true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            disabledBackgroundColor:
                                Colors.grey, // Disabled button color
                            padding: EdgeInsets.zero, // Removes extra padding
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
                          onPressed: () {
                            showConfirmationDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            disabledBackgroundColor:
                                Colors.grey, // Disabled button color
                            padding: EdgeInsets.zero, // Removes extra padding
                          ),
                          child: Text(
                            'Ok',
                            textScaleFactor: textScaleFactor,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          inAsyncCall: _saving),
    );
  }

  populateDOCustInfo(BuildContext context) {
    int _rowCnt = 0;
    if (_doCustInfo != null) {
      _rowCnt = 1;
    }
    return ListView.builder(
      itemCount: _rowCnt,
      itemBuilder: _buildItemsForDOCustInfo,
      padding: EdgeInsets.all(0.0),
    );
  }

  Widget _buildItemsForDOCustInfo(BuildContext context, int index) {
    String _custName = '';
    String _custAddress = '';

    if (_doCustInfo != null) {
      _custName = _doCustInfo?.custname ?? '';
      _custAddress = _doCustInfo?.custaddress ?? '';
    }

    if (_custName != '') {
      _custName = '\n' + _custName;
    }

    if (_custAddress != '') {
      var strSplitAddress = _custAddress.split('~');

      _custAddress = '';
      for (var add in strSplitAddress) {
        _custAddress += '\n' + add;
      }
    }

    return new Card(
        child: ListTile(
      title: Text(_custName,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      subtitle: Text(_custAddress, style: TextStyle(fontSize: 18)),
    ));
  }

  Future submitData() async {
    List<dynamic> _result;

    setState(() {
      _saving = true;
    });

    _result = await postPerformReceiveTimeStamp(txtDONo.text);

    setState(() {
      _saving = false;
    });

    if (_result[0] == false) {
      showAlertPopup(
          context, 'Error', 'Perform Receive Time Stamp  : ' + _result[1]);
      return;
    }

    //Navigator.pop(context, true);
    clearAllFields();
  }

  void clearAllFields() {
    txtDONo.text = '';

    _oldDONo = '';
  }

  Future barcodeScanningDONo() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtDONo.text = barcode.rawContent;
        getDOCustInfo();
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

  void showConfirmationDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("Cancel"),
    );

    Widget continueButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        submitData();
      },
      child: const Text("Confirm"),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Would you like to confirm to post?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
