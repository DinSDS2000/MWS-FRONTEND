import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:global_configuration/global_configuration.dart';
import 'package:local_auth/local_auth.dart';
import 'package:native_widgets/native_widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:imei_plugin/imei_plugin.dart';

import '../classes/user.dart';
import '../web_client.dart';
import '../../utils/globals.dart' as _globals;

class AuthModel extends Model {
  String errorMessage = "";

  bool _rememberMe = false;
  bool _stayLoggedIn = true;
  bool _useBio = false;
  User _user;

  bool get rememberMe => _rememberMe;

  void handleRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("remember_me", value);
    });
  }

  bool get isBioSetup => _useBio;

  void handleIsBioSetup(bool value) {
    _useBio = value;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("use_bio", value);
    });
  }

  bool get stayLoggedIn => _stayLoggedIn;

  void handleStayLoggedIn(bool value) {
    _stayLoggedIn = value;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("stay_logged_in", value);
    });
  }

  void loadSettings() async {
    var _prefs = await SharedPreferences.getInstance();
    try {
      _useBio = _prefs.getBool("use_bio") ?? false;
    } catch (e) {
      print(e);
      _useBio = false;
    }
    try {
      _rememberMe = _prefs.getBool("remember_me") ?? false;
    } catch (e) {
      print(e);
      _rememberMe = false;
    }
    try {
      _stayLoggedIn = _prefs.getBool("stay_logged_in") ?? false;
    } catch (e) {
      print(e);
      _stayLoggedIn = false;
    }

    if (_stayLoggedIn) {
      User _savedUser;
      try {
        String _saved = _prefs.getString("user_data");
        print("Saved: $_saved");
        _savedUser = User.fromJson(json.decode(_saved));
      } catch (e) {
        print("User Not Found: $e");
      }
      if (_useBio) {
        if (await biometrics()) {
          _user = _savedUser;
        }
      } else {
        _user = _savedUser;
      }
    }
    notifyListeners();
  }

  Future<bool> biometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: false);
    } catch (e) {
      print(e);
    }
    return authenticated;
  }

  User get user => _user;

  Future<User> getInfo(String token, String epideviceid, String username,
      String password, String epienv) async {
    try {
      String _url = '';
      _url = _globals.epiApiBaseUrl + '/api/useracct/VerifyUserLogin';
      _url = _url +
          '?strUid=' +
          username +
          '&strPass=' +
          Uri.encodeComponent(password) +
          '&strEnvId=' +
          epienv +
          '&strIMEI=' +
          epideviceid;
      var _data = await WebClient(User(token: token)).getHttpReponse(
        _url,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ",
        },
        method: HttpMethod.get,
      );
      if (_data.statusCode == 401) {
        errorMessage = _data.body;
        return null;
      }

      var _newUser = User.fromJson(json.decode(_data.body));

      if (_newUser?.epicuserid == null) {
        errorMessage = 'Http error';
        return null;
      }
      _newUser?.token = token;
      _globals.epiCompanyId = _newUser?.epiccurcompany;
      _globals.epiCompanyName = _newUser?.epiccurcompanyname;
      _globals.epiSiteId = _newUser?.epicplant;
      _globals.epiSiteName = _newUser?.epicplantname;
      _globals.epiempid = _newUser?.epiempid;
      _globals.epiisenableissuematerial =
          _newUser?.epicenableissuematerial ?? false;
      _globals.epiisenablemoveinventory =
          _newUser?.epicenablemoveinventory ?? false;
      _globals.epiisenablereturnmaterial =
          _newUser?.epicenablereturnmaterial ?? false;
      _globals.epiisenablemoveinventoryrequest =
          _newUser?.epicenablemoveinventoryrequest ?? false;
      _globals.epiisenableiacceptinventoryrequest =
          _newUser?.epicenableacceptinventoryrequest ?? false;
      _globals.epiisenablejobtoinventory =
          _newUser?.epicenablejobtoinventory ?? false;
      _globals.epiisenablejobtosalvage =
          _newUser?.epicenablejobtosalvage ?? false;
      _globals.epiisenableporeceipt = _newUser?.epicenableporeceipt ?? false;
      _globals.epiisenableissueassembly =
          _newUser?.epienableissueassembly ?? false;
      _globals.epiisenablereturnassembly =
          _newUser?.epicenablereturnassembly ?? false;
      _globals.epiisenablesplitmergeuom =
          _newUser?.epienablesplitmergeuom ?? false;
      _globals.epiisenablereprintlabel =
          _newUser?.epienablereprintlabel ?? false;
      _globals.epiisenabledeliverytracking =
          _newUser?.epienabledeliverytracking ?? false;
      _globals.epiisenableissuemiscmaterial =
          _newUser?.epienableissuemiscmaterial ?? false;
      _globals.epiisenablereturnmiscmaterial =
          _newUser?.epienablereturnmiscmaterial ?? false;
      _globals.epiisenableqtyadjustment =
          _newUser?.epienableqtyadjustment ?? false;
      _globals.epiisenableprodclockin = _newUser?.epienableclockin ?? false;
      _globals.epiisenableprodstartoperation =
          _newUser?.epienablestartoperation ?? false;
      _globals.epiisenableprodworkqueue = _newUser?.epienableworkqueue ?? false;
      _globals.epiisenableusedefaultlabelqty =
          _newUser?.epienabledefaultlabelqty ?? false;
      return _newUser;
    } catch (e) {
      errorMessage = "Could Not Load Data: $e";
      print("Could Not Load Data: $e");
      return null;
    }
  }

  Future<bool> login({
    @required String username,
    @required String password,
    @required String epienv,
  }) async {
    var uuid = new Uuid();
    String _epideviceid = "";
    String _username = username;
    String _password = password;
    String _epienv = epienv;

    await Future.delayed(Duration(seconds: 3));
    print("Logging In => $_username, $_password");

    if (_rememberMe) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString("saved_username", _username);
      });
    }

    _epideviceid = await ImeiPlugin.getImei();

    // Get Info For User
    User _newUser = await getInfo(
        uuid.v4().toString(), _epideviceid, _username, _password, _epienv);
    if (_newUser != null) {
      _user = _newUser;
      notifyListeners();

      SharedPreferences.getInstance().then((prefs) {
        var _save = json.encode(_user.toJson());
        print("Data: $_save");
        prefs.setString("user_data", _save);
      });
    } else {
      return false;
    }

    //if (_newUser?.token == null || _newUser.token.isEmpty) return false;

    return true;
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("user_data", null);
    });
    return;
  }
}
