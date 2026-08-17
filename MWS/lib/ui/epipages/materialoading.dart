import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/data/classes/epishipdtl.dart';
import 'package:flutter_epihhinventory/data/classes/epiusercodes.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MaterialLoading extends StatefulWidget {
  final EpiShipDtl shipmentDetail;
  const MaterialLoading({Key? key, required this.shipmentDetail})
      : super(key: key);

  @override
  State<MaterialLoading> createState() => _MaterialLoadingState();
}

class _MaterialLoadingState extends State<MaterialLoading> {
  bool _saving = false;
  bool _isLoading = false;
  List<UserCodes> userCodesList = [];
  List<UserCodes> lorryCodesList = [];
  List<Transporter> transporterList = [];
  Transporter? _selectedTransporter;
  late TextEditingController txtPart;
  late TextEditingController txtDesc;
  var txtQty = new TextEditingController();
  late TextEditingController txtUom;
  var txtLorry = new TextEditingController();
  var txtDriver = new TextEditingController();
  var txtTransporter = new TextEditingController();

  @override
  void initState() {
    initPageData();
    txtPart = TextEditingController(text: widget.shipmentDetail.shipDtlPartNum);
    txtDesc =
        TextEditingController(text: widget.shipmentDetail.shipDtlLineDesc);
    txtUom = TextEditingController(text: widget.shipmentDetail.shipDtlIUM);
    super.initState();
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
      _isLoading = true;
    });
    try {
      final results = await Future.wait<dynamic>([
        _loadUserCodes('DriverName'),
        _loadUserCodes('LorryNo'),
        getTransporters(),
      ]);

      setState(() {
        userCodesList = results[0];
        lorryCodesList = results[1];
        transporterList = results[2];
      });
    } catch (e) {
      print('Error executing page load pipeline: $e');
    } finally {
      setState(() {
        _isLoading = false; // Turn off HUD loader spinner overlay
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipment Loading'),
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
                          enabled: false,
                        ),
                      ),
                    )
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
                    )
                  ],
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: ListTile(
                //         title: TextFormField(
                //           decoration: InputDecoration(labelText: 'Lorry'),
                //           obscureText: false,
                //           keyboardType: TextInputType.text,
                //           autocorrect: false,
                //           controller: txtLorry,
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: ListTile(
                //         title: TextFormField(
                //           decoration: InputDecoration(labelText: 'Driver Name'),
                //           obscureText: false,
                //           keyboardType: TextInputType.text,
                //           autocorrect: false,
                //           controller: txtDriver,
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Autocomplete<UserCodes>(
                          // Displays the ID code (e.g., Plate Number) inside the text box when selected
                          displayStringForOption: (UserCodes code) =>
                              code.codeDesc,

                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<UserCodes>.empty();
                            }
                            // Filters your stored lorryCodesList locally by ID or Description
                            return lorryCodesList.where((UserCodes code) {
                              return code.codeId.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase()) ||
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
                                controller: textEditingController,
                                focusNode: focusNode,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                decoration: const InputDecoration(
                                  labelText: 'Lorry',
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(137, 0, 0, 0))),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                ),
                              ),
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
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Autocomplete<UserCodes>(
                          // Displays the clear text description inside the input box when selected
                          displayStringForOption: (UserCodes code) =>
                              code.codeDesc,

                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<UserCodes>.empty();
                            }
                            // Filters your stored userCodesList locally by ID or Description
                            return userCodesList.where((UserCodes code) {
                              return code.codeId.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase()) ||
                                  code.codeDesc.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase());
                            });
                          },

                          // Capture item when clicked to save properties locally
                          onSelected: (UserCodes selection) {
                            setState(() {
                              txtDriver.text = selection.codeDesc;
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
                                controller: textEditingController,
                                focusNode: focusNode,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                decoration: const InputDecoration(
                                  labelText: 'Driver Name',
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(137, 0, 0, 0))),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                ),
                              ),
                            );
                          },

                          optionsViewBuilder: (context, onSelected, options) {
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
                  ],
                ),

                // Row(
                //   children: [
                //     Expanded(
                //       child: ListTile(
                //         title: TextFormField(
                //           decoration: InputDecoration(labelText: 'Transporter'),
                //           obscureText: false,
                //           keyboardType: TextInputType.text,
                //           autocorrect: false,
                //           controller: txtTransporter,
                //         ),
                //       ),
                //     ),
                // SizedBox(
                //   width: 54,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       padding: EdgeInsets.zero,
                //     ),
                //     child: Icon(Icons.search),
                //     onPressed: () => _showTransporterDialog(context),
                //   ),
                // ),
                //   ],
                // ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Autocomplete<Transporter>(
                          // Displays the ID code (e.g., Plate Number) inside the text box when selected
                          displayStringForOption: (Transporter trans) =>
                              trans.name,

                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<Transporter>.empty();
                            }
                            // Filters your stored lorryCodesList locally by ID or Description
                            return transporterList.where((Transporter trans) {
                              return trans.id.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase()) ||
                                  trans.name.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase());
                            });
                          },

                          // Capture item when clicked to save properties locally
                          onSelected: (Transporter selection) {
                            setState(() {
                              txtTransporter.text = selection
                                  .name; // Assigns selected Lorry plate/ID directly
                              _selectedTransporter = selection;
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
                                controller: textEditingController,
                                focusNode: focusNode,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                decoration: const InputDecoration(
                                  labelText: 'Transporter',
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(137, 0, 0, 0))),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                ),
                              ),
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
                                      final Transporter option =
                                          options.elementAt(index);
                                      return ListTile(
                                        title: Text(
                                          option.id,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                        ),
                                        subtitle: Text(
                                          option.name,
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
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Load Quantity'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtQty,
                        ),
                      ),
                    )
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
                    )
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
                            txtQty.text = "";
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            disabledBackgroundColor:
                                Colors.grey, // Disabled button color
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Load',
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

  Future<void> submitPickerUpdate() async {
    setState(() {
      _saving = true;
    });

    try {
      print("objecsdasdt: ${widget.shipmentDetail.shipHeadSDPlanIdC}");
      final response = await updateShipDtlQty(
          packLine: (widget.shipmentDetail.shipDtlPackLine ?? 0),
          packNum: (widget.shipmentDetail.shipHeadPackNum ?? 0),
          qty: double.parse(txtQty.text),
          lorry: txtLorry.text,
          driver: txtDriver.text,
          transporter: _selectedTransporter?.id ?? '',
          planID: (widget.shipmentDetail.shipHeadSDPlanIdC ?? ''),
          childKey: (widget.shipmentDetail.shipDtlOrderLine.toString()));

      print('responseee: ${response}');

      setState(() {
        _saving = false;
      });

      if (response[0] == false) {
        showAlertPopup(context, 'Error', 'Picker BAQ update : ' + response[1]);
        return;
      }

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Success"),
          content: Text("Material Load Successfully"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() {
        _saving = false;
      });
      showAlertPopup(context, 'Exception', e.toString());
    }
  }

  void _showTransporterDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return FutureBuilder<List<Transporter>>(
          future: getTransporters(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AlertDialog(
                title: Text('Loading Transporters...'),
                content: SizedBox(
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to load transporters: ${snapshot.error}'),
                actions: [
                  TextButton(
                    child: Text('Close'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              );
            } else {
              List<Transporter> transporterList = snapshot.data ?? [];

              return AlertDialog(
                title: Text('Select Transporter'),
                content: DropdownButton<Transporter>(
                  isExpanded: true,
                  value: getMatchingTransporter(transporterList),
                  hint: Text('Please choose a transporter'),
                  onChanged: (Transporter? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedTransporter = newValue;
                        txtTransporter.text = newValue.name;
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  items: transporterList.map((t) {
                    return DropdownMenuItem<Transporter>(
                      value: t,
                      child: Text(t.name),
                    );
                  }).toList(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  )
                ],
              );
            }
          },
        );
      },
    );
  }

  Transporter? getMatchingTransporter(List<Transporter> list) {
    try {
      return list.firstWhere((t) => t.id == _selectedTransporter?.id);
    } catch (_) {
      return null;
    }
  }
}
