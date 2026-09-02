// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/epigetlot.dart';
import 'package:flutter_epihhinventory/data/classes/epipart.dart';
import 'package:flutter_epihhinventory/ui/epipages/lotcreation.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:flutter_epihhinventory/utils/validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class QtyAdjustment extends StatefulWidget {
  QtyAdjustment();

  QtyAdjustmentState createState() => QtyAdjustmentState();
}

class QtyAdjustmentState extends State<QtyAdjustment> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> dropDownBins = [];
  List<dynamic> dropDownLots = [];
  String? selectedBin;
  String? selectedLot;
  bool isLoadingBins = true;
  bool isLoadingLots = true;
  List<UOM> _uoms = List<UOM>.empty(growable: true);
  List<ReasonItem> _reasons = List<ReasonItem>.empty(growable: true);

  String _barcodeError = '';
  String _oldPartNo = '';
  bool _saving = false;
  bool _lotEnabled = false;

  var txtPartNo = new TextEditingController();
  var txtPartDesc = new TextEditingController();
  var txtQty = new TextEditingController();
  var txtIUM = new TextEditingController();
  var txtLotNo = new TextEditingController();
  var txtWhse = new TextEditingController();
  var txtBin = new TextEditingController();
  var txtReason = new TextEditingController();
  var txtRef = new TextEditingController();
  var txtNoofLable = new TextEditingController();

  FocusNode _textFocusPartNo = new FocusNode();
  FocusNode _textFocusQty = new FocusNode();
  FocusNode _textFocusWhse = new FocusNode();

  @override
  void initState() {
    txtPartNo.addListener(onChangePartNo);
    _textFocusPartNo.addListener(onChangePartNo);

    txtQty.addListener(onChangeQty);
    _textFocusQty.addListener(onChangeQty);

    txtWhse.addListener(onChangeWhse);
    _textFocusWhse.addListener(onChangeWhse);

    super.initState();

    _uoms.add(new UOM('0', 'Not found'));

    txtQty.text = '1';
    txtNoofLable.text = '1';
  }

  void onChangePartNo() {
    // Triggers ONLY when the user finished typing and clicked away
    if (!_textFocusPartNo.hasFocus) {
      if (_oldPartNo != txtPartNo.text) {
        _oldPartNo = txtPartNo.text;

        if (txtPartNo.text.isNotEmpty) {
          splitPartNo(txtPartNo.text);
        }
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

  void fetchBinsOnLoad() {
    // Use the part number loaded into your controller text
    getInventoryQtyAdjForPart(txtPartNo.text).then((response) {
      bool isSuccess = response[0];
      String rawBody = response[1];

      if (isSuccess) {
        var decodedData = jsonDecode(rawBody);

        setState(() {
          dropDownBins = decodedData['InventoryQtyAdjBrw'] ?? [];
          isLoadingBins = false;
          for (var item in dropDownBins) {
            print('Bin: ${item['BinNum']}, Qty: ${item['OnHandQty']}');
          }
          // Pro-tip: Automatically pre-select the first bin if the list isn't empty
          if (dropDownBins.isNotEmpty) {
            selectedBin = dropDownBins[0]['BinNum'];
          }
        });
      } else {
        setState(() {
          isLoadingBins = false;
        });
        // Handle your error case here (e.g., show snackbar)
      }
    });
  }

  void fetchLotsOnLoad() {
    // Use the part number loaded into your controller text
    getInventoryLot(
            warehouseCode: txtWhse.text,
            binNum: txtBin.text,
            partNum: txtPartNo.text)
        .then((List<EpiGetLot> responseLots) {
      setState(() {
        dropDownLots = responseLots;
        isLoadingLots = false;

        // Print debug logs to your output terminal console
        for (var item in dropDownLots) {
          print('Lot: ${item.lotNum}, Qty: ${item.onHandQty}');
        }
      });
    }).catchError((error) {
      setState(() {
        isLoadingLots = false;
      });
      print("Error loading lots during initialization: $error");
    });
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

  void triggerReasonDropDown() {
    _reasons.clear();

    if (txtPartNo.text != '') {
      _reasons.add(new ReasonItem('0', 'Select Reason'));
      getEpiReasonList('M', _reasons)
          .then((List<ReasonItem> list) => setState(() {
                displaySelReasonDialog();
              }));
    } else {
      _reasons.add(new ReasonItem('0', 'Not found'));
      setState(() {
        displaySelReasonDialog();
      });
    }
  }

  displaySelReasonDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Reason'),
            content: DropdownButton<ReasonItem>(
              isExpanded: true,
              value: _reasons[0],
              onChanged: (ReasonItem? _newValue) {
                setState(() {
                  if (_newValue!.id != '0') {
                    txtReason.text = _newValue.id;
                  }
                });
                Navigator.of(context).pop();
              },
              items: _reasons.map((ReasonItem _reason) {
                return new DropdownMenuItem<ReasonItem>(
                  value: _reason,
                  child: new Text(
                    _reason.name,
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

  Future<bool> splitPartNo(String txt) async {
    print("object");
    bool result = false;
    var strSplit = txt.split(_globals.epibarcodeseperator);

    if (strSplit.length == 2) {
      print("object2");
      txtPartNo.text = strSplit[0];
      txtLotNo.text = strSplit[1];
      result = true;
    } else {
      var strSplit2 = txt.split(_globals.epibarcodeseperator2);
      if (strSplit2.length == 2) {
        txtPartNo.text = strSplit[0];
        txtLotNo.text = strSplit[1];
        result = true;
      } else {
        txtPartNo.text = txt;
      }
    }
    print("object3 ${txtPartNo.text}");
    EpiPart _data = await getEpiPart(txtPartNo.text);
    fetchBinsOnLoad();
    setState(() {
      _lotEnabled = _data.tracklots;
      txtIUM.text = _data.ium;
      txtPartDesc.text = _data.partdescription;
      if (_lotEnabled == false) {
        txtLotNo.text = '';
      }
    });

    return result;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Quantity Adjustment",
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
                                  InputDecoration(labelText: 'Quantity'),
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              controller: txtQty,
                              focusNode: _textFocusQty,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: ListTile(
                            title: TextFormField(
                              decoration: InputDecoration(labelText: 'UOM'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtIUM,
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
                                  InputDecoration(labelText: 'Warehouse'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtWhse,
                              focusNode: _textFocusWhse,
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
                            // From Warehouse
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningWhse,
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
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Autocomplete<Map<String, dynamic>>(
                              // CHANGED: dynamic to Map<String, dynamic>
                              // Displays only the BinNum string inside the text field upon selection
                              displayStringForOption:
                                  (Map<String, dynamic> option) =>
                                      option['BinNum'].toString(),

                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                // Show all items if user taps the field empty, or filter items by BinNum text match
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<
                                      Map<String, dynamic>>.empty();
                                }
                                return dropDownBins
                                    .cast<Map<String, dynamic>>()
                                    .where((Map<String, dynamic> option) {
                                  return option['BinNum']
                                      .toString()
                                      .toLowerCase()
                                      .contains(
                                          textEditingValue.text.toLowerCase());
                                });
                              },

                              // Capture the clicked option and explicitly map it to your main controller
                              onSelected: (Map<String, dynamic> selection) {
                                setState(() {
                                  txtBin.text = selection['BinNum'].toString();
                                });
                              },

                              fieldViewBuilder: (context, textEditingController,
                                  focusNode, onFieldSubmitted) {
                                // Ensure the dynamic autocomplete controller stays in sync with your global txtBin controller
                                if (textEditingController.text != txtBin.text) {
                                  textEditingController.text = txtBin.text;
                                }

                                // Listen for external updates (like camera scan events) updating txtBin
                                txtBin.addListener(() {
                                  if (textEditingController.text !=
                                      txtBin.text) {
                                    textEditingController.text = txtBin.text;
                                  }
                                });

                                // REMOVED: The generic Focus widget wrapper that was forcing onFieldSubmitted() on focus loss
                                return TextFormField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  decoration: const InputDecoration(
                                    labelText: 'From Bin',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(137, 0, 0, 0)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                  // Process submission only if they explicitly press "Enter" or "Done" on their keyboard
                                  onFieldSubmitted: (String value) {
                                    onFieldSubmitted();
                                  },
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
                                          final Map<String, dynamic> option =
                                              options.elementAt(index);
                                          return ListTile(
                                            title: Text(
                                              option['BinNum'].toString(),
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                            subtitle: Text(
                                              "Qty: ${option['OnHandQty']}",
                                              style: const TextStyle(
                                                  color: Colors.white60),
                                            ),
                                            onTap: () {
                                              onSelected(option);
                                              fetchLotsOnLoad();
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
                            onPressed: barcodeScanningBin,
                            child: const Icon(Icons.camera_alt),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Autocomplete<EpiGetLot>(
                              // Displays only the lotNum string inside the active text field upon click selection
                              displayStringForOption: (EpiGetLot option) =>
                                  option.lotNum,

                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                // Return empty list if user clears the text area
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<EpiGetLot>.empty();
                                }

                                // Filter your strongly typed objects by matching the lot text patterns
                                return dropDownLots
                                    .whereType<EpiGetLot>()
                                    .where((EpiGetLot option) {
                                  return option.lotNum.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase());
                                });
                              },

                              // Capture the selected model object and update your parent application states
                              onSelected: (EpiGetLot selection) {
                                setState(() {
                                  txtLotNo.text = selection.lotNum;
                                  selectedLot = selection.lotNum;
                                });
                              },

                              fieldViewBuilder: (context, textEditingController,
                                  focusNode, onFieldSubmitted) {
                                // Keep the interactive text controller layout in perfect parity with your state fields
                                if (textEditingController.text !=
                                    txtLotNo.text) {
                                  textEditingController.text = txtLotNo.text;
                                }

                                // Listen for background updates (like scanning barcodes or barcode triggers) updating txtLotNo
                                txtLotNo.addListener(() {
                                  if (textEditingController.text !=
                                      txtLotNo.text) {
                                    textEditingController.text = txtLotNo.text;
                                  }
                                });

                                return TextFormField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                  decoration: const InputDecoration(
                                    labelText: 'Lot Number',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(137, 0, 0, 0)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                  onFieldSubmitted: (String value) {
                                    onFieldSubmitted();
                                  },
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
                                          final EpiGetLot option =
                                              options.elementAt(index);
                                          return ListTile(
                                            title: Text(
                                              option.lotNum,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                            subtitle: Text(
                                              "Qty On Hand: ${option.onHandQty}",
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
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero),
                            onPressed: barcodeScanningLotNo,
                            child: Icon(Icons.camera_alt),
                          ),
                        ),
                      ],
                    ),

                    // Row(
                    //   children: <Widget>[
                    //     Expanded(
                    //       child: ListTile(
                    //         title: TextFormField(
                    //           decoration: InputDecoration(labelText: 'Bin'),
                    //           obscureText: false,
                    //           keyboardType: TextInputType.text,
                    //           autocorrect: false,
                    //           controller: txtBin,
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
                    //         // From Bin
                    //         child: Icon(Icons.camera_alt),
                    //         onPressed: barcodeScanningBin,
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
                    //           decoration: InputDecoration(labelText: 'Lot'),
                    //           obscureText: false,
                    //           keyboardType: TextInputType.text,
                    //           autocorrect: false,
                    //           controller: txtLotNo,
                    //           enabled: _lotEnabled,
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
                    //         // Lot
                    //         child: Icon(Icons.camera_alt),
                    //         onPressed: barcodeScanningLotNo,
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
                              decoration: InputDecoration(labelText: 'Reason'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtReason,
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
                            onPressed: triggerReasonDropDown,
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
                                  InputDecoration(labelText: 'Reference'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtRef,
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
                            // To Bin
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningRef,
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
                          title: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue, // Button background
                              foregroundColor: Colors.white, // Text color
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Submit',
                              textScaleFactor: textScaleFactor,
                            ),
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

    setState(() {
      _saving = true;
    });

    _result = await postQtyAdjustment(
        txtPartNo.text,
        txtIUM.text,
        txtQty.text,
        txtWhse.text,
        txtBin.text,
        txtLotNo.text,
        txtReason.text,
        txtRef.text,
        txtNoofLable.text);

    setState(() {
      _saving = false;
    });

    if (_result[0] == false) {
      showAlertPopup(
          context, 'Error', 'Process Qty Adjustment : ' + _result[1]);
      return;
    }

    //Navigator.pop(context, true);
    clearAllFields();
  }

  void clearAllFields() {
    txtPartNo.text = '';
    txtPartDesc.text = '';
    txtQty.text = '0.00';
    txtIUM.text = '';
    txtLotNo.text = '';
    txtWhse.text = '';
    txtBin.text = '';
    txtReason.text = '';
    txtRef.text = '';
    txtNoofLable.text = '1';
  }

  Future barcodeScanningPartNo() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      print("fsdf ${barcode.rawContent}");
      bool isSplitPartNo = await splitPartNo(barcode.rawContent);

      setState(() {
        if (isSplitPartNo == false) {
          // if not split part no. means barcode only contains part no.
          txtPartNo.text = barcode.rawContent;
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
      print("scann result: ${barcode.rawContent}");
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

  Future barcodeScanningRef() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtRef.text = barcode.rawContent;
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

  Future<void> scanAndSetToController(TextEditingController controller,
      {required String type}) async {
    try {
      ScanResult result = await BarcodeScanner.scan();
      print("SCAN RESULT: ${result.rawContent}");

      if (result.rawContent.isNotEmpty) {
        // First, remove trailing commas and whitespace
        final raw = result.rawContent.trim().replaceAll(",", "");

        // Try split by known separators
        List<String> parts = [];
        if (raw.contains('~')) {
          parts = raw.split('~');
        } else if (raw.contains(',')) {
          parts = raw.split(',');
        } else if (raw.contains('-')) {
          parts = raw.split('-');
        }

        setState(() {
          if (type == 'warehouse') {
            // Fill HQ (first part) or full fallback
            controller.text = parts.isNotEmpty ? parts[0].trim() : raw;
          } else if (type == 'bin') {
            // Fill LOAD1 (second part) or fallback
            controller.text = parts.length > 1 ? parts[1].trim() : raw;
          } else {
            // Unknown type fallback
            controller.text = raw;
          }
        });
      } else {
        print('No barcode content found');
      }
    } catch (e) {
      print('Scan error: $e');
    }
  }
}
