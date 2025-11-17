import 'dart:io';

import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  final File imageFile;
  final List fileList;

  const PreviewScreen(
      {super.key, required this.imageFile, required this.fileList});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  File? imageFile;
  List fileList = [];

  @override
  void initState() {
    // Hide the status bar in Android
    //SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    imageFile = widget.imageFile;
    fileList = widget.fileList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.file(imageFile!),
          ),
        ],
      ),
    );
  }
}
