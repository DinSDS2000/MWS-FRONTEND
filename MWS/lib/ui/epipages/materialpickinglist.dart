import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/data/classes/epipickerbaq.dart';
import 'package:flutter_epihhinventory/ui/epipages/materialpicking.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MaterialList extends StatefulWidget {
  const MaterialList({Key? key}) : super(key: key);

  @override
  State<MaterialList> createState() => _MaterialpickingState();
}

class _MaterialpickingState extends State<MaterialList> {
  bool _saving = false;
  String _oldPickerNo = '';
  String _oldOrderNum = '';
  String _oldTransporter = '';
  late EpiPickerBaqList _pickerBaq = EpiPickerBaqList(items: []);
  var txtPickerNo = new TextEditingController();
  var txtOrderNo = new TextEditingController();
  var txtTransporterNo = new TextEditingController();
  var txtNeedByDate = new TextEditingController();
  FocusNode _textFocusPickerNo = new FocusNode();
  FocusNode _textFocusOrderNo = new FocusNode();
  FocusNode _textFocusTransporterNo = new FocusNode();
  FocusNode _textFocusNeedByDate = new FocusNode();

  @override
  void initState() {
    txtPickerNo.addListener(onChangePickerNo);
    _textFocusPickerNo.addListener(onChangePickerNo);

    txtOrderNo.addListener(onChangeOrderNo);
    _textFocusOrderNo.addListener(onChangeOrderNo);

    txtTransporterNo.addListener(onChangeTransporterNo);
    _textFocusTransporterNo.addListener(onChangeTransporterNo);
    super.initState();
  }

  void onChangePickerNo() {
    if (!_textFocusPickerNo.hasFocus) {
      if (_oldPickerNo != txtPickerNo.text) {
        print(
            "Picker number changed from $_oldPickerNo to ${txtPickerNo.text}");
      }
      _oldPickerNo = txtPickerNo.text;
    }
  }

  void onChangeOrderNo() {
    if (!_textFocusOrderNo.hasFocus) {
      if (_oldOrderNum != txtOrderNo.text) {
        print("Order number changed from $_oldOrderNum to ${txtOrderNo.text}");
      }
      _oldOrderNum = txtOrderNo.text;
    }
  }

  void onChangeTransporterNo() {
    if (!_textFocusTransporterNo.hasFocus) {
      if (_oldTransporter != txtTransporterNo.text) {
        print(
            "Transporter number changed from $_oldTransporter to ${txtTransporterNo.text}");
      }
      _oldTransporter = txtTransporterNo.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Material List",
        ),
        automaticallyImplyLeading: false,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: TextFormField(
                        decoration: InputDecoration(labelText: 'Picker'),
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        controller: txtPickerNo,
                        focusNode: _textFocusPickerNo,
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
                        alignment: Alignment.center,
                      ),
                      child: Icon(Icons.camera_alt),
                      onPressed: () async {
                        await scanAndSetToController(txtPickerNo);
                      },
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
                      decoration: InputDecoration(labelText: 'Order No'),
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      controller: txtOrderNo,
                      focusNode: _textFocusOrderNo,
                    ),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                      ),
                      child: Icon(Icons.camera_alt),
                      onPressed: () async {
                        await scanAndSetToController(txtOrderNo);
                      },
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
                      decoration: InputDecoration(labelText: 'Transporter'),
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      controller: txtTransporterNo,
                      focusNode: _textFocusTransporterNo,
                    ),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                      ),
                      child: Icon(Icons.camera_alt),
                      onPressed: () async {
                        await scanAndSetToController(txtTransporterNo);
                      },
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
                      decoration: InputDecoration(labelText: 'Date'),
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      controller: txtNeedByDate,
                      focusNode: _textFocusNeedByDate,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          String FormattedDate =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                          txtNeedByDate.text = FormattedDate;
                        }
                      },
                    ),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                      ),
                      child: Icon(Icons.camera_alt),
                      onPressed: () async {
                        await scanAndSetToController(txtTransporterNo);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
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
                          setState(() {
                            _saving = true;
                          });
                          List<dynamic> _result = await getEpiPickerList(
                            picker: txtPickerNo.text,
                            orderNum: txtOrderNo.text,
                            transporter: txtTransporterNo.text,
                            date: txtNeedByDate.text.isNotEmpty
                                ? DateFormat('dd-MM-yyyy')
                                    .parse(txtNeedByDate.text)
                                : null,
                          );
                          if (_result[0] == false) {
                            _pickerBaq = _result[1];
                          } else {
                            showAlertPopup(context, 'Error',
                                'Picker Baq List: ' + _result[1]);
                          }
                          setState(() {
                            _saving = false;
                          });
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => MaterialPicking()));
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
            ],
          ),
        ),
      ),
    );
  }

  populateMaterialPickingList(BuildContext context) {
    int _rowCnt = 0;
    _rowCnt = _pickerBaq.items.length;
    return ListView.builder(
      itemCount: _rowCnt,
      itemBuilder: _getPickerBaqListValue,
      padding: EdgeInsets.all(0.0),
    );
  }

  Widget _getPickerBaqListValue(BuildContext context, int index) {
    final item = _pickerBaq.items[index];
    final part = item.ud100aProductC;
    final orderLine = item.ud100aSOLineC;
    final orderRel = item.ud100aSOReleaseC;
    final customer = item.custName;
    final transporter = item.ud100aTransporterC;
    final planID = item.ud100Key1;
    final qty = item.ud100aQuantityC;
    final orderNum = item.ud100aSoNoC;
    final comment = item.orderHedOrderComment;
    final exemptionNo = item.orderRelExemptionNo;
    final warehouseCode = item.warehouseCode;

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
                    'Plan ID: ' + ('${planID}'),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Order No: ' + ('${orderNum}'),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Order Line/Rel: ' + ('${orderLine} / ${orderRel}'),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Quantity: ' + ('${qty}'),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Customer: ' + (customer ?? ''),
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
                    'Transporter: ' + (transporter ?? ''),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Exemption No: ' + (exemptionNo ?? ''),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Warehouse: ' + (warehouseCode ?? ''),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Comment: ' + (comment ?? ''),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MaterialPicking(
                  pickerBaq: item,
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
