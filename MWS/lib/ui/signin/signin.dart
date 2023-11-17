import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_epihhinventory/ui/epipages/systemsetting.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:native_widgets/native_widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:global_configuration/global_configuration.dart';

import '../../constants.dart';
import '../../data/models/auth.dart';
import '../../utils/popUp.dart';
import '../../utils/globals.dart' as _globals;
import '../../data/web_client.dart';
import '../../data/classes/epienvironment.dart';
import '../../data/classes/user.dart';
//import 'newaccount.dart';
// import 'forgot.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.username});

  final String username;

  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String _status = 'no-action';
  String _username, _password;
  // String _refresh = '';

  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _controllerUsername, _controllerPassword;
  var txtDeviceId = new TextEditingController();

  EpiEnv _selectedEpiEnv;
  List<EpiEnv> _epienvs = new List<EpiEnv>();

  @override
  initState() {
    _controllerUsername = TextEditingController(text: widget?.username ?? "");
    _controllerPassword = TextEditingController();
    _loadUsername();

    super.initState();
    print(_status);

    loadEpiEnv();
  }

  void loadEpiEnv() {
    _epienvs.clear();

    _epienvs.add(new EpiEnv('0', 'Please select Epicor Environment', '-', '-'));

    setState(() {
      _selectedEpiEnv = _epienvs[0];
    });

    getEpiEnvList();

    // getEpiEnvList().then((List<EpiEnv> list) => setState(() {
    //       //_epienvs = list;
    //     }));
  }

  void _loadUsername() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _username = _prefs.getString("saved_username") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;
      _globals.epiApiBaseUrl = _prefs.getString("api_base_url") ?? "";

      if (_remeberMe) {
        _controllerUsername.text = _username ?? "";
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _auth = ScopedModel.of<AuthModel>(context, rebuildOnChange: true);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          key: PageStorageKey("Divider 1"),
          children: <Widget>[
            SizedBox(
              height: 220.0,
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.person,
                    size: 175.0,
                  )),
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (val) =>
                          val.length < 1 ? 'Username Required' : null,
                      onSaved: (val) => _username = val,
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      controller: _controllerUsername,
                      autocorrect: false,
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      validator: (val) =>
                          val.length < 1 ? 'Password Required' : null,
                      onSaved: (val) => _password = val,
                      obscureText: true,
                      controller: _controllerPassword,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                    ),
                  ),
                  ListTile(
                    title: DropdownButton<EpiEnv>(
                      value: _selectedEpiEnv,
                      onChanged: (EpiEnv _newValue) {
                        setState(() {
                          _selectedEpiEnv = _newValue;
                          _globals.epiEnvId = _selectedEpiEnv.id;
                          _globals.epiEnvName = _selectedEpiEnv.name;
                          _globals.epibarcodeseperator =
                              _selectedEpiEnv.seperator;
                          _globals.epibarcodeseperator2 =
                              _selectedEpiEnv.seperator2;
                        });
                      },
                      items: _epienvs.map((EpiEnv _epienv) {
                        return new DropdownMenuItem<EpiEnv>(
                          value: _epienv,
                          child: new Text(
                            _epienv.name,
                            style: new TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(labelText: 'Device Id'),
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      controller: txtDeviceId,
                      enabled: false,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: Text(
                  'Remember Me',
                  textScaleFactor: textScaleFactor,
                ),
                trailing: NativeSwitch(
                  onChanged: _auth.handleRememberMe,
                  value: _auth.rememberMe,
                ),
              ),
              trailing: SizedBox(
                width: 54,
                child: RaisedButton(
                  child: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SystemSetting(),
                          fullscreenDialog: true),
                    ).then((success) async {
                      if (success == true) {
                        SharedPreferences _prefs =
                            await SharedPreferences.getInstance();
                        _globals.epiApiBaseUrl =
                            _prefs.getString("api_base_url") ?? "";

                        loadEpiEnv();
                      }
                    });
                  },
                ),
              ),
            ),
            ListTile(
              title: NativeButton(
                child: Text(
                  'Login',
                  textScaleFactor: textScaleFactor,
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                disabledColor: Colors.grey,
                onPressed: () {
                  _scaffoldKey.currentState.hideCurrentSnackBar();

                  /* if (_selectedEpiEnv.id == "0") {
                    showAlertPopup(context, 'Info', 'Please select Epicor Environment...');
                  } else { */
                  final form = formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    final snackbar = SnackBar(
                      duration: Duration(seconds: 20),
                      content: Row(
                        children: <Widget>[
                          NativeLoadingIndicator(),
                          Text("  Logging In...")
                        ],
                      ),
                    );
                    _scaffoldKey.currentState.showSnackBar(snackbar);

                    setState(() => this._status = 'loading');
                    _auth
                        .login(
                      username: _username.toString().toLowerCase().trim(),
                      password: _password.toString().trim(),
                      epienv: _globals.epiEnvId,
                    )
                        .then((result) {
                      if (result) {
                        _globals.epiUsername =
                            _username.toString().toLowerCase().trim();
                        _globals.epiPassword = _password.toString().trim();
                      } else {
                        setState(() => this._status = 'rejected');
                        showAlertPopup(context, 'Alert', _auth.errorMessage);
                      }
                      // if (!globals.isBioSetup) {
                      //   setState(() {
                      //     print('Bio No Longer Setup');
                      //   });
                      // }
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                    });
                  }
                  //}
                },
              ),
              // trailing: !globals.isBioSetup
              //     ? null
              //     : NativeButton(
              //         child: Icon(
              //           Icons.fingerprint,
              //           color: Colors.white,
              //         ),
              //         color: Colors.redAccent[400],
              //         onPressed: globals.isBioSetup
              //             ? loginWithBio
              //             : () {
              //                 globals.Utility.showAlertPopup(context, 'Info',
              //                     "Please Enable in Settings after you Login");
              //               },
              //       ),
            ),
            /* NativeButton(
              child: Text(
                'Need an Account?',
                textScaleFactor: textScaleFactor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateAccount(),
                      fullscreenDialog: true),
                ).then((success) => success
                    ? showAlertPopup(
                        context, 'Info', "New Account Created, Login Now.")
                    : null);
              },
            ), */
          ],
        ),
      ),
    );
  }

  Future<List<EpiEnv>> getEpiEnvList() async {
    String _deviceid = await ImeiPlugin.getImei();
    txtDeviceId.text = _deviceid;
    //showAlertPopup(context, 'Alert', _deviceid);

    var _data = await WebClient(User(token: null)).get(
        _globals.epiApiBaseUrl + '/api/useracct/LoadActiveEpicEnvironment');

    EpiEnvironmentList _envData = EpiEnvironmentList.fromJson(_data);

    for (var i = 0; i < _envData.epienvlist.length; i++) {
      EpiEnv _epidata = new EpiEnv(
          _envData.epienvlist[i].envid,
          _envData.epienvlist[i].envdescription,
          _envData.epienvlist[i].envbarcodeseperator,
          _envData.epienvlist[i].envbarcodeseperator2);
      _epienvs.add(_epidata);
    }

    setState(() {});

    return _epienvs;
  }
}

class EpiEnv {
  const EpiEnv(this.id, this.name, this.seperator, this.seperator2);

  final String name;
  final String id;
  final String seperator;
  final String seperator2;
}
