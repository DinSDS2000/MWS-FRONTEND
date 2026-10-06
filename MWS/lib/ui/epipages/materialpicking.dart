import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/epigetbin.dart';
import 'package:flutter_epihhinventory/data/classes/epigetlot.dart';
import 'package:flutter_epihhinventory/data/classes/epipart.dart';
import 'package:flutter_epihhinventory/data/classes/epipickerbaq.dart';
import 'package:flutter_epihhinventory/ui/epipages/lotcreation.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/globals.dart' as _globals;
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:flutter_epihhinventory/utils/validator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MaterialPicking extends StatefulWidget {
  final Epipickerbaq pickerBaq;
  const MaterialPicking({Key? key, required this.pickerBaq}) : super(key: key);

  @override
  State<MaterialPicking> createState() => _MaterialPickingState();
}

class _MaterialPickingState extends State<MaterialPicking> {
  bool _saving = false;
  String _barcodeError = '';
  bool _lotEnabled = false;
  String legalNum = '';
  List<EpiGetBin> dropDownBins = [];
  List<EpiGetLot> dropDownLots = [];
  List<Map<String, dynamic>> pickedItems = [];
  String? selectedBin;
  String? selectedLot;
  String _lastFetchedWhse = "";
  String _lastFetchedBin = "";
  bool isLoadingBins = true;
  bool isLoadingLots = true;
  late TextEditingController txtPart;
  late TextEditingController txtDesc;
  late TextEditingController txtQty;
  late TextEditingController txtUom;
  late TextEditingController txtExemptionNo;
  late TextEditingController txtTaxCat;
  late TextEditingController txtPickedQty;
  late TextEditingController txtLegalNum;
  var txtRemainingQty = new TextEditingController();
  var txtWhse = new TextEditingController();
  var txtBin = new TextEditingController();
  var txtLot = new TextEditingController();
  final Map<int, bool> _selectedCards = {};
  var _txtFocusPartNo = new FocusNode();
  var _txtFocusBinNo = new FocusNode();
  FocusNode _textFocusWhse = new FocusNode();
  FocusNode _textFocusPickedQty = new FocusNode();

  @override
  void initState() {
    super.initState();

    txtPart = TextEditingController(text: widget.pickerBaq.ud100aProductC);
    txtDesc = TextEditingController(text: widget.pickerBaq.ud100aProductDescC);
    txtQty = TextEditingController(
        text: widget.pickerBaq.ud100aQuantityC.toString());
    txtUom = TextEditingController(text: widget.pickerBaq.ud100aUomC);
    txtExemptionNo =
        TextEditingController(text: widget.pickerBaq.orderRelExemptionNo);
    txtTaxCat = TextEditingController(text: widget.pickerBaq.taxCatID);
    txtPickedQty = TextEditingController(text: "1");
    txtLegalNum = TextEditingController(text: '');
    txtWhse.addListener(onChangeWhse);
    _textFocusWhse.addListener(onChangeWhse);
    txtBin.addListener(onInputsChanged);
    _txtFocusBinNo.addListener(onInputsChanged);
    // _textFocusPickedQty.addListener(onChangedQty);
    txtRemainingQty.text = txtQty.text;
    setTrackLot();

    // fetchLotsOnLoad();
    if (txtWhse.text.isNotEmpty) {
      _lastFetchedWhse = txtWhse.text;
      fetchBinsOnLoad();
    }
    if (txtWhse.text.isNotEmpty &&
        txtBin.text.isNotEmpty &&
        txtPart.text.isNotEmpty) {
      _lastFetchedWhse = txtWhse.text;
      _lastFetchedBin = txtBin.text;
      fetchLotsOnLoad();
    }

    loadExistingPickedItems();
  }

  void onChangeWhse() {
    if (!_textFocusWhse.hasFocus && txtWhse.text.isNotEmpty) {
      splitWhse(txtWhse.text);
      if (txtWhse.text != _lastFetchedWhse) {
        _lastFetchedWhse = txtWhse.text; // Cache the new value
      }
    }
  }

  bool splitWhse(String txt) {
    bool result = false;

    var strSplit = txt.split(_globals.epibarcodeseperator);
    if (strSplit.length >= 2) {
      txtWhse.text = strSplit[0];
      txtBin.text = strSplit[1];

      if (strSplit.length >= 3) {
        txtLot.text = strSplit[2];
      }

      result = true;
    } else {
      var strSplit2 = txt.split(_globals.epibarcodeseperator2);
      if (strSplit2.length >= 2) {
        txtWhse.text = strSplit2[0];
        txtBin.text = strSplit2[1];

        if (strSplit2.length >= 3) {
          txtLot.text = strSplit2[2];
        }

        result = true;
      }
    }
    fetchBinsOnLoad();
    return result;
  }

  void onInputsChanged() {
    // 1. Process your custom string mutations when warehouse loses focus
    if (!_textFocusWhse.hasFocus && txtWhse.text.isNotEmpty) {
      splitWhse(txtWhse.text);
    }

    // 2. SAFETY CHECK: The user must not be actively editing either field
    // This prevents the API from firing prematurely while they shift focus between Warehouse and Bin
    bool userIsStillTyping = _textFocusWhse.hasFocus || _txtFocusBinNo.hasFocus;

    if (!userIsStillTyping) {
      // 3. Ensure all three required criteria fields contain data strings
      if (txtWhse.text.isNotEmpty && txtBin.text.isNotEmpty) {
        // 4. Verification Check: Only hit Epicor if Warehouse OR Bin has actually changed value
        if (txtWhse.text != _lastFetchedWhse ||
            txtBin.text != _lastFetchedBin) {
          // Cache the newly processed combinations
          _lastFetchedWhse = txtWhse.text;
          _lastFetchedBin = txtBin.text;

          setState(() {
            isLoadingLots = true; // Flips layout loaders on
          });

          // 5. Calls the API with your dynamic parameters
          fetchLotsOnLoad();
        }
      }
    }
  }

  Future<void> loadExistingPickedItems() async {
    try {
      setState(() {
        _saving = true;
      });

      final result = await getPickedTable(
        key3: widget.pickerBaq.legalNum ?? '',
        key4: widget.pickerBaq.ud100aProductC ?? '',
      );
      print("PICKEDTABLE $result");
      if (result.isEmpty) {
        print('No previous picked records found');

        // First time entering.
        // Keep using your existing CustShip/BAQ data.

        setState(() {
          pickedItems = [];
        });

        return;
      }

      print('Found ${result.length} previous picked records: $result');
      final latestRemainingQty = result.last.remQty;
      txtRemainingQty.text = latestRemainingQty.toString();
      txtLegalNum.text = widget.pickerBaq.legalNum.toString();
      final List<Map<String, dynamic>> loadedItems = [];

      for (final item in result) {
        loadedItems.add({
          'part': txtPart.text,
          'packNum': item.key1,
          'packLine': item.key2,
          'legalNum': item.key3,
          'childKey1': item.childKey1,
          'whse': item.character01,
          'bin': item.character02,
          'lot': item.character03,
          'qty': item.number01,
          'uom': item.character04,
          'doLine': item.character06,
        });
      }

      setState(() {
        pickedItems = loadedItems;
      });
    } catch (e) {
      print('loadExistingPickedItems error: $e');

      showAlertPopup(
        context,
        'Exception',
        e.toString(),
      );
    } finally {
      setState(() {
        _saving = false;
      });
    }
  }

  bool get _isAllSelected {
    if (pickedItems.isEmpty) return false;
    return pickedItems
        .asMap()
        .keys
        .every((index) => _selectedCards[index] == true);
  }

  void _toggleSelectAll(bool? selectAll) {
    setState(() {
      for (int i = 0; i < pickedItems.length; i++) {
        _selectedCards[i] = selectAll ?? false;
      }
    });
  }

  void onChangedQty() {
    double qty = double.tryParse(txtQty.text) ?? 0.0;
    double pickQty = double.tryParse(txtPickedQty.text) ?? 0.0;

    double remaining = qty - pickQty;

    txtRemainingQty.text = remaining.toString();
  }

  void fetchBinsOnLoad() {
    setState(() {
      isLoadingBins =
          true; // Set loading state before starting the network request
    });

    // 1. Call the function with parameters from your text controllers
    getInventoryBin(
      partNum: txtPart.text,
      warehouseCode: txtWhse.text,
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

  void fetchLotsOnLoad() {
    // Use the part number loaded into your controller text
    getInventoryLot(
            warehouseCode: txtWhse.text,
            partNum: txtPart.text,
            binNum: txtBin.text)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Picking'),
        automaticallyImplyLeading: false,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Part'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtPart,
                          focusNode: _txtFocusPartNo,
                          enabled: false,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Description'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtDesc,
                          enabled: false,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Quantity'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtQty,
                          enabled: false,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 100,
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'UOM'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtUom,
                          enabled: false,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Picked Quantity'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtPickedQty,
                          enabled: true,
                          focusNode: _textFocusPickedQty,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 100,
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'UOM'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtUom,
                          enabled: false,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Remaining Quantity'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtRemainingQty,
                          enabled: false,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 100,
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'UOM'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtUom,
                          enabled: false,
                        ),
                      ),
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: ListTile(
                //         title: TextFormField(
                //           decoration: InputDecoration(labelText: 'UOM'),
                //           obscureText: false,
                //           keyboardType: TextInputType.text,
                //           autocorrect: false,
                //           controller: txtUom,
                //           enabled: false,
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //   ],
                // ),
                Row(
                  children: [
                    // Tax Category takes 1/3 of the space
                    Expanded(
                      flex: 1,
                      child: ListTile(
                        title: TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Tax Category'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtTaxCat,
                          enabled: false,
                        ),
                      ),
                    ),
                    // const SizedBox(width: 10), // Spacing between the fields
                    // Exemption No. takes 2/3 of the space
                    Expanded(
                      flex: 2,
                      child: ListTile(
                        title: TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Exemption No.'),
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
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Warehouse'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtWhse,
                          focusNode: _textFocusWhse,
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
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: barcodeScanningWhse,
                        child: Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
                // Row(
                //   children: [
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
                //     SizedBox(
                //       width: 10,
                //     ),
                //     SizedBox(
                //       width: 54,
                //       child: ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //           padding: EdgeInsets.zero,
                //         ),
                //         onPressed: () async {
                //           await scanAndSetToController(txtBin, type: 'bin');
                //         },
                //         child: Icon(Icons.camera_alt),
                //       ),
                //     ),
                //   ],
                // ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TypeAheadField<EpiGetBin>(
                          key: ValueKey(
                              'bins_${dropDownBins.length}_${txtWhse.text}'),
                          controller:
                              txtBin, // Connects directly to your global controller

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
                            return TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                labelText: 'Bin',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(137, 0, 0, 0)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                            );
                          },

                          suggestionsCallback: (search) {
                            if (search.isEmpty) {
                              return dropDownBins.cast<EpiGetBin>().toList();
                            }
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
                                style: const TextStyle(color: Colors.white60),
                              ),
                            );
                          },

                          onSelected: (option) {
                            setState(() {
                              txtBin.text = option.binNum;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 54,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () async {
                          await scanAndSetToController(txtBin, type: 'bin');
                        },
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TypeAheadField<EpiGetLot>(
                          controller: txtLot,
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
                              txtLot.text = option.lotNum;
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
                        onPressed: _lotEnabled
                            ? () async {
                                await scanAndSetToController(
                                  txtLot,
                                  type: 'lot',
                                );
                              }
                            : null,
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
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
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 0),
                    Expanded(
                      child: ListTile(
                        title: ElevatedButton(
                          // onPressed: () {},
                          onPressed: () async {
                            double remQty =
                                double.tryParse(txtRemainingQty.text) ?? 0.0;
                            double pickedQty =
                                double.tryParse(txtPickedQty.text) ?? 0.0;

                            double remaining = remQty - pickedQty;

                            try {
                              // 2. Attempt the backend submission first
                              bool isSuccess = await submitPickerUpdate();

                              // 3. If it succeeds, update the text field inside setState
                              if (isSuccess) {
                                setState(() {
                                  txtRemainingQty.text =
                                      remaining.toInt().toString();
                                });
                              }
                            } catch (error) {
                              // 4. Handle the error gracefully (the UI field remains untouched)
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Failed to update picker: $error')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            disabledBackgroundColor:
                                Colors.grey, // Disabled button color
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Pick',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                if (pickedItems.isNotEmpty) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: TextFormField(
                            decoration:
                                InputDecoration(labelText: 'DO Legal Number'),
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            controller: txtLegalNum,
                            enabled: false,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isAllSelected,
                          onChanged: _toggleSelectAll,
                        ),
                        const Text(
                          'Select All',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 500,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: populateMaterialPickingList(context),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: ElevatedButton(
                            // Only enable the button if at least one card is checked
                            onPressed: _selectedCards.values
                                    .any((checked) => checked)
                                ? () async {
                                    List<int> indexesToDelete = [];
                                    _selectedCards.forEach((index, isChecked) {
                                      if (isChecked) {
                                        indexesToDelete.add(index);
                                      }
                                    });

                                    indexesToDelete
                                        .sort((a, b) => b.compareTo(a));
                                    bool allSucceeded = true;

                                    for (int index in indexesToDelete) {
                                      final item = pickedItems[index];

                                      // 1. Safely handle potential null or missing values with fallback defaults
                                      final int packNum = int.tryParse(
                                              item['packNum']?.toString() ??
                                                  '') ??
                                          0;
                                      final String packLine =
                                          item['packLine']?.toString() ?? '';
                                      final String legalNum =
                                          item['legalNum']?.toString() ?? '';
                                      final String childKey1 =
                                          item['childKey1']?.toString() ?? '';

                                      // 2. Prevent sending the request if key identifiers are completely missing
                                      if (packNum == 0 || childKey1.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Cannot delete row: Missing reference data at item #$index.')),
                                        );
                                        allSucceeded = false;
                                        continue;
                                      }

                                      // 3. Execute Delete API Request
                                      List<dynamic> deleteResult =
                                          await DeletePickedLine(
                                        packNum: packNum,
                                        packLine: packLine,
                                        legalNum: legalNum,
                                        childKey1: childKey1,
                                        partNum:
                                            widget.pickerBaq.ud100aProductC ??
                                                '',
                                      );
                                      print("DELETED RESULT: ${item}");
                                      bool isSuccess = deleteResult[
                                          0]; // Extract the boolean status from the response array

                                      if (isSuccess) {
                                        setState(() {
                                          double currentRemaining =
                                              double.tryParse(
                                                      txtRemainingQty.text) ??
                                                  0.0;
                                          double itemQty = double.tryParse(
                                                  item["qty"]?.toString() ??
                                                      '') ??
                                              0.0;

                                          txtRemainingQty.text =
                                              (currentRemaining + itemQty)
                                                  .toInt()
                                                  .toString();
                                          pickedItems.removeAt(index);
                                        });
                                      } else {
                                        allSucceeded = false;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Failed to delete item: ${deleteResult[1]}')),
                                        );
                                      }
                                    }

                                    setState(() {
                                      _selectedCards.clear();
                                    });

                                    if (allSucceeded) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Selected line(s) deleted successfully.')),
                                      );
                                    }
                                  }
                                : null,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              disabledBackgroundColor: Colors.grey,
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(flex: 1),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: ElevatedButton(
                            onPressed: pickedItems.isNotEmpty
                                ? handlePrepareForLoading
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              disabledBackgroundColor: Colors.grey,
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text(
                              'Prepare for loading',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handlePrepareForLoading() async {
    if (pickedItems.isEmpty) {
      showAlertPopup(context, 'No Data', 'The picking list is empty.');
      return;
    }

    final firstItem = pickedItems.first;
    String key1Value = firstItem['packNum']?.toString().trim() ?? '';
    String key3Value = firstItem['legalNum']?.toString().trim() ?? '';

    if (key1Value.isEmpty || key3Value.isEmpty) {
      showAlertPopup(
        context,
        'Missing Data',
        'The list items are missing legalNum or pack reference fields.',
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      double actualRemaining = await getRemainingQty(
        key1: key1Value,
        key3: key3Value,
      );

      print("Remaining QTY: $actualRemaining");

      setState(() {
        txtRemainingQty.text = actualRemaining.toInt().toString();
        _saving = false;
      });

      // --- NEW LOGIC: Only show message if quantity is not 0 ---
      if (actualRemaining != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cant load because remaining qty is not 0'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // --- SUCCESS DIALOG: Triggered when remaining quantity is exactly 0 ---
        showDialog(
            context: context,
            barrierDismissible:
                false, // Prevents closing the dialog by tapping outside
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Items prepared for loading.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismisses the dialog

                      // TODO: Add any post-success actions here (e.g., clear list, navigate away)
                    },
                  ),
                ],
              );
            });
      }
    } catch (error) {
      setState(() {
        _saving = false;
      });
      showAlertPopup(
        context,
        'Error',
        'Failed to fetch remaining quantity: $error',
      );
    }
  }

  Future<bool> showInventoryWarning(String message) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Inventory Warning"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<bool> submitPickerUpdate() async {
    List<dynamic> _result;

    //Create lot if Track Lot = true and Lot does not exist
    if (txtLot.text != '' && _lotEnabled == true) {
      setState(() {
        _saving = true;
      });
      final String capturedPartNo = txtPart.text.trim();
      final String capturedLotNo = txtLot.text.trim();
      _result = await isPartLotExist(capturedPartNo, capturedLotNo);

      setState(() {
        _saving = false;
      });

      print("LOTNUM PICKER: ${capturedLotNo}");
      if (_result[0] == false) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LotCreation(capturedPartNo, capturedLotNo),
                fullscreenDialog: true));
        return false;
      }
    }

    setState(() {
      _saving = true;
    });

    try {
      print("PICKER: ${widget.pickerBaq}");
      final response = await createCustShipHeader(
        orderNum: int.parse(widget.pickerBaq.ud100aSoNoC ?? '0'),
        custId: widget.pickerBaq.ud100CustomerC ?? '',
        planId: widget.pickerBaq.ud100Key1 ?? "",
        lineNo: int.parse(widget.pickerBaq.ud100aSOLineC ?? '0'),
      );
      print("response shiphead: ${response}");
      var createLine = await createCustShipDtl(
        packNum: response["ShipHead"]["PackNum"],
        orderNum: int.parse(widget.pickerBaq.ud100aSoNoC ?? ""),
        orderLine: int.parse(widget.pickerBaq.ud100aSOLineC ?? ""),
        orderReleaseNum: int.parse(widget.pickerBaq.ud100aSOReleaseC ?? ""),
        whse: txtWhse.text,
        binNum: txtBin.text,
        lotNum: txtLot.text,
        planID: response["ShipHead"]["SD_PlanId_c"],
        childKey1: widget.pickerBaq.ud100aChildKey1 ?? "",
        // quantity: widget.pickerBaq.ud100aQuantityC?.toInt() ?? 0,
        quantity: int.parse(txtPickedQty.text),
        checkQty: response["Exists"],
        runSess: 1,
        remainingQty: txtRemainingQty.text,
      );

      final innerResponse = createLine["Response"] as Map<String, dynamic>?;

      // 2. FIX: Dig down one layer deeper into the "Value" map
      final valueMap = innerResponse?["Value"] as Map<String, dynamic>?;
      // 2. EXTRACT: Get the LineDesc string from the nested map
      final String? lineDesc = valueMap?["LineDesc"];
      print("response line desc: $lineDesc");
      if (lineDesc != null && lineDesc.startsWith("INVENTORY_WARNING:")) {
        bool proceed = await showInventoryWarning(
          lineDesc.replaceFirst("INVENTORY_WARNING: ", ""),
        );
        if (!proceed) {
          // User clicked No
          setState(() {
            _saving = false;
          });
          return false;
        }
        setState(() {
          _saving = true;
        });
        createLine = await createCustShipDtl(
            packNum: response["ShipHead"]["PackNum"],
            orderNum: int.parse(widget.pickerBaq.ud100aSoNoC ?? ""),
            orderLine: int.parse(widget.pickerBaq.ud100aSOLineC ?? ""),
            orderReleaseNum: int.parse(widget.pickerBaq.ud100aSOReleaseC ?? ""),
            whse: txtWhse.text,
            binNum: txtBin.text,
            lotNum: txtLot.text,
            planID: response["ShipHead"]["SD_PlanId_c"],
            childKey1: widget.pickerBaq.ud100aChildKey1 ?? "",
            // quantity: widget.pickerBaq.ud100aQuantityC?.toInt() ?? 0,
            quantity: int.parse(txtPickedQty.text),
            checkQty: false,
            runSess: 2,
            remainingQty: txtRemainingQty.text);
      }

      print("SHIPDTL PACKNUM $createLine");
      String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      final createUD103 = await CreatePickedTable(
        partNum: txtPart.text,
        packLine: createLine["PackLine"].toString(),
        pickedQty: double.tryParse(txtPickedQty.text) ?? 0,
        qty: double.tryParse(txtQty.text) ?? 0,
        remainingQty: double.tryParse(txtRemainingQty.text) ?? 0,
        uom: txtUom.text,
        taxCatId: txtTaxCat.text,
        whse: txtWhse.text,
        bin: txtBin.text,
        lot: txtLot.text,
        doLine: createLine["PackLine"].toString(),
        packNum: createLine["PackNum"],
        legalNum: widget.pickerBaq.legalNum ?? "",
        timeStamp: timeStamp,
      );

      print("UD103: $createUD103");

      setState(() {
        pickedItems.add({
          'part': txtPart.text,
          'whse': txtWhse.text,
          'bin': txtBin.text,
          'lot': txtLot.text,
          'qty': double.tryParse(txtPickedQty.text) ?? 0,
          'uom': txtUom.text,
          'doLine': createLine["PackLine"].toString(),
          'packNum': createLine["PackNum"],
          'packLine': createLine["PackLine"].toString(),
          'legalNum': widget.pickerBaq.legalNum,
          'childKey1': timeStamp,
        });

        _saving = false;
      });
      print("UD103 CREATION: $createUD103");
      setState(() {
        _saving = false;
      });
      String? legalNum2 = createLine["LegalNum"];
      print("Legalnum $legalNum");
      if (legalNum2 != null && legalNum2.isNotEmpty) {
        setState(() {
          txtLegalNum.text = legalNum2.toString();
        });
      }
      // await postUpdateReadyToInvoice(packNum: response["ShipHead"]["PackNum"]);
      if (response[0] == false) {
        print("RESPONSE: ${response[1]}");
        showAlertPopup(context, 'Error', 'Picker BAQ update : ' + response[1]);
        return false;
      }
      if (response["Exists"] == false) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            // Check if legal number exists and is not empty
            bool hasLegalNum = legalNum2 != null && legalNum2.isNotEmpty;

            return AlertDialog(
              title: Row(
                children: [
                  const SizedBox(width: 10),
                  // 1. CONDITIONAL TITLE: Changes depending on legal number presence
                  Text(hasLegalNum
                      ? 'Receipt Successful'
                      : 'Order Picking Successful'),
                ],
              ),
              content: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  // 2. CONDITIONAL CONTENT: Shows the legal number flow OR a simple success line
                  children: hasLegalNum
                      ? <TextSpan>[
                          const TextSpan(
                              text: 'The Legal Number generated is:\n\n'),
                          TextSpan(
                            text: legalNum2,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ]
                      : <TextSpan>[
                          const TextSpan(
                              text:
                                  'Your order has been successfully picked and processed.'),
                        ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      return true;
    } catch (e) {
      setState(() {
        _saving = false;
      });
      showAlertPopup(context, 'Exception', e.toString());
      return false;
    }
  }

  Widget populateMaterialPickingList(BuildContext context) {
    return ListView.builder(
      itemCount: pickedItems.length,
      itemBuilder: _getPickedTable,
      padding: EdgeInsets.zero,
    );
  }

  Widget _getPickedTable(BuildContext context, int index) {
    final item = pickedItems[index];

    bool isCardChecked = _selectedCards[index] ?? false;

    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(47, 85, 156, .9),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: 1,
                    color: Colors.white24,
                  ),
                ),
              ),
              child: Theme(
                data: ThemeData(
                  unselectedWidgetColor: Colors.white,
                ),
                child: Checkbox(
                  value: isCardChecked,
                  activeColor: Colors.white,
                  checkColor: Color.fromRGBO(47, 85, 156, 1),
                  onChanged: (bool? newValue) {
                    setState(() {
                      _selectedCards[index] = newValue ?? false;
                    });
                  },
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Part can remain from the controller
                  Text(
                    'Part: ${txtPart.text}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  // Use saved values
                  Text(
                    'Whse | Bin | Lot: '
                    '${item['whse']} | '
                    '${item['bin']} | '
                    '${item['lot']}',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  Text(
                    'Qty: ${item['qty']} ${item['uom']}',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  Text(
                    'DO Line: ${item['packLine']}',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setTrackLot() async {
    EpiPart _data = await getEpiPart(widget.pickerBaq.ud100aProductC ?? "");
    setState(() {
      _lotEnabled = _data.tracklots;
      if (_lotEnabled == false) {
        txtLot.text = '';
      }
    });
  }

  Future<void> scanAndSetToController(TextEditingController controller,
      {required String type}) async {
    try {
      ScanResult result = await BarcodeScanner.scan();
      print("SCAN RESULT: $result");
      if (result.rawContent.isNotEmpty) {
        final parts = result.rawContent.split('~');

        setState(() {
          if (type == 'warehouse' && parts.isNotEmpty) {
            controller.text = parts[0]; // HQ
          } else if (type == 'bin' && parts.length > 1) {
            controller.text = parts[1].replaceAll(",", ""); // LOAD1
          } else {
            controller.text = result.rawContent; // fallback
          }
        });
      } else {
        print('No barcode found');
      }
    } catch (e) {
      print('Scan error: $e');
    }
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
}
