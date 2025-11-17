import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/data/classes/epishipdtl.dart';
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
    txtPart = TextEditingController(text: widget.shipmentDetail.shipDtlPartNum);
    txtDesc =
        TextEditingController(text: widget.shipmentDetail.shipDtlLineDesc);
    txtUom = TextEditingController(text: widget.shipmentDetail.shipDtlSalesUM);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material Loading'),
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
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Lorry'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtLorry,
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
                          decoration: InputDecoration(labelText: 'Driver Name'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtDriver,
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
                          decoration: InputDecoration(labelText: 'Transporter'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtTransporter,
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
                        onPressed: () => _showTransporterDialog(context),
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
      print("objecsdasdt");
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
