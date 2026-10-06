// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/epigetbin.dart';
import 'package:flutter_epihhinventory/data/classes/epigetlot.dart';
import 'package:flutter_epihhinventory/data/classes/epipart.dart';
import 'package:flutter_epihhinventory/ui/epipages/lotcreation.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:flutter_epihhinventory/utils/validator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class MoveInventoryRequest extends StatefulWidget {
  MoveInventoryRequest();

  MoveInventoryRequestState createState() => MoveInventoryRequestState();
}

class MoveInventoryRequestState extends State<MoveInventoryRequest> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> dropDownBins = [];
  List<dynamic> dropDownLots = [];
  String _lastFetchedWhse = "";
  String _lastFetchedBin = "";
  String? selectedBin;
  String? selectedLot;
  bool isLoadingBins = true;
  bool isLoadingLots = true;
  List<UOM> _uoms = List<UOM>.empty(growable: true);

  String _barcodeError = "";
  bool _saving = false;
  bool _lotEnabled = false;

  var txtPartNo = new TextEditingController();
  var txtPartDesc = new TextEditingController();
  var txtQty = new TextEditingController();
  var txtIUM = new TextEditingController();
  var txtFrWhse = new TextEditingController();
  var txtFrBin = new TextEditingController();
  var txtFrLotNo = new TextEditingController();
  var txtToWhse = new TextEditingController();
  var txtToBin = new TextEditingController();
  var txtToLotNo = new TextEditingController();
  var txtRef = new TextEditingController();
  var txtNoofLable = new TextEditingController();

  FocusNode _textFocusPartNo = new FocusNode();
  FocusNode _textFocusQty = new FocusNode();
  FocusNode _textFocusFrWhse = new FocusNode();
  FocusNode _textFocusToWhse = new FocusNode();
  FocusNode _textFocusFrBin = new FocusNode();

  @override
  void initState() {
    txtPartNo.addListener(onChangePartNo);
    _textFocusPartNo.addListener(onChangePartNo);

    txtQty.addListener(onChangeQty);
    _textFocusQty.addListener(onChangeQty);

    txtFrWhse.addListener(onChangeFrWhse);
    _textFocusFrWhse.addListener(onChangeFrWhse);

    txtToWhse.addListener(onChangeToWhse);
    _textFocusToWhse.addListener(onChangeToWhse);

    txtFrBin.addListener(checkAndFetchLots);
    _textFocusFrBin.addListener(onInputsChanged);

    txtToBin.addListener(checkAndFetchLots);

    if (txtFrWhse.text.isNotEmpty) {
      _lastFetchedWhse = txtFrWhse.text;
      fetchBinsOnLoad();
    }
    if (txtFrWhse.text.isNotEmpty &&
        txtFrBin.text.isNotEmpty &&
        txtPartNo.text.isNotEmpty) {
      _lastFetchedWhse = txtFrWhse.text;
      _lastFetchedBin = txtFrBin.text;
      fetchLotsOnLoad(txtFrWhse.text, txtFrBin.text);
    }

    super.initState();

    _uoms.add(new UOM('0', 'Not found'));

    txtQty.text = '1';
    txtNoofLable.text = '1';
  }

  void onChangePartNo() {
    if (!_textFocusPartNo.hasFocus && txtPartNo.text != '') {
      splitPartNo(txtPartNo.text);
      checkAndFetchLots();
      getMovePart();
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

  void onChangeFrWhse() {
    if (!_textFocusFrWhse.hasFocus && txtFrWhse.text != '') {
      checkAndFetchLots();
      splitFrWhse(txtFrWhse.text);
    }
  }

  void onChangeToWhse() {
    if (!_textFocusToWhse.hasFocus && txtToWhse.text != '') {
      splitToWhse(txtToWhse.text);
      checkAndFetchLots();
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
    setState(() {
      isLoadingBins =
          true; // Set loading state before starting the network request
    });

    // 1. Call the function with parameters from your text controllers
    getInventoryBin(
      partNum: txtPartNo.text,
      warehouseCode: txtFrWhse.text,
    ).then((List<EpiGetBin> binsList) {
      // 2. Update your state with the returned strongly-typed objects
      setState(() {
        isLoadingBins = false;

        // Update your dropdown list directly with the objects
        dropDownBins = binsList;

        // Print the values using the properties of your new EpiGetBin class
        for (var item in dropDownBins) {
          print('Bin: ${item.binNum}, Qty: ${item.onHandQty}');
        }

        // 3. Automatically pre-select the first bin if the list isn't empty
        if (dropDownBins.isNotEmpty) {
          selectedBin = dropDownBins.first.binNum;
        } else {
          selectedBin = null; // Clear selection if no bins were found
        }
      });
    }).catchError((error) {
      // Handle unexpected code crashes or errors gracefully
      setState(() {
        isLoadingBins = false;
      });
      print("Error calling getInventoryBin: $error");
    });
  }

  void fetchLotsOnLoad(String whseCode, String binNo) {
    // Use the part number loaded into your controller text
    getInventoryLot(
            warehouseCode: whseCode, partNum: txtPartNo.text, binNum: binNo)
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

  void checkAndFetchLots() {
    final partNo = txtPartNo.text.trim();

    // From Warehouse + From Bin
    if (partNo.isNotEmpty &&
        txtFrWhse.text.trim().isNotEmpty &&
        txtFrBin.text.trim().isNotEmpty) {
      fetchLotsOnLoad(
        txtFrWhse.text.trim(),
        txtFrBin.text.trim(),
      );
      onInputsChanged();
    }

    // To Warehouse + To Bin
    if (partNo.isNotEmpty &&
        txtToWhse.text.trim().isNotEmpty &&
        txtToBin.text.trim().isNotEmpty) {
      fetchLotsOnLoad(
        txtToWhse.text.trim(),
        txtToBin.text.trim(),
      );
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

  Future getMovePart() async {
    List<dynamic> _result;

    _result = await getEpiMovInvPart(txtPartNo.text);

    if (_result[0] == false) {
      EpiPart _data = _result[1];

      txtIUM.text = '';
      txtIUM.text = _data.ium;
      txtPartDesc.text = _data.partdescription;
    }
  }

  Future<bool> splitPartNo(String txt) async {
    bool result = false;
    var strSplit = txt.split(_globals.epibarcodeseperator);

    if (strSplit.length == 2) {
      txtPartNo.text = strSplit[0];
      txtFrLotNo.text = strSplit[1];
      txtToLotNo.text = strSplit[1];
      result = true;
    } else {
      var strSplit2 = txt.split(_globals.epibarcodeseperator2);
      if (strSplit2.length == 2) {
        txtPartNo.text = strSplit2[0];
        txtFrLotNo.text = strSplit2[1];
        txtToLotNo.text = strSplit2[1];
        result = true;
      } else {
        txtPartNo.text = txt;
      }
    }

    EpiPart _data = await getEpiPart(txtPartNo.text);
    setState(() {
      _lotEnabled = _data.tracklots;
      if (_lotEnabled == false) {
        txtFrLotNo.text = '';
        txtToLotNo.text = '';
      }
    });

    return result;
  }

  bool splitFrWhse(String txt) {
    bool result = false;

    var strSplit = txt.split(_globals.epibarcodeseperator);
    if (strSplit.length >= 2) {
      txtFrWhse.text = strSplit[0];
      txtFrBin.text = strSplit[1];

      if (strSplit.length >= 3 && _lotEnabled) {
        txtFrLotNo.text = strSplit[2];
      }

      result = true;
    } else {
      var strSplit2 = txt.split(_globals.epibarcodeseperator2);
      if (strSplit2.length >= 2) {
        txtFrWhse.text = strSplit2[0];
        txtFrBin.text = strSplit2[1];

        if (strSplit2.length >= 3) {
          txtFrLotNo.text = strSplit2[2];
        }

        result = true;
      }
    }
    fetchBinsOnLoad();
    return result;
  }

  bool splitToWhse(String txt) {
    bool result = false;
    var strSplit = txt.split(_globals.epibarcodeseperator);

    if (strSplit.length >= 2) {
      txtToWhse.text = strSplit[0];
      txtToBin.text = strSplit[1];

      if (strSplit.length >= 3 && _lotEnabled) {
        txtToLotNo.text = strSplit[2];
      }

      result = true;
    } else {
      var strSplit2 = txt.split(_globals.epibarcodeseperator2);
      if (strSplit2.length >= 2) {
        txtToWhse.text = strSplit2[0];
        txtToBin.text = strSplit2[1];

        if (strSplit2.length >= 3) {
          txtToLotNo.text = strSplit2[2];
        }

        result = true;
      }
    }

    return result;
  }

  void onInputsChanged() {
    if (!_textFocusFrWhse.hasFocus && txtFrWhse.text.isNotEmpty) {
      splitFrWhse(txtFrWhse.text);
    }
    bool userIsStillTyping =
        _textFocusFrWhse.hasFocus || _textFocusFrBin.hasFocus;

    if (!userIsStillTyping) {
      // 3. Ensure all three required criteria fields contain data strings
      if (txtFrWhse.text.isNotEmpty && txtFrBin.text.isNotEmpty) {
        // 4. Verification Check: Only hit Epicor if Warehouse OR Bin has actually changed value
        if (txtFrWhse.text != _lastFetchedWhse ||
            txtFrBin.text != _lastFetchedBin) {
          // Cache the newly processed combinations
          _lastFetchedWhse = txtFrWhse.text;
          _lastFetchedBin = txtFrBin.text;

          setState(() {
            isLoadingLots = true; // Flips layout loaders on
          });

          // 5. Calls the API with your dynamic parameters
          fetchLotsOnLoad(txtFrWhse.text, txtFrBin.text);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Move Inventory Request",
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
                                  InputDecoration(labelText: 'From Warehouse'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtFrWhse,
                              focusNode: _textFocusFrWhse,
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
                            onPressed: barcodeScanningFrWhse,
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
                            child: TypeAheadField<EpiGetBin>(
                              controller:
                                  txtFrBin, // Connects directly to your global controller

                              // Modern 5.x layout sizing parameters
                              constraints: const BoxConstraints(maxHeight: 250),

                              // Replaces TypeAheadModifiers to build your grey background container
                              decorationBuilder: (context, child) {
                                return Material(
                                  elevation: 4.0,
                                  color: Colors.grey,
                                  child: child,
                                );
                              },

                              builder: (context, controller, focusNode) {
                                // Keep your barcode/camera scanning text updates in sync
                                txtFrBin.addListener(() {
                                  if (controller.text != txtFrBin.text) {
                                    controller.text = txtFrBin.text;
                                  }
                                });

                                return TextFormField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  style: const TextStyle(color: Colors.black),
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
                                );
                              },

                              suggestionsCallback: (search) {
                                if (search.isEmpty) return [];
                                return dropDownBins
                                    .cast<EpiGetBin>()
                                    .where((option) => option.binNum
                                        .toLowerCase()
                                        .contains(search.toLowerCase()))
                                    .toList();
                              },

                              itemBuilder: (context, option) {
                                return ListTile(
                                  title: Text(
                                    option.binNum,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    "Qty: ${option.onHandQty}",
                                    style:
                                        const TextStyle(color: Colors.white60),
                                  ),
                                );
                              },

                              onSelected: (option) {
                                setState(() {
                                  txtFrBin.text = option.binNum;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero),
                            onPressed: barcodeScanningFrBin,
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
                            child: TypeAheadField<EpiGetLot>(
                              controller: txtFrLotNo,
                              constraints: const BoxConstraints(
                                maxHeight: 250,
                              ),
                              decorationBuilder: (context, child) {
                                return Material(
                                  elevation: 4.0,
                                  color: Colors.grey,
                                  child: child,
                                );
                              },
                              builder: (context, controller, focusNode) {
                                return TextFormField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  enabled: _lotEnabled,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: 'Lot Number',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(137, 0, 0, 0),
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              suggestionsCallback: (search) {
                                if (search.isEmpty) {
                                  return [];
                                }

                                return dropDownLots
                                    .whereType<EpiGetLot>()
                                    .where((option) {
                                  return option.lotNum
                                      .toLowerCase()
                                      .contains(search.toLowerCase());
                                }).toList();
                              },
                              itemBuilder: (context, option) {
                                return ListTile(
                                  title: Text(
                                    option.lotNum,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Qty On Hand: ${option.onHandQty}",
                                    style: const TextStyle(
                                      color: Colors.white60,
                                    ),
                                  ),
                                );
                              },
                              onSelected: (option) {
                                setState(() {
                                  txtFrLotNo.text = option.lotNum;
                                  selectedLot = option.lotNum;
                                });
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
                            onPressed:
                                _lotEnabled ? barcodeScanningFrLotNo : null,
                            child: const Icon(Icons.camera_alt),
                          ),
                        ),
                      ],
                    ),

                    // Row(
                    //   children: <Widget>[
                    //     Expanded(
                    //       child: ListTile(
                    //         title: TextFormField(
                    //           decoration:
                    //               InputDecoration(labelText: 'From Bin'),
                    //           obscureText: false,
                    //           keyboardType: TextInputType.text,
                    //           autocorrect: false,
                    //           controller: txtFrBin,
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
                    //         onPressed: barcodeScanningFrBin,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: <Widget>[
                    //     Expanded(
                    //       child: ListTile(
                    //         title: TextFormField(
                    //           decoration:
                    //               InputDecoration(labelText: 'From Lot'),
                    //           obscureText: false,
                    //           keyboardType: TextInputType.text,
                    //           autocorrect: false,
                    //           controller: txtFrLotNo,
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
                    //         onPressed: barcodeScanningFrLotNo,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'To Warehouse'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtToWhse,
                              focusNode: _textFocusToWhse,
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
                            // To Warehouse
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningToWhse,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration: InputDecoration(labelText: 'To Bin'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtToBin,
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
                            onPressed: barcodeScanningToBin,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: TextFormField(
                              decoration: InputDecoration(labelText: 'To Lot'),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              controller: txtToLotNo,
                              enabled: _lotEnabled,
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
                            // Lot
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningToLotNo,
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
                            // Lot
                            child: Icon(Icons.camera_alt),
                            onPressed: barcodeScanningRef,
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
                            onPressed: () => Navigator.pop(context, true),
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

  Future submitData() async {
    List<dynamic> _result;

    if (txtToLotNo.text != '' && _lotEnabled == true) {
      setState(() {
        _saving = true;
      });

      _result = await isPartLotExist(txtPartNo.text, txtToLotNo.text);

      setState(() {
        _saving = false;
      });

      if (_result[0] == false) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LotCreation(txtPartNo.text, txtToLotNo.text),
                fullscreenDialog: true));
        return;
      }
    }

    setState(() {
      _saving = true;
    });

    _result = await postMoveInventoryRequest(
        txtPartNo.text,
        txtIUM.text,
        txtQty.text,
        txtFrWhse.text,
        txtFrBin.text,
        txtFrLotNo.text,
        txtToWhse.text,
        txtToBin.text,
        txtToLotNo.text,
        txtRef.text,
        txtNoofLable.text);

    setState(() {
      _saving = false;
    });

    if (_result[0] == false) {
      showAlertPopup(
          context, 'Error', 'Process Move Inventory Request : ' + _result[1]);
      return;
    }

    setState(() {
      _saving = false;
    });

    //Navigator.pop(context, true);
    clearAllFields();
  }

  void clearAllFields() {
    txtPartNo.text = '';
    txtPartDesc.text = '';
    txtQty.text = '0.00';
    txtIUM.text = '';
    txtFrLotNo.text = '';
    txtFrWhse.text = '';
    txtFrBin.text = '';
    txtToLotNo.text = '';
    txtToWhse.text = '';
    txtToBin.text = '';
    txtRef.text = '';
    txtNoofLable.text = '1';
  }

  Future barcodeScanningPartNo() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      bool isSplitPartNo = await splitPartNo(barcode.rawContent);

      setState(() {
        if (isSplitPartNo == false) {
          txtPartNo.text = barcode.rawContent;
        }
        getMovePart();
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

  Future barcodeScanningFrLotNo() async {
    _barcodeError = '';
    try {
      if (_lotEnabled == true) {
        ScanResult barcode = await BarcodeScanner.scan();
        setState(() {
          txtFrLotNo.text = barcode.rawContent;
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

  Future barcodeScanningFrWhse() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        if (splitFrWhse(barcode.rawContent) == false) {
          txtFrWhse.text = barcode.rawContent;
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

  Future barcodeScanningFrBin() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtFrBin.text = barcode.rawContent;
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

  Future barcodeScanningToLotNo() async {
    _barcodeError = '';
    try {
      if (_lotEnabled == true) {
        ScanResult barcode = await BarcodeScanner.scan();
        setState(() {
          txtFrLotNo.text = barcode.rawContent;
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

  Future barcodeScanningToWhse() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        if (splitToWhse(barcode.rawContent) == false) {
          txtToWhse.text = barcode.rawContent;
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

  Future barcodeScanningToBin() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtToBin.text = barcode.rawContent;
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
}
