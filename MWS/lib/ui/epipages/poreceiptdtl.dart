// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/epipart.dart';
import 'package:flutter_epihhinventory/data/classes/epiporeceiptdtl.dart';
import 'package:flutter_epihhinventory/data/classes/epiusercodes.dart';
import 'package:flutter_epihhinventory/ui/epipages/lotcreation.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:flutter_epihhinventory/utils/validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class POReceiptDtl extends StatefulWidget {
  final String packno;
  final EpiPOReceiptDtl epiporeceiptdtl;

  POReceiptDtl(this.packno, this.epiporeceiptdtl);

  POReceiptDtlState createState() => POReceiptDtlState();
}

class POReceiptDtlState extends State<POReceiptDtl> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<UOM> _uoms = List<UOM>.empty(growable: true);

  String _barcodeError = "";
  bool _saving = false;
  bool _lotEnabled = false;
  String _packno = '';
  String _tranType = '';
  bool _isLoading = false;
  bool headerExists = true;
  List<UserCodes> userCodesList = [];
  List<UserCodes> lorryCodesList = [];

  var txtPartNo = new TextEditingController();
  var txtExemptionNo = new TextEditingController();
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
  var txtActualQty = new TextEditingController();

  FocusNode _textFocusWhse = new FocusNode();
  FocusNode _textFocusQty = new FocusNode();

  @override
  void initState() {
    _loadTranType();
    initPageData();
    txtWhse.addListener(onChangeWhse);
    _textFocusWhse.addListener(onChangeWhse);

    txtQty.addListener(onChangeQty);
    _textFocusQty.addListener(onChangeQty);

    super.initState();

    _uoms.add(new UOM('0', 'Not found'));

    _packno = widget.packno;
    txtPartNo.text = widget.epiporeceiptdtl.partnum;
    txtPartDesc.text = widget.epiporeceiptdtl.partdesc;
    txtExemptionNo.text = widget.epiporeceiptdtl.exemptionno ?? '';
    /* txtWhse.text = widget.epiporeceiptdtl.whse;
    txtBin.text = widget.epiporeceiptdtl.bin;
    txtLotNo.text = widget.epiporeceiptdtl.lotnum; */

    txtQty.text = '1';
    txtNoofLable.text = '1';

    loadPartInfo();
  }

  Future<void> _loadTranType() async {
    String tranType = await getPORelTranType(
      widget.epiporeceiptdtl.ponum,
      widget.epiporeceiptdtl.poline,
      widget.epiporeceiptdtl.polinerel,
    );

    setState(() {
      _tranType = tranType;
    });
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

  Future<List<UserCodes>> _loadUserCodes(String codeId) async {
    setState(() {
      _isLoading = true; // Turn on loader spinner
    });

    try {
      UserCodesResponse response = await getUserCodes(codeTypeId: codeId);

      if (response.success && response.value.isNotEmpty) {
        print(
            "$codeId Loaded: ${response.value.map((e) => 'ID: ${e.codeId} - Desc: ${e.codeDesc}').toList()}");
        return response.value; // Return the fetched array directly
      } else {
        print(response.errors.isNotEmpty
            ? response.errors.first
            : 'No records found.');
      }
    } catch (e) {
      print('Failed loading data for $codeId: $e');
    } finally {
      setState(() {
        _isLoading = false; // Turn off loader spinner
      });
    }
    return []; // Return empty list if request fails
  }

  Future<void> initPageData() async {
    setState(() {
      _isLoading = true; // Turn on HUD loader spinner overlay
    });

    try {
      // 1. STEP ONE: Check if the header exists right away
      headerExists = await checkHeaderExist(
        packSlip: widget.packno,
        vendorNum: widget.epiporeceiptdtl.vendornum,
        purPoint: '', // Pass default value or variable
      );

      if (headerExists) {
        print("Header exists! Skipping user and lorry code download.");

        // Optional: Put any logic here that needs to run when the record already exists
        // (e.g., loading line details instead)

        return; // 🛑 EXIT EARLY: This stops the function here. The codes below will not run.
      }

      // 2. STEP TWO: If header does NOT exist, download the lists in parallel
      print("Header does not exist. Fetching driver and lorry lists...");

      final results = await Future.wait([
        _loadUserCodes('DriverName'),
        _loadUserCodes('LorryNo'),
      ]);

      setState(() {
        userCodesList = results[0];
        lorryCodesList = results[1];
      });
    } catch (e) {
      print('Error executing page load pipeline: $e');
    } finally {
      setState(() {
        _isLoading = false; // Turn off HUD loader spinner overlay
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
                                  InputDecoration(labelText: 'Exemption No.'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtExemptionNo,
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
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Actual Quantity'),
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              controller: txtActualQty,
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
                                  InputDecoration(labelText: 'Warehouse'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtWhse,
                              focusNode: _textFocusWhse,
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
                            // Job No.
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningWhse,
                          ),
                        ),
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
                        // SizedBox(
                        //   width: 64,
                        //   child: ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //       padding: EdgeInsets.zero,
                        //     ),
                        //     child: Text(
                        //       'Next Lot',
                        //       textScaleFactor: textScaleFactor,
                        //       style: TextStyle(
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //     //color: Colors.blue,
                        //     //disabledColor: Colors.grey,
                        //     onPressed: genLot,
                        //   ),
                        // ),
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
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Autocomplete<UserCodes>(
                              // Displays the clear text description inside the input box when selected
                              displayStringForOption: (UserCodes code) =>
                                  code.codeDesc,

                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<UserCodes>.empty();
                                }
                                // Filters your stored userCodesList locally by ID or Description
                                return userCodesList.where((UserCodes code) {
                                  return code.codeId.toLowerCase().contains(
                                          textEditingValue.text
                                              .toLowerCase()) ||
                                      code.codeDesc.toLowerCase().contains(
                                          textEditingValue.text.toLowerCase());
                                });
                              },

                              // Capture item when clicked to save properties locally
                              onSelected: (UserCodes selection) {
                                setState(() {
                                  txtDriverName.text = selection.codeDesc;
                                  txtDriverIC.text = selection.codeId;
                                });
                              },

                              fieldViewBuilder: (context, textEditingController,
                                  focusNode, onFieldSubmitted) {
                                focusNode.onKeyEvent =
                                    null; // Resets key event mapping blocks
                                focusNode
                                    .unfocus(); // Clear active states if needed

                                return Focus(
                                  onFocusChange: (hasFocus) {
                                    if (!hasFocus) {
                                      onFieldSubmitted(); // Closes dropdown overlay instantly on unfocus
                                    }
                                  },
                                  child: TextFormField(
                                    enabled: !headerExists,
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                    decoration: const InputDecoration(
                                      labelText: 'Driver Name',
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  137, 0, 0, 0))),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue)),
                                    ),
                                  ),
                                );
                              },

                              optionsViewBuilder:
                                  (context, onSelected, options) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 4.0,
                                    color: Colors.grey[850],
                                    child: Container(
                                      width: 300,
                                      constraints:
                                          const BoxConstraints(maxHeight: 250),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final UserCodes option =
                                              options.elementAt(index);
                                          return ListTile(
                                            title: Text(
                                              option.codeDesc,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                            subtitle: Text(
                                              option.codeId,
                                              style: const TextStyle(
                                                  color: Colors.white60),
                                            ),
                                            onTap: () {
                                              onSelected(option);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.camera_alt),
                            onPressed: barcodeScanningDriverName,
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
                                  InputDecoration(labelText: 'Driver IC'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtDriverIC,
                              enabled: !headerExists,
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
                            onPressed: barcodeScanningDriverIc,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Autocomplete<UserCodes>(
                              // Displays the ID code (e.g., Plate Number) inside the text box when selected
                              displayStringForOption: (UserCodes code) =>
                                  code.codeDesc,

                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<UserCodes>.empty();
                                }
                                // Filters your stored lorryCodesList locally by ID or Description
                                return lorryCodesList.where((UserCodes code) {
                                  return code.codeId.toLowerCase().contains(
                                          textEditingValue.text
                                              .toLowerCase()) ||
                                      code.codeDesc.toLowerCase().contains(
                                          textEditingValue.text.toLowerCase());
                                });
                              },

                              // Capture item when clicked to save properties locally
                              onSelected: (UserCodes selection) {
                                setState(() {
                                  txtLorry.text = selection
                                      .codeDesc; // Assigns selected Lorry plate/ID directly
                                });
                              },

                              fieldViewBuilder: (context, textEditingController,
                                  focusNode, onFieldSubmitted) {
                                focusNode.onKeyEvent =
                                    null; // Resets key event mapping blocks
                                focusNode
                                    .unfocus(); // Clear active states if needed

                                return Focus(
                                  onFocusChange: (hasFocus) {
                                    if (!hasFocus) {
                                      onFieldSubmitted(); // Closes dropdown overlay instantly on unfocus
                                    }
                                  },
                                  child: TextFormField(
                                    enabled: !headerExists,
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                    decoration: const InputDecoration(
                                      labelText: 'Lorry',
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  137, 0, 0, 0))),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue)),
                                    ),
                                  ),
                                );
                              },

                              optionsViewBuilder:
                                  (context, onSelected, options) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 4.0,
                                    color: Colors.grey,
                                    child: Container(
                                      width: 300,
                                      constraints:
                                          const BoxConstraints(maxHeight: 250),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final UserCodes option =
                                              options.elementAt(index);
                                          return ListTile(
                                            title: Text(
                                              option.codeId,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                            subtitle: Text(
                                              option.codeDesc,
                                              style: const TextStyle(
                                                  color: Colors.white60),
                                            ),
                                            onTap: () {
                                              onSelected(option);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.camera_alt),
                            onPressed: barcodeScanningLorry,
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
                            onPressed: submitData,
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
      print("LOTTT: ${txtLotNo.text}");
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
          txtActualQty.text.isEmpty ? null : txtActualQty.text,
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

    String legalNumber = "";
    try {
      if (_result.length > 1 && _result[1] != null) {
        var rawData = _result[1];

        // 1. If it's a raw JSON text string, decode it into a map structure first
        if (rawData is String) {
          var parsedJson = json.decode(rawData);
          legalNumber = parsedJson['LegalNumber'] ?? 'Unknown';
        } else {
          // 2. If it's already an active Map object data type container
          legalNumber = rawData['LegalNumber'] ?? 'Unknown';
        }
      } else {
        legalNumber = 'Processed';
      }
    } catch (e) {
      print("Extraction Error: $e");
      legalNumber = 'Processed';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              SizedBox(width: 10),
              Text('Receipt Successful'),
            ],
          ),
          content: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16), // Default style for standard text
              children: <TextSpan>[
                const TextSpan(text: 'The Legal Number generated is:\n'),
                TextSpan(
                  text: legalNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, // Makes the legal number bold
                    fontSize: 18, // Slightly larger to make it stand out
                    color: Colors
                        .blueAccent, // Optional: add color accent to make it pop
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.pop(context, 'A');
              },
            ),
          ],
        );
      },
    );
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
}
