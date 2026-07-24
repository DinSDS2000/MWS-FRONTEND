import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/epipart.dart';
import 'package:flutter_epihhinventory/data/classes/epipickerbaq.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/globals.dart' as _globals;
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
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
  List<dynamic> dropDownBins = [];
  String? selectedBin;
  bool isLoadingBins = true;
  late TextEditingController txtPart;
  late TextEditingController txtDesc;
  late TextEditingController txtQty;
  late TextEditingController txtUom;
  late TextEditingController txtExemptionNo;
  var txtWhse = new TextEditingController();
  var txtBin = new TextEditingController();
  var txtLot = new TextEditingController();

  var _txtFocusPartNo = new FocusNode();
  FocusNode _textFocusWhse = new FocusNode();

  @override
  void initState() {
    txtPart = TextEditingController(text: widget.pickerBaq.ud100aProductC);
    txtDesc = TextEditingController(text: widget.pickerBaq.ud100aProductDescC);
    txtQty = TextEditingController(
        text: widget.pickerBaq.ud100aQuantityC.toString());
    txtUom = TextEditingController(text: widget.pickerBaq.ud100aUomC);
    txtExemptionNo =
        TextEditingController(text: widget.pickerBaq.orderRelExemptionNo);

    txtWhse.addListener(onChangeWhse);
    _textFocusWhse.addListener(onChangeWhse);
    setTrackLot();
    fetchBinsOnLoad();
    super.initState();
  }

  void onChangeWhse() {
    if (!_textFocusWhse.hasFocus && txtWhse.text != '') {
      splitWhse(txtWhse.text);
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
    return result;
  }

  void fetchBinsOnLoad() {
    // Use the part number loaded into your controller text
    getInventoryQtyAdjForPart(txtPart.text).then((response) {
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
                  ],
                ),
                Row(
                  children: [
                    Expanded(
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
                        child: Autocomplete<Map<String, dynamic>>(
                          // CHANGED: dynamic to Map<String, dynamic>
                          // Displays only the BinNum string inside the text field upon selection
                          displayStringForOption:
                              (Map<String, dynamic> option) =>
                                  option['BinNum'].toString(),

                          optionsBuilder: (TextEditingValue textEditingValue) {
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
                              if (textEditingController.text != txtBin.text) {
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
                                labelText: 'Bin',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(137, 0, 0, 0)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                              // Process submission only if they explicitly press "Enter" or "Done" on their keyboard
                              onFieldSubmitted: (String value) {
                                onFieldSubmitted();
                              },
                            );
                          },

                          optionsViewBuilder: (context, onSelected, options) {
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
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Lot'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtLot,
                          enabled: _lotEnabled,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 54,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () async {
                          await scanAndSetToController(txtLot, type: 'lot');
                        },
                        child: Icon(Icons.camera_alt),
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
                          onPressed: () async {
                            await submitPickerUpdate();
                            txtWhse.text = "";
                            txtBin.text = "";
                            txtLot.text = "";
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
              ],
            ),
          ),
        ),
      ),
    );
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

  Future<void> submitPickerUpdate() async {
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
        quantity: widget.pickerBaq.ud100aQuantityC?.toInt() ?? 0,
        checkQty: response["Exists"],
        runSess: 1,
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
          return;
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
          quantity: widget.pickerBaq.ud100aQuantityC?.toInt() ?? 0,
          checkQty: false,
          runSess: 2,
        );
      }

      setState(() {
        _saving = false;
      });
      final String? legalNum = createLine["LegalNum"];
      print("Legalnum $legalNum");
      if (response[0] == false) {
        print("RESPONSE: ${response[1]}");
        showAlertPopup(context, 'Error', 'Picker BAQ update : ' + response[1]);
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // Check if legal number exists and is not empty
          bool hasLegalNum = legalNum != null && legalNum.isNotEmpty;

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
                          text: legalNum,
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
                  Navigator.pop(context, 'A');
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        _saving = false;
      });
      showAlertPopup(context, 'Exception', e.toString());
    }
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
