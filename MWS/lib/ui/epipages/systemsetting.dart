// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/globals.dart' as _globals;

import '../../constants.dart';

class SystemSetting extends StatefulWidget {
  SystemSetting();

  SystemSettingState createState() => SystemSettingState();
}

class SystemSettingState extends State<SystemSetting> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var txtBaseUrl = new TextEditingController();

  @override
  initState() {
    super.initState();

    txtBaseUrl.text = _globals.epiApiBaseUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "System Setting",
          textScaleFactor: textScaleFactor,
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Base Url for API'),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: txtBaseUrl,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                        foregroundColor: Colors.white, // Text color
                        padding: EdgeInsets.zero,
                        disabledBackgroundColor: Colors.grey, // Disabled button color
                      ),
                      child: Text(
                        'Cancel',
                        textScaleFactor: textScaleFactor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ListTile(
                      title: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                        foregroundColor: Colors.white, // Text color
                        padding: EdgeInsets.zero,
                        disabledBackgroundColor: Colors.grey, // Disabled button color
                      ),
                      child: Text(
                        'Save',
                        textScaleFactor: textScaleFactor,
                      ),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString("api_base_url", txtBaseUrl.text);
                        
                        Navigator.pop(context, true);
                      },
                    ),

                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
