import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/epiworkqueue.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:native_widgets/native_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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

  @override
  void initState() {
    super.initState();

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
                              'End Operation',
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

  Future submitData() async {
    List<dynamic> _result;

    setState(() {
      _saving = true;
    });

    if (_byempvisible == true) {
      _result = await postProdEndOperationByEmp(
          _laborhedseq.toString(), _labordtlseq.toString(), txtTransQty.text);
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
