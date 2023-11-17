import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/data/classes/episplitmergeuom.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:native_widgets/native_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../constants.dart';

class SplitMergeUOMDtl extends StatefulWidget {
  final String trxtype;
  final String proccode;
  final String partnum;
  final String whsecode;
  final String binnum;
  final String lotnum;
  final String qty;
  final String uom;
  final String nooflabel;
  final EpiSplitMergeUOMList episplitmergeuomlist;

  SplitMergeUOMDtl(
      this.trxtype,
      this.proccode,
      this.partnum,
      this.whsecode,
      this.binnum,
      this.lotnum,
      this.qty,
      this.uom,
      this.nooflabel,
      this.episplitmergeuomlist);

  SplitMergeUOMDtlState createState() => SplitMergeUOMDtlState();
}

class SplitMergeUOMDtlState extends State<SplitMergeUOMDtl> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _saving = false;
  String _trxtype = '';
  String _proccode = '';
  String _partnum = '';
  String _whsecode = '';
  String _binnum = '';
  String _lotnum = '';
  String _qty = '';
  String _uom = '';
  String _nooflabel = '';
  EpiSplitMergeUOMList _listdata;

  @override
  void initState() {
    super.initState();

    _trxtype = widget.trxtype;
    _proccode = widget.proccode;
    _partnum = widget.partnum;
    _whsecode = widget.whsecode;
    _binnum = widget.binnum;
    _lotnum = widget.lotnum;
    _qty = widget.qty;
    _uom = widget.uom;
    _nooflabel = widget.nooflabel;
    _listdata = widget.episplitmergeuomlist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          _trxtype,
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
                    DataTable(
                      columns: [
                        DataColumn(
                          label: Text(
                            "Quantity",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            "UOM",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text(
                            "On Hand",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          numeric: false,
                        ),
                      ],
                      rows: _listdata.episplitmergeuomlist
                          .map(
                            (_rowdata) => DataRow(cells: [
                              DataCell(
                                TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (text) {
                                    //print("First text field: $text");
                                    _rowdata.qty = double.parse(text);
                                  },
                                ),
                              ),
                              DataCell(
                                Text(_rowdata.ium),
                              ),
                              DataCell(
                                Text(_rowdata.onhandqty.toString()),
                              ),
                            ]),
                          )
                          .toList(),
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

  Future submitData() async {
    List<dynamic> _result;

    // Update PO Receiot
    setState(() {
      _saving = true;
    });

    var _count = _listdata.episplitmergeuomlist.length;
    if (_count != 0) {
      _result = await postSplitMergeUOM(_proccode, _partnum, _whsecode, _binnum,
          _lotnum, _qty, _uom, this._nooflabel, _listdata);

      setState(() {
        _saving = false;
      });

      if (_result[0] == false) {
        showAlertPopup(context, 'Error', 'Split/Merge UOM: ' + _result[1]);
        return;
      }
    } else {
      setState(() {
        _saving = false;
      });

      showAlertPopup(context, 'Error', 'Split/Merge UOM: Invalid data found!');
      return;
    }

    Navigator.pop(context, 'A');
  }
}
