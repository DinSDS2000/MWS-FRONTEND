import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/data/classes/episitereceipt.dart';
import 'package:flutter_epihhinventory/ui/epipages/attachmentlist.dart';
import 'package:flutter_epihhinventory/utils/getepidata.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_epihhinventory/utils/postepidata.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';

class SiteReceiptList extends StatefulWidget {
  const SiteReceiptList({super.key});

  @override
  State<SiteReceiptList> createState() => _SitereceiptlistState();
}

class _SitereceiptlistState extends State<SiteReceiptList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _barcodeError = "";
  String _oldRefNo = '';
  bool _saving = false;

  List<FileSystemEntity> file = [];
  String directory = "";
  Map<String, int> _map = {};
  DateTime selectedDate = DateTime.now();
  DateFormat formatter = DateFormat('dd/MM/yyyy');

  EpiSiteReceiptList? _listRef;

  var txtRefNo = new TextEditingController();
  var txtDONo = new TextEditingController();
  var txtDateRcv = new TextEditingController();
  var txtRcvdQty = new TextEditingController();

  FocusNode _textFocusRefNo = new FocusNode();
  FocusNode _textFocusDate = new FocusNode();
  FocusNode _textFocusDoNo = new FocusNode();

  @override
  void initState() {
    txtRefNo.addListener(onChangeRefNo);
    _textFocusRefNo.addListener(onChangeRefNo);
    txtDateRcv.text = formatter.format(selectedDate);
    txtRcvdQty.text = '0';

    super.initState();
  }

  void onChangeRefNo() {
    if (!_textFocusRefNo.hasFocus) {
      _oldRefNo = txtRefNo.text;
    } else {
      if (_oldRefNo != txtRefNo.text) {
        if (_listRef != null) {
          setState(() {
            _listRef?.episitereceiptlist.clear();
          });
        }

        getRef(txtRefNo.text);
      }
    }
  }

  Future<void> _listOfFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final tempFiles = Directory(directory.path).listSync();

    // Clear previous list
    file.clear();

    final prefix = txtRefNo.text; // fallback if null

    if (prefix.isEmpty) return; // nothing to filter

    // Filter files that match the prefix
    file.addAll(tempFiles.where((f) {
      final fileName =
          f.uri.pathSegments.isNotEmpty ? f.uri.pathSegments.last : '';
      if (fileName.isEmpty) return false;
      final filePrefix = fileName.split('_').first.split('-').first;
      return filePrefix == prefix;
    }));

    // Map each seqno to the number of matching files
    _map = {
      for (var receipt in (_listRef?.episitereceiptlist ?? []))
        receipt.seqno ?? '': file.where((f) {
          final fileName =
              f.uri.pathSegments.isNotEmpty ? f.uri.pathSegments.last : '';
          if (fileName.isEmpty) return false;
          final filePrefix = fileName.split('_').first;
          return filePrefix == '${prefix}-${receipt.seqno ?? ''}';
        }).length
    };

    setState(() {});
  }

  Future getRef(String refnum) async {
    // List<dynamic> _result;

    // _result = await getEpiSiteReceiptRest(refnum);

    // if (_result[0] == false) {
    //   EpiSiteReceiptList _data = _result[1];

    //   txtRefNo.text = _data.episitereceiptlist[0].refno;
    // }
  }

  Future<void> _displayQtyToSubmitDialog(
    BuildContext context,
    String seqNo,
    String description,
    num rcvdQty,
  ) async {
    txtRcvdQty.text = rcvdQty.toString();
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Quantity Received:'),
          content: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Row(children: <Widget>[Expanded(child: Text(description))]),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    SizedBox(width: 60),
                    Expanded(
                      child: TextFormField(
                        controller: txtRcvdQty,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter Quantity To Submit",
                        ),
                      ),
                    ),
                    SizedBox(width: 60),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                bool success = false;

                for (int i = 0; i < _listRef!.episitereceiptlist.length; i++) {
                  String listSeqNo =
                      _listRef!.episitereceiptlist[i].seqno ?? '';

                  if (listSeqNo == seqNo) {
                    num totalQty = num.parse(txtRcvdQty.text) +
                        (_listRef!.episitereceiptlist[i].rcvdqty ?? 0);

                    if (totalQty >
                        (_listRef!.episitereceiptlist[i].tranqty ?? 0)) {
                      showAlertPopup(
                        context,
                        'Error',
                        'Total submit quantity is more than received quantity.',
                      );
                    } else {
                      setState(() {
                        _listRef!.episitereceiptlist[i].submitqty = num.parse(
                          txtRcvdQty.text,
                        );
                        _listRef!.episitereceiptlist[i].fullrcv = false;
                      });

                      if (totalQty == _listRef!.episitereceiptlist[i].tranqty) {
                        _listRef!.episitereceiptlist[i].fullrcv = true;
                      }
                      success = true;
                      break;
                    }
                  }
                }
                if (success) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        txtDateRcv.text = formatter.format(selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Site Receipt List",
        ),
        automaticallyImplyLeading: false,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'Ref No.'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtRefNo,
                          focusNode: _textFocusRefNo,
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
                        child: Icon(Icons.camera_alt),
                        onPressed: barcodeScanningRefNo,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Date Received'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          focusNode: _textFocusDate,
                          controller: txtDateRcv,
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
                        child: Icon(Icons.date_range),
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration: InputDecoration(labelText: 'DO No.'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          focusNode: _textFocusDoNo,
                          controller: txtDONo,
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
                        child: Icon(Icons.camera_alt),
                        onPressed: barcodeScanningRefNo,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: ElevatedButton(
                          onPressed: () async {
                            if (txtRefNo.text.isNotEmpty) {
                              setState(() {
                                _saving = true;
                              });

                              // Call the API
                              List<dynamic> _result =
                                  await getEpiSiteReceiptRest(txtRefNo.text);

                              if (_result.isNotEmpty) {
                                // _result[1] should be your EpiSiteReceiptList
                                _listRef = _result[1] as EpiSiteReceiptList;
                              }

                              // Populate files map
                              await _listOfFiles();

                              // Rebuild the UI with the new data
                              setState(() {
                                _saving = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Retrieve',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: ElevatedButton(
                          onPressed: submitDataRest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Button color
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: new Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: populateSiteReceiptList(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  populateSiteReceiptList(BuildContext context) {
    int _rowCnt = 0;
    if (_listRef != null) {
      _rowCnt = _listRef!.episitereceiptlist.length;
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _rowCnt,
      itemBuilder: _getSiteReceiptListValue,
      padding: EdgeInsets.all(0.0),
    );
  }

  Widget _getSiteReceiptListValue(BuildContext context, int index) {
    String? _listPartNum = '';
    String _listPartDesc = '';
    String _listWhse = '';
    String _listBin = '';
    num _listQty = 0.00;
    String _listUOM = '';
    String _listSeqNo = '';
    num _listRcvdQty = 0.00;
    num _qtyToSubmit = 0.00;
    bool _fullRcv = false;
    print("list ref:" + (_listRef!.episitereceiptlist[index].partnum ?? ''));
    if (_listRef != null) {
      _listPartNum = _listRef!.episitereceiptlist[index].partnum ?? '';
      _listPartDesc = _listRef!.episitereceiptlist[index].partdescription ?? '';
      _listWhse = _listRef?.episitereceiptlist[index].whsedescription ?? '';
      _listBin = _listRef?.episitereceiptlist[index].bindescription ?? '';
      _listQty = _listRef!.episitereceiptlist[index].tranqty ?? 0;
      _listUOM = _listRef!.episitereceiptlist[index].uom ?? '';
      _listSeqNo = _listRef!.episitereceiptlist[index].seqno ?? '';
      _listRcvdQty = _listRef!.episitereceiptlist[index].rcvdqty ?? 0;
      _qtyToSubmit = _listRef!.episitereceiptlist[index].submitqty ?? 0;
      _fullRcv = _listRef!.episitereceiptlist[index].fullrcv ?? false;
    }

    return new Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _displayQtyToSubmitDialog(
              context,
              _listSeqNo,
              _listPartNum! + ' : ' + _listPartDesc,
              _qtyToSubmit,
            );
          });
        },
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(47, 85, 156, .9)),
          child: ListTile(
            isThreeLine: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      cameraCapture(_listSeqNo);
                    },
                    child: Icon(Icons.add_a_photo, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      _textFocusRefNo.unfocus();
                      _textFocusDate.unfocus();
                      _textFocusDoNo.unfocus();
                      String prefix = txtRefNo.text + '-' + _listSeqNo;
                      //final foundFile = file.where((element) => element.toString().split('/').last.split('_').first == prefix).toList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttachmentList(prefix: prefix),
                          fullscreenDialog: true,
                        ),
                      ).then((value) {
                        _listOfFiles();
                      });
                    },
                    child: new Stack(
                      children: <Widget>[
                        Badge(
                          isLabelVisible: _map[_listSeqNo] != 0,
                          label: _map[_listSeqNo] == 0
                              ? null
                              : Text(
                                  _map[_listSeqNo].toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                          backgroundColor: Colors.green,
                          child: Icon(Icons.view_list, color: Colors.white),
                        ),
                        new Visibility(
                          visible: false, //_map[_listSeqNo] == 0 ? false: true,
                          child: new Positioned(
                            top: 2.0,
                            right: 2.0,
                            child: new Center(
                              child: new Text(
                                _map[_listSeqNo].toString(),
                                style: new TextStyle(
                                  color: Colors.green,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            title: Text(
              _listPartNum + ' : ' + _listPartDesc,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          'Qty Issued:',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Qty To Submit:',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Fully Received',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _listQty.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _qtyToSubmit.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    Container(
                      child: Checkbox(
                        value: _fullRcv,
                        onChanged: null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // trailing:
            //     Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
            // onTap: () {
            // },
          ),
        ),
      ),
    );
  }

  Future<void> cameraCapture(String seqNo) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile == null) return; // user cancelled

      // Create filename prefix
      String prefix = txtRefNo.text + '-' + seqNo;

      // Get the app storage directory
      final directory = await getApplicationDocumentsDirectory();

      // Create a unique filename with the prefix
      final String fileName =
          '${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String savePath = '${directory.path}/$fileName';

      // Save image to the app directory
      final File savedFile = await File(pickedFile.path).copy(savePath);

      print("✅ Saved image: ${savedFile.path}");
      await _listOfFiles();
      setState(() {});
      // After saving, refresh attachment list
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => AttachmentList(prefix: prefix),
      //     fullscreenDialog: true,
      //   ),
      // );
    } catch (e) {
      print(" Error saving image: $e");
    }
  }

  Future submitDataRest() async {
    if (file.isEmpty) {
      showAlertPopup(
        context,
        'Error',
        'There must be at least ONE attachment to submit.',
      );
      return;
    }

    setState(() {
      _saving = true; // <-- TURN ON ONCE
    });

    bool success = true;

    try {
      for (int i = 0; i < (_listRef?.episitereceiptlist.length ?? 0); i++) {
        num recQty = _listRef?.episitereceiptlist[i].submitqty ?? 0;

        if (recQty <= 0) continue;

        String seqNo = _listRef?.episitereceiptlist[i].seqno ?? '';
        bool fullRcv = _listRef?.episitereceiptlist[i].fullrcv ?? false;

        if (txtRefNo.text.isEmpty || txtDateRcv.text.isEmpty) {
          success = false;
          showAlertPopup(
            context,
            'Error',
            'Process Site Receipt: Ref No. and Date Received cannot be blank!',
          );
          return;
        }

        List<dynamic> _result = await postSiteReceiptDtlRest(
          txtRefNo.text,
          txtDONo.text,
          seqNo,
          selectedDate,
          recQty,
          '',
          fullRcv,
        );

        if (_result[0] == false) {
          success = false;
          showAlertPopup(
            context,
            'Error',
            'Process Site Receipt: ' + _result[1][0],
          );
          return;
        }

        // Upload attachments
        var responseBody = jsonDecode(_result[1]);
        var data = responseBody['value'][0];

        for (int f = file.length - 1; f >= 0; f--) {
          File fileItem = File(file[f].path);

          String fileName = fileItem.path.split('/').last;
          String fileNamePrefix = fileName.split('_').first;
          String prefix = '${txtRefNo.text}-$seqNo';

          if (fileNamePrefix != prefix) continue;

          String base64Image = base64Encode(fileItem.readAsBytesSync());

          List<dynamic> _attchresult = await uploadSiteReceiptAttachmentRest(
            '',
            'UD09',
            fileName.replaceAll("'", ""),
            base64Image,
            data['Key1'],
            data['Key2'],
            data['Key3'],
            data['Key4'],
            data['Key5'],
          );

          if (_attchresult[0] == false) {
            success = false;
            showAlertPopup(
              context,
              'Error',
              'Process PO Receipt Detail: ' + _attchresult[1][0],
            );
            return;
          }

          fileItem.deleteSync(recursive: true);
        }
      }

      if (success) {
        showOKDialog(context, 'Success', 'Transactions are successful.');
      }
    } finally {
      // <-- ALWAYS turn off loader at the end
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  showOKDialog(BuildContext context, String title, String detail) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context, 'A');
        Navigator.pop(context, 'A');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(detail),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future barcodeScanningRefNo() async {
    _barcodeError = '';
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() {
        txtRefNo.text = barcode.rawContent;
        getRef(txtRefNo.text);
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
