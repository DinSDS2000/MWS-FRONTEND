// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/data/classes/epicompany.dart';
import 'package:flutter_epihhinventory/data/classes/user.dart';
import 'package:flutter_epihhinventory/data/models/auth.dart';
import 'package:flutter_epihhinventory/data/web_client.dart';
import 'package:flutter_epihhinventory/ui/epipages/selectsite.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:scoped_model/scoped_model.dart';
// import 'package:global_configuration/global_configuration.dart';

import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class SelectCompany extends StatefulWidget {
  SelectCompany();

  SelectCompanyState createState() => SelectCompanyState();
}

class SelectCompanyState extends State<SelectCompany> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late Company _selectedCompamy;
  List<Company> _companies = List<Company>.empty(growable: true);

  @override
  void initState() {
    super.initState();

    // Set initial with just placeholder
    _companies = [Company('0', 'Please select Company')];
    _selectedCompamy = _companies[0];

    // Fetch and update company list
    getEpiCompanyList().then((List<Company> list) {
      setState(() {
        // Create new list to avoid modifying during iteration
        _companies = [Company('0', 'Please select Company'), ...list];
        defaultCompany();
      });
    });
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
                    onChanged: (Company? _newValue) {
                      setState(() {
                        _selectedCompamy = _newValue!;
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
                    title: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                        foregroundColor: Colors.white, // Text color
                        padding: EdgeInsets.zero,
                        disabledBackgroundColor:
                            Colors.grey, // Disabled button color
                      ),
                      child: Text(
                        'Cancel',
                        textScaleFactor: textScaleFactor,
                      ),
                      onPressed: () async {
                        Navigator.pop(context, true);
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
                        disabledBackgroundColor:
                            Colors.grey, // Disabled button color
                      ),
                      child: Text(
                        'Save & Next',
                        textScaleFactor: textScaleFactor,
                      ),
                      onPressed: () async {
                        if (_selectedCompamy.id == "0") {
                          showAlertPopup(
                              context, 'Warning', 'Please select Company...');
                        } else {
                          // setState(() {
                          //   _globals.epiCompanyId = _selectedCompamy.id;
                          //   _globals.epiCompanyName = _selectedCompamy.name;
                          // });
                          final authModel = ScopedModel.of<AuthModel>(context);
                          authModel.updateSelectedCompany(
                              _selectedCompamy.id, _selectedCompamy.name);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectSite(),
                              fullscreenDialog: true,
                            ),
                          );
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

    var _data = await WebClient(User(token: '')).get(
        _globals.epiApiBaseUrl + '/api/useracct/LoadEpicUserCompany' + _params);

    EpiCompanyList _envData = EpiCompanyList.fromJson(_data);

    for (var i = 0; i < _envData.epicompanylist.length; i++) {
      Company _epidata = new Company(
          _envData.epicompanylist[i].companycode ?? "",
          _envData.epicompanylist[i].companyname ?? "");
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
