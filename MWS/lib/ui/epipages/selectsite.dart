// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/data/classes/episite.dart';
import 'package:flutter_epihhinventory/data/classes/user.dart';
import 'package:flutter_epihhinventory/data/web_client.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
// import 'package:global_configuration/global_configuration.dart';

import '../../constants.dart';
import '../../utils/globals.dart' as _globals;

class SelectSite extends StatefulWidget {
  SelectSite();

  SelectSiteState createState() => SelectSiteState();
}

class SelectSiteState extends State<SelectSite> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Site? _selectedSite;
  List<Site> _sites = List<Site>.empty(growable: true);

  @override
  initState() {
    super.initState();

    if (_sites.length == 0) {
      _sites.add(new Site('0', 'Please select Site'));

      getEpiSiteList().then((List<Site> list) => setState(() {
            //_epienvs = list;
          }));
    } else {
      defaultSite();
    }
  }

  void defaultSite() {
    for (var i = 0; i < _sites.length; i++) {
      if (_sites[i].id == _globals.epiSiteId) {
        _selectedSite = _sites[i];
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
                  title: DropdownButton<Site>(
                    isExpanded: true,
                    value: _selectedSite,
                    onChanged: (Site? _newValue) {
                      setState(() {
                        _selectedSite = _newValue!;
                      });
                    },
                    items: _sites.map((Site _site) {
                      return new DropdownMenuItem<Site>(
                        value: _site,
                        child: new Text(
                          _site.name,
                          style: new TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ListTile(
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
                  if (_selectedSite?.id == "0") {
                    showAlertPopup(context, 'Warning', 'Please select Site...');
                  } else {
                    setState(() {
                      _globals.epiSiteId = _selectedSite?.id ?? "";
                      _globals.epiSiteName = _selectedSite?.name ?? "";
                    });
                    Navigator.pop(context, true);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Site>> getEpiSiteList() async {
    String _params = '?strUid=' +
        _globals.epiUsername +
        '&strPass=' +
        Uri.encodeComponent(_globals.epiPassword) +
        '&strEnvId=' +
        _globals.epiEnvId +
        '&strCompanyId=' +
        _globals.epiCompanyId;

    var _data = await WebClient(User(token: "")).get(_globals.epiApiBaseUrl +
        '/api/useracct/LoadPlantByCompanyId' +
        _params);

    EpiSiteList _envData = EpiSiteList.fromJson(_data);

    for (var i = 0; i < _envData.episitelist.length; i++) {
      Site _epidata = new Site(
          _envData.episitelist[i].siteplant, _envData.episitelist[i].name);
      _sites.add(_epidata);
    }

    if (_globals.epiSiteId == '') {
      _selectedSite = _sites[0];
    } else {
      defaultSite();
    }
    return _sites;
  }
}

class Site {
  const Site(this.id, this.name);

  final String name;
  final String id;
}
