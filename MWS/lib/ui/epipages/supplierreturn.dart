import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SupplierReturn extends StatefulWidget {
  const SupplierReturn({super.key});

  @override
  State<SupplierReturn> createState() => _SupplierReturnState();
}

class _SupplierReturnState extends State<SupplierReturn> {
  bool _saving = false;
  bool _lotEnabled = false;
  final _partFocus = FocusNode();
  var txtSupplierId = TextEditingController();
  var txtReturnPart = TextEditingController();
  var txtReturnLot = TextEditingController();
  var txtDesc = TextEditingController();
  var txtReturnQty = TextEditingController();
  var txtUOM = TextEditingController();
  var txtWhseCode = TextEditingController();
  var txtBinNum = TextEditingController();
  var txtPONum = TextEditingController();
  var txtPackSlipNum = TextEditingController();

  @override
  void initState() {
    _partFocus.addListener(() {
      if (!_partFocus.hasFocus) {
        getEpiPart(txtReturnPart.text).then((result) {
          setState(() {
            _lotEnabled = result.tracklots;
            txtDesc.text = result.partdescription;
            if (_lotEnabled == false) txtReturnLot.text = '';
          });
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _partFocus.dispose();
    txtReturnPart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supplier Return"),
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
                          decoration: InputDecoration(labelText: 'Supplier'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtSupplierId,
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
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Return Part'),
                          obscureText: false,
                          focusNode: _partFocus,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtReturnPart,
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
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Return Lot'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtReturnLot,
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
                        // Job No.
                        child: Icon(Icons.camera_alt),
                        onPressed: () {},
                      ),
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
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Return Qty'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          enabled: true,
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
                          controller: txtUOM,
                          autocorrect: false,
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
                          controller: txtWhseCode,
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
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Bin'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtBinNum,
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
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'PO Num'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtPONum,
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
                        onPressed: () {},
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
                              InputDecoration(labelText: 'Pack Slip Num'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtPackSlipNum,
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
                        onPressed: () {},
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
                          onPressed: () async {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            disabledBackgroundColor:
                                Colors.grey, // Disabled button color
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Return',
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

  Future submitData() async {
    List<dynamic> _result;

    _result = await postPerformCustReplaceItem(
      supplierId: txtSupplierId.text,
      partNum: txtReturnPart.text,
      lotNum: txtReturnLot.text,
      desc: txtDesc.text,
      qty: txtReturnQty.text,
      uom: txtUOM.text,
      whseCode: txtWhseCode.text,
      binNum: txtBinNum.text,
      packNum: txtPackSlipNum.text,
    );
  }
}
