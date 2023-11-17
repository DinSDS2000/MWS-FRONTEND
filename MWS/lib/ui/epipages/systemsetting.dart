import 'package:flutter/material.dart';
import 'package:native_widgets/native_widgets.dart';
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
                    title: NativeButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        'Cancel',
                        textScaleFactor: textScaleFactor,
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                      disabledColor: Colors.grey,
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ListTile(
                    title: NativeButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        'Save',
                        textScaleFactor: textScaleFactor,
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                      disabledColor: Colors.grey,
                      onPressed: () async {
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setString("api_base_url", txtBaseUrl.text);
                        });

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
