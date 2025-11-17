import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/ui/epipages/previewscreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';

class AttachmentList extends StatefulWidget {
  final String prefix;
  const AttachmentList({super.key, required this.prefix});

  @override
  State<AttachmentList> createState() => _AttachmentListState();
}

class _AttachmentListState extends State<AttachmentList> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _saving = false;
  List<FileSystemEntity> files = [];
  String _prefix = '';

  @override
  void initState() {
    _listofFiles();
    _prefix = widget.prefix;

    super.initState();
  }

  void _listofFiles() async {
    List<FileSystemEntity> tempFile = [];
    var directory = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      tempFile = Directory("$directory").listSync();
    });

    files.clear();

    for (int i = 0; i < tempFile.length; i++) {
      String fileNamePrefix =
          tempFile[i].toString().split('/').last.split('_').first;
      if (fileNamePrefix == _prefix) {
        files.add(tempFile[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Attachment List",
        ),
        automaticallyImplyLeading: false,
      ),
      body: ModalProgressHUD(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: new Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: ListView.builder(
                        itemCount: files.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new Card(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                ListTile(
                                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  //children: <Widget>[
                                  title: InkWell(
                                    child: new Text(
                                      files[index]
                                          .toString()
                                          .split('/')
                                          .last
                                          .replaceAll("'", ""),
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PreviewScreen(
                                            imageFile: files[index] as File,
                                            fileList: files,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  trailing: TextButton(
                                    child: const Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        print(files[index].toString());
                                        files[index].delete(recursive: true);
                                        _listofFiles();
                                      });
                                    },
                                  ),
                                  //],
                                ),
                              ]));
                        }),
                    //populateAttachmentList(context)),
                  ),
                )
              ],
            ),
          ),
          inAsyncCall: _saving),
    );
  }
}
