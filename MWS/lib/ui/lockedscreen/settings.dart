// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../constants.dart';
import '../../data/models/auth.dart';

// Stateful widget for managing name data
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = ScopedModel.of<AuthModel>(context, rebuildOnChange: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          textScaleFactor: textScaleFactor,
        ),
      ),
      body: SingleChildScrollView(
          child: SafeArea(
        child: ListBody(
          children: <Widget>[
            Container(
              height: 10.0,
            ),
            /* ListTile(
              leading: Icon(Icons.fingerprint),
              title: Text(
                'Enable Biometrics',
                textScaleFactor: textScaleFactor,
              ),
              subtitle: Platform.isIOS
                  ? Text(
                      'TouchID or FaceID',
                      textScaleFactor: textScaleFactor,
                    )
                  : Text(
                      'Fingerprint',
                      textScaleFactor: textScaleFactor,
                    ),
              trailing: NativeSwitch(
                onChanged: _auth.handleIsBioSetup,
                value: _auth.isBioSetup,
              ),
            ), */
            Divider(
              height: 20.0,
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text(
                'Stay Logged In',
                textScaleFactor: textScaleFactor,
              ),
              subtitle: Text(
                'Logout from the Main Menu',
                textScaleFactor: textScaleFactor,
              ),
              trailing: Switch(
                value: _auth.stayLoggedIn,
                onChanged: _auth.handleStayLoggedIn,
                activeColor: Colors.blue, // Optional: Customize the switch color
              ),
            ),

            Divider(height: 20.0),
            // DarkModeSwitch(),
            // TrueBlackSwitch(),
            // CustomThemeSwitch(),
            // PrimaryColorPicker(),
            // AccentColorPicker(),
            // DarkAccentColorPicker(),
            Divider(height: 20.0),
          ],
        ),
      )),
    );
  }
}
