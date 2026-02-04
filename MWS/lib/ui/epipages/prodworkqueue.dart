// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/data/classes/epireason.dart';
import 'package:flutter_epihhinventory/data/classes/epiworkqueue.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class ProdWorkQueue extends StatefulWidget {
  final bool isEndByBatch;
  final EpiWorkQueue epiworkqueue;

  ProdWorkQueue(this.isEndByBatch, this.epiworkqueue);

  ProdWorkQueueState createState() => ProdWorkQueueState();
}

class ProdWorkQueueState extends State<ProdWorkQueue> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _title = '';
  int _laborhedseq = 0;
  int _labordtlseq = 0;
  bool _saving = false;
  bool _byempvisible = false;

  var txtEmpId = new TextEditingController();
  var txtJobNo = new TextEditingController();
  var txtAsmNo = new TextEditingController();
  var txtOprNo = new TextEditingController();
  var txtResId = new TextEditingController();
  var txtResGroup = new TextEditingController();
  var txtOpCode = new TextEditingController();
  var txtTransQty = new TextEditingController();
  var txtClockInDate = new TextEditingController();
  var txtClockInTime = new TextEditingController();
  var txtNonConform = new TextEditingController();
  var resonCode = new TextEditingController();

  List<EpiReason> reasonItems = [];
  EpiReason? selectedReason;
  bool isLoadingReason = true;

  @override
  void initState() {
    super.initState();
    loadReasonList();

    if (widget.isEndByBatch == true) {
      _title = 'End Operation by Batch';
      txtEmpId.text = _globals.epiempid;
      _byempvisible = false;
    } else {
      _title = 'End Operation by Employee';
      txtEmpId.text = widget.epiworkqueue.empid;
      _byempvisible = true;
    }

    txtJobNo.text = widget.epiworkqueue.jobno;
    txtAsmNo.text = widget.epiworkqueue.asmno.toString();
    txtOprNo.text = widget.epiworkqueue.oprno.toString();
    txtResId.text = widget.epiworkqueue.resid;
    txtResGroup.text = widget.epiworkqueue.resgroupid;
    txtOpCode.text = widget.epiworkqueue.opcode;
    txtTransQty.text = widget.epiworkqueue.transqty.toString();
    txtClockInDate.text = widget.epiworkqueue.clockindate;
    txtClockInTime.text = widget.epiworkqueue.clockintime;
    _laborhedseq = widget.epiworkqueue.laborhedseq;
    _labordtlseq = widget.epiworkqueue.labordtlseq;
  }

  Future<void> loadReasonList() async {
    reasonItems = await getEpiReasonList2('S');

    setState(() {
      isLoadingReason = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          _title,
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
                              decoration: InputDecoration(labelText: 'Emp Id'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtEmpId,
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
                              decoration: InputDecoration(labelText: 'Job No.'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtJobNo,
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
                              decoration: InputDecoration(labelText: 'Asm No.'),
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              controller: txtAsmNo,
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
                              decoration: InputDecoration(labelText: 'Opr No.'),
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              controller: txtOprNo,
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
                                  InputDecoration(labelText: 'Resource ID'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtResId,
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
                                  InputDecoration(labelText: 'Resource Group'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtResGroup,
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
                                  InputDecoration(labelText: 'Operation Code'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtOpCode,
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
                                  InputDecoration(labelText: 'Trans Qty'),
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              controller: txtTransQty,
                              enabled: true,
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
                                  labelText: 'Nonconformance Quantity'),
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              controller: txtNonConform,
                              enabled: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: isLoadingReason
                                ? const CircularProgressIndicator()
                                : DropdownButtonFormField<EpiReason>(
                                    decoration: const InputDecoration(
                                      labelText: 'Nonconformance Reason',
                                    ),
                                    value: selectedReason,
                                    items: reasonItems
                                        .map(
                                          (item) => DropdownMenuItem<EpiReason>(
                                            value: item,
                                            child: Text(
                                                item.reasoncode), // or item.id
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedReason = value;
                                      });
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _byempvisible,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Clock In Date'),
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                controller: txtClockInDate,
                                enabled: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _byempvisible,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Clock In Time'),
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                controller: txtClockInTime,
                                enabled: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: ElevatedButton(
                            onPressed: () => Navigator.pop(context, 'C'),
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
                            onPressed: submitData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Button color
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'End Operation',
                              textScaleFactor: textScaleFactor,
                              style: TextStyle(color: Colors.white),
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

  Future submitData() async {
    List<dynamic> _result;

    setState(() {
      _saving = true;
    });

    if (_byempvisible == true) {
      _result = await postProdEndOperationByEmp(
        _laborhedseq.toString(),
        _labordtlseq.toString(),
        txtTransQty.text,
        nonConQty: txtNonConform.text,
        reason: selectedReason?.reasoncode,
      );
    } else {
      _result = await postProdEndOperationByBatch(txtEmpId.text, txtJobNo.text,
          txtAsmNo.text, txtOprNo.text, txtResId.text, txtTransQty.text);
    }

    setState(() {
      _saving = false;
    });

    if (_result[0] == false) {
      showAlertPopup(
          context, 'Error', 'Process Production End Operation : ' + _result[1]);
      return;
    }

    Navigator.pop(context, '');
  }
}
