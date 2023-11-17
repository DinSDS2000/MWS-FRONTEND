import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/data/classes/epicompany.dart';
import 'package:flutter_epihhinventory/data/classes/user.dart';
import 'package:flutter_epihhinventory/data/web_client.dart';
import 'package:flutter_epihhinventory/ui/epipages/selectsite.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
// import 'package:global_configuration/global_configuration.dart';
import 'package:native_widgets/native_widgets.dart';

import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class SelectCompany extends StatefulWidget {
  SelectCompany();

  SelectCompanyState createState() => SelectCompanyState();
}

class SelectCompanyState extends State<SelectCompany> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Company _selectedCompamy;
  List<Company> _companies = new List<Company>();

  @override
  initState() {
    super.initState();

    if (_companies.length == 0) {
      _companies.add(new Company('0', 'Please select Company'));

      getEpiCompanyList().then((List<Company> list) => setState(() {
            //_epienvs = list;
          }));
    } else {
      defaultCompany();
    }
  }

  void defaultCompany() {
    for (var i = 0; i < _companies.length; i++) {
      if (_companies[i].id == _globals.epiCompanyId) {
        _selectedCompamy = _companies[i];
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Select Company and Site",
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
                ListTile(
                  title: DropdownButton<Company>(
                    isExpanded: true,
                    value: _selectedCompamy,
                    onChanged: (Company _newValue) {
                      setState(() {
                        _selectedCompamy = _newValue;
                        if (_selectedCompamy.id != _globals.epiCompanyId) {
                          _globals.epiSiteId = '';
                          _globals.epiSiteName = '';
                        }
                      });
                    },
                    items: _companies.map((Company _company) {
                      return new DropdownMenuItem<Company>(
                        value: _company,
                        child: new Text(
                          _company.name,
                          style: new TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
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
                        Navigator.pop(context, true);
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
                        'Save & Next',
                        textScaleFactor: textScaleFactor,
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                      disabledColor: Colors.grey,
                      onPressed: () async {
                        if (_selectedCompamy.id == "0") {
                          showAlertPopup(
                              context, 'Warning', 'Please select Company...');
                        } else {
                          setState(() {
                            _globals.epiCompanyId = _selectedCompamy.id;
                            _globals.epiCompanyName = _selectedCompamy.name;
                          });

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectSite(),
                                  fullscreenDialog: true));
                        }
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

  Future<List<Company>> getEpiCompanyList() async {
    String _params = '?strUid=' +
        _globals.epiUsername +
        '&strPass=' +
        Uri.encodeComponent(_globals.epiPassword) +
        '&strEnvId=' +
        _globals.epiEnvId;

    var _data = await WebClient(User(token: null)).get(
        _globals.epiApiBaseUrl + '/api/useracct/LoadEpicUserCompany' + _params);

    EpiCompanyList _envData = EpiCompanyList.fromJson(_data);

    for (var i = 0; i < _envData.epicompanylist.length; i++) {
      Company _epidata = new Company(_envData.epicompanylist[i].companycode,
          _envData.epicompanylist[i].companyname);
      _companies.add(_epidata);
    }

    if (_globals.epiCompanyId == '') {
      _selectedCompamy = _companies[0];
    } else {
      defaultCompany();
    }

    return _companies;
  }
}

class Company {
  const Company(this.id, this.name);

  final String name;
  final String id;
}
