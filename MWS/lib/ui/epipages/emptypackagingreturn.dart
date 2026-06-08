import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/ui/epipages/lotcreation.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EmptyPackaginGReturn extends StatefulWidget {
  const EmptyPackaginGReturn({super.key});

  @override
  State<EmptyPackaginGReturn> createState() => _EmptyPackagingReturnState();
}

class _EmptyPackagingReturnState extends State<EmptyPackaginGReturn> {
  bool _saving = false;
  bool _lotEnabled = false;
  final _partFocus = FocusNode();
  var txtCustId = TextEditingController();
  var txtReturnPart = TextEditingController();
  var txtDesc = TextEditingController();
  var txtLot = TextEditingController();
  var txtQty = TextEditingController();
  var txtUOM = TextEditingController();
  var txtWhseCode = TextEditingController();
  var txtBinNum = TextEditingController();
  var txtOrderNum = TextEditingController();
  var txtOrderLine = TextEditingController();
  var txtOrderRel = TextEditingController();
  var txtPackNum = TextEditingController();
  var txtPackLine = TextEditingController();

  @override
  void initState() {
    _partFocus.addListener(() {
      if (!_partFocus.hasFocus) {
        getEpiPart(txtReturnPart.text).then((result) {
          setState(() {
            _lotEnabled = result.tracklots;
            txtDesc.text = result.partdescription;
            if (_lotEnabled == false) txtLot.text = '';
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
        title: Text("Empty Packaging Return"),
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
                          decoration: InputDecoration(labelText: 'Customer'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtCustId,
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
                          decoration: InputDecoration(labelText: 'Description'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtDesc,
                          enabled: false,
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
                          decoration: InputDecoration(labelText: 'Lot'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtLot,
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
                          decoration: InputDecoration(labelText: 'Quantity'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtQty,
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
                          decoration: InputDecoration(labelText: 'Order Num'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtOrderNum,
                          enabled: false,
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
                          decoration: InputDecoration(labelText: 'Order Line'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtOrderLine,
                          enabled: false,
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
                              InputDecoration(labelText: 'Order Release'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtOrderRel,
                          enabled: false,
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
                          decoration: InputDecoration(labelText: 'Pack Num'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtPackNum,
                          enabled: false,
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
                          decoration: InputDecoration(labelText: 'Pack Line'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtPackLine,
                          enabled: false,
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
                          onPressed: submitData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            disabledBackgroundColor:
                                Colors.grey, // Disabled button color
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Receive',
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

    _result = await postPerformEmptyPackagingReturn(
      partNum: txtReturnPart.text,
      ium: txtUOM.text,
      tranQty: txtQty.text,
      warehouseCode: txtWhseCode.text,
      binNum: txtBinNum.text,
      desc: txtDesc.text,
      lotNum: txtLot.text,
      custId: txtCustId.text,
    );
  }
}
