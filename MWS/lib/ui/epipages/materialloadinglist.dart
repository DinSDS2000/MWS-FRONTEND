import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/data/classes/epishipdtl.dart';
import 'package:flutter_epihhinventory/ui/epipages/materialoading.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Materialloadinglist extends StatefulWidget {
  const Materialloadinglist({Key? key}) : super(key: key);

  @override
  State<Materialloadinglist> createState() => _MaterialloadinglistState();
}

class _MaterialloadinglistState extends State<Materialloadinglist> {
  bool _saving = false;
  late EpiShipDtlList shipmentDetail = EpiShipDtlList(items: []);
  var txtPlanID = new TextEditingController();
  var txtLorry = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material Loading List'),
        automaticallyImplyLeading: false,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SafeArea(
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(labelText: 'Plan ID'),
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      controller: txtPlanID,
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
                    onPressed: () async {
                      await scanAndSetToController(txtPlanID);
                    },
                    child: Icon(Icons.camera_alt),
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
                    onPressed: () async {
                      await scanAndSetToController(txtLorry);
                    },
                    child: Icon(Icons.camera_alt),
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
                        setState(() {
                          _saving = true;
                        });
                        List<dynamic> _result = await getShipmentDetails(
                            planID: txtPlanID.text, lorryID: txtLorry.text);
                        if (_result[0] == false) {
                          shipmentDetail = _result[1];
                        } else {
                          showAlertPopup(
                              context, 'Error', 'Picker List: ' + _result[1]);
                        }
                        setState(() {
                          _saving = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                        disabledBackgroundColor:
                            Colors.grey, // Disabled button color
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Retrieve',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: populateMaterialPickingList(context),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  populateMaterialPickingList(BuildContext context) {
    int _rowCnt = 0;
    _rowCnt = shipmentDetail.items.length;
    return ListView.builder(
      itemCount: _rowCnt,
      itemBuilder: _getPickerBaqListValue,
      padding: EdgeInsets.all(0.0),
    );
  }

  Widget _getPickerBaqListValue(BuildContext context, int index) {
    final item = shipmentDetail.items[index];

    final part = item.shipDtlPartNum;
    final pack = item.shipHeadPackNum;
    final quantity = item.ud100aQuantityC;
    final customer = item.custName;
    final lorryNum = item.ud100aLorryC;

    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(47, 85, 156, .9)),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
              border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24),
              ),
            ),
            child: Icon(
              Icons.library_books,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Part: ' + (part ?? ''),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Pack ID: ' + (pack != null ? pack.toString() : '0'),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Quantity: ' +
                        (quantity != null ? quantity.toString() : '0'),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Customer: ' + (customer.toString()),
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Lorry: ${lorryNum == null || lorryNum.isEmpty ? '0' : lorryNum}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            print("PLAN ID: ${item.shipHeadSDPlanIdC}");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MaterialLoading(
                  shipmentDetail: item,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> scanAndSetToController(TextEditingController controller) async {
    try {
      ScanResult result = await BarcodeScanner.scan();

      if (result.rawContent.isNotEmpty) {
        setState(() {
          controller.text = result.rawContent;
        });
      } else {
        print('No barcode found');
      }
    } catch (e) {
      print('Scan error: $e');
    }
  }
}
