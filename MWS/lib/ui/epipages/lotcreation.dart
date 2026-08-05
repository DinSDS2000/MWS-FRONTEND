// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/data/classes/epipart.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constants.dart';

class LotCreation extends StatefulWidget {
  final String partno;
  final String lotno;

  LotCreation(this.partno, this.lotno);

  LotCreationState createState() => LotCreationState();
}

class LotCreationState extends State<LotCreation> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _saving = false;
  bool _batchEnabled = false;
  bool _mfgBatchEnabled = false;
  bool _mfglotEnabled = false;
  bool _heatEnabled = false;
  bool _firmwareEnabled = false;
  bool _beforeDtEnabled = false;
  bool _mfgDtEnabled = false;
  bool _cureDtEnabled = false;
  bool _expDtEnabled = false;

  var txtNoofLable = new TextEditingController();
  var txtBatchNo = new TextEditingController();
  var txtMfgBatchNo = new TextEditingController();
  var txtMfgLotNo = new TextEditingController();
  var txtHeat = new TextEditingController();
  var txtFirmware = new TextEditingController();
  var txtBestBeforeDt = new TextEditingController();
  var txtOrigMfgDt = new TextEditingController();
  var txtCureDt = new TextEditingController();
  var txtExpiryDt = new TextEditingController();

  @override
  initState() {
    super.initState();
    print("LOTNUM: ${widget.lotno}");
    txtNoofLable.text = '1';
    loadPartInfo();
  }

  loadPartInfo() async {
    EpiPart _data = await getEpiPart(widget.partno);

    setState(() {
      _batchEnabled = _data.attbatch != 'N' ? true : false;
      _mfgBatchEnabled = _data.attmfgbatch != 'N' ? true : false;
      _mfglotEnabled = _data.attmfglot != 'N' ? true : false;
      _heatEnabled = _data.attheat != 'N' ? true : false;
      _firmwareEnabled = _data.attfirmware != 'N' ? true : false;
      _beforeDtEnabled = _data.attbeforedt != 'N' ? true : false;
      _mfgDtEnabled = _data.attmfgdt != 'N' ? true : false;
      _cureDtEnabled = _data.attcuredt != 'N' ? true : false;
      _expDtEnabled = _data.attexpdt != 'N' ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Lot Creation",
          textScaleFactor: textScaleFactor,
        ),
        automaticallyImplyLeading: false,
      ),
      body: ModalProgressHUD(
          child: SafeArea(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20),
                ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(labelText: 'No. of Label'),
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    controller: txtNoofLable,
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(labelText: 'Batch'),
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    controller: txtBatchNo,
                    enabled: _batchEnabled,
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(labelText: 'Mfg Batch'),
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    controller: txtMfgBatchNo,
                    enabled: _mfgBatchEnabled,
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(labelText: 'Mfg Lot'),
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    controller: txtMfgLotNo,
                    enabled: _mfglotEnabled,
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(labelText: 'Heat'),
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    controller: txtHeat,
                    enabled: _heatEnabled,
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(labelText: 'Firmware'),
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    controller: txtFirmware,
                    enabled: _firmwareEnabled,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Best Before'),
                          obscureText: false,
                          keyboardType: TextInputType.datetime,
                          autocorrect: false,
                          controller: txtBestBeforeDt,
                          enabled: _beforeDtEnabled,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 54,
                      child: ElevatedButton(
                        // Calendar.
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero, // Removes default padding
                        ),
                        child: Center(child: Icon(Icons.calendar_today)),
                        onPressed: () {
                          if (_beforeDtEnabled == true) {
                            _selectBestBeforeDate(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Orig Mfg'),
                          obscureText: false,
                          keyboardType: TextInputType.datetime,
                          autocorrect: false,
                          controller: txtOrigMfgDt,
                          enabled: _mfgDtEnabled,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 54,
                      child: ElevatedButton(
                        // Calendar.
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero, // Removes default padding
                        ),
                        child: Icon(Icons.calendar_today),
                        onPressed: () {
                          if (_mfgDtEnabled == true) {
                            _selectOrigMfgDate(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Cure'),
                          obscureText: false,
                          keyboardType: TextInputType.datetime,
                          autocorrect: false,
                          controller: txtCureDt,
                          enabled: _cureDtEnabled,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 54,
                      child: ElevatedButton(
                        // Calendar.
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero, // Removes default padding
                        ),
                        child: Icon(Icons.calendar_today),
                        onPressed: () {
                          if (_cureDtEnabled == true) {
                            _selectCureDate(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Expiry'),
                          obscureText: false,
                          keyboardType: TextInputType.datetime,
                          autocorrect: false,
                          controller: txtExpiryDt,
                          enabled: _expDtEnabled,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 54,
                      child: ElevatedButton(
                        // Calendar.
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero, // Removes default padding
                        ),
                        child: Icon(Icons.calendar_today),
                        onPressed: () {
                          if (_expDtEnabled == true) {
                            _selectExpiryDate(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: ElevatedButton(
                          onPressed: () async {
                            // print('${widget.partno} : ${widget.lotno}');
                            Navigator.pop(context, true);
                          },
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
                            'Create Lot',
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

  Future<Null> _selectBestBeforeDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        keyboardType: TextInputType.datetime,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000, 1),
        lastDate: DateTime(2100));
    setState(() {
      txtBestBeforeDt.text = DateFormat("yyyy-MM-dd").format(picked!);
    });
  }

  Future<Null> _selectOrigMfgDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        keyboardType: TextInputType.datetime,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000, 1),
        lastDate: DateTime(2100));
    setState(() {
      txtOrigMfgDt.text = DateFormat("yyyy-MM-dd").format(picked!);
    });
  }

  Future<Null> _selectCureDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        keyboardType: TextInputType.datetime,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000, 1),
        lastDate: DateTime(2100));
    setState(() {
      txtCureDt.text = DateFormat("yyyy-MM-dd").format(picked!);
    });
  }

  Future<Null> _selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        keyboardType: TextInputType.datetime,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000, 1),
        lastDate: DateTime(2100));
    setState(() {
      txtExpiryDt.text = DateFormat("yyyy-MM-dd").format(picked!);
    });
  }

  Future submitData() async {
    List<dynamic> _result;

    setState(() {
      _saving = true;
    });

    _result = await postCreateLot(
        widget.partno,
        widget.lotno,
        '',
        txtBatchNo.text,
        txtMfgBatchNo.text,
        txtMfgLotNo.text,
        txtHeat.text,
        txtFirmware.text,
        txtBestBeforeDt.text,
        txtOrigMfgDt.text,
        txtCureDt.text,
        txtExpiryDt.text,
        txtNoofLable.text);

    setState(() {
      _saving = false;
    });

    if (_result[0] == false) {
      showAlertPopup(context, 'Error', 'Process Lot Creation : ' + _result[1]);
      return;
    }

    Navigator.pop(context, true);
  }
}
