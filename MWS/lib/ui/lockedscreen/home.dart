// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/ui/epipages/acceptinventoryrequestlist.dart';
import 'package:flutter_epihhinventory/ui/epipages/customerreplacement.dart';
import 'package:flutter_epihhinventory/ui/epipages/customerreturn.dart';
import 'package:flutter_epihhinventory/ui/epipages/deliverytracking.dart';
import 'package:flutter_epihhinventory/ui/epipages/emptypackagingreturn.dart';
import 'package:flutter_epihhinventory/ui/epipages/issueassembly.dart';
import 'package:flutter_epihhinventory/ui/epipages/issuematerial.dart';
import 'package:flutter_epihhinventory/ui/epipages/issuemiscmaterial.dart';
import 'package:flutter_epihhinventory/ui/epipages/jobtoinventory.dart';
import 'package:flutter_epihhinventory/ui/epipages/jobtosalvage.dart';
import 'package:flutter_epihhinventory/ui/epipages/materialpickinglist.dart';
import 'package:flutter_epihhinventory/ui/epipages/materialloadinglist.dart';
import 'package:flutter_epihhinventory/ui/epipages/moveinventory.dart';
import 'package:flutter_epihhinventory/ui/epipages/moveinventoryrequest.dart';
import 'package:flutter_epihhinventory/ui/epipages/poreceiptlist.dart';
import 'package:flutter_epihhinventory/ui/epipages/prodclockin.dart';
import 'package:flutter_epihhinventory/ui/epipages/prodstartoperation.dart';
import 'package:flutter_epihhinventory/ui/epipages/prodworkqueuelist.dart';
import 'package:flutter_epihhinventory/ui/epipages/qtyadjustment.dart';
import 'package:flutter_epihhinventory/ui/epipages/reprintlabel.dart';
import 'package:flutter_epihhinventory/ui/epipages/returnassembly.dart';
import 'package:flutter_epihhinventory/ui/epipages/returnmaterial.dart';
import 'package:flutter_epihhinventory/ui/epipages/returnmiscmaterial.dart';
import 'package:flutter_epihhinventory/ui/epipages/sitereceiptlist.dart';
import 'package:flutter_epihhinventory/ui/epipages/splitmergeuom.dart';
import 'package:flutter_epihhinventory/ui/epipages/supplierreturn.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../constants.dart';
import '../../data/models/auth.dart';
import '../app/app_drawer.dart';
import '../../utils/globals.dart' as _globals;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = ScopedModel.of<AuthModel>(context, rebuildOnChange: true);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Home",
            textScaleFactor: textScaleFactor,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 50,
              bottom: TabBar(
                indicatorColor: Colors.red,
                tabs: [
                  Tab(icon: Icon(Icons.menu_book)),
                  Tab(icon: Icon(Icons.person)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                ListView(
                  children: [
                    Visibility(
                        visible: _globals.epiisenableissuematerial,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.launch,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Issue Material",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals.epiisenableissuematerial ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IssueMaterial()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenablereturnmaterial,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child:
                                    Icon(Icons.input, color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Return Material",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals.epiisenablereturnmaterial ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReturnMaterial()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenableissuemiscmaterial,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.launch,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Issue Miscellaneous Material",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals
                                        .epiisenableissuemiscmaterial ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IssueMiscMaterial()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenablereturnmiscmaterial,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child:
                                    Icon(Icons.input, color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Return Miscellaneous Material",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals
                                        .epiisenablereturnmiscmaterial ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReturnMiscMaterial()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenableissueassembly,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.launch,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Issue Assembly",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals.epiisenableissueassembly ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IssueAssembly()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenablereturnassembly,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child:
                                    Icon(Icons.input, color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Return Assembly",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals.epiisenablereturnassembly ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReturnAssembly()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenablemoveinventory,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.compare_arrows,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Move Inventory",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals.epiisenablemoveinventory ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MoveInventory()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenablemoveinventoryrequest,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.grading,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Move Inventory Request",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals
                                        .epiisenablemoveinventoryrequest ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MoveInventoryRequest(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenableiacceptinventoryrequest,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child:
                                    Icon(Icons.rule, color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Accept Inventory Request",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals
                                        .epiisenableiacceptinventoryrequest ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AcceptInventoryRequestList()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenablejobtoinventory,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.assignment_returned,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Job Receipt to Inventory",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals.epiisenablejobtoinventory ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              JobtoInventory()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenablejobtosalvage,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.assignment_return,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Job Receipt to Salvage",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals.epiisenablejobtosalvage ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              JobtoSalvage()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenableporeceipt,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.shopping_bag,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "PO Receipt",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals.epiisenableporeceipt ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              POReceiptList()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenablesitereceipt,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.shopping_bag,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Site Receipt",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals.epiisenableporeceipt ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SiteReceiptList()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenablesplitmergeuom,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.vertical_split,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Split/Merge UOM",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals.epiisenablesplitmergeuom ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SplitMergeUOM()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenabledeliverytracking,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.wysiwyg,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Delivery Tracking",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals
                                        .epiisenabledeliverytracking ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DeliveryTracking()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenablematerialpicking,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.shopping_bag,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Material Picking",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals
                                        .epiisenablematerialpicking ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MaterialList()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenablematerialloading,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.launch,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Material Loading",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals
                                        .epiisenablematerialloading ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Materialloadinglist()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: true,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.launch,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Empty Packaging Return",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals
                                        .epiisenablematerialloading ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EmptyPackaginGReturn()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: true,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.launch,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Customer Return",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals
                                        .epiisenablematerialloading ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CustomerReturn()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: true,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.launch,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Customer Replacement Item",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals
                                        .epiisenablematerialloading ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CustomerReplacementItem()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: true,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.launch,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Supplier Return",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals
                                        .epiisenablematerialloading ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SupplierReturn()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenablereprintlabel,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.receipt,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Reprint Label",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals.epiisenablereprintlabel ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReprintLabel()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenableqtyadjustment,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.exposure,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Quantity Adjustment",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals.epiisenableqtyadjustment ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              QtyAdjustment()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenableprodclockin,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child:
                                    Icon(Icons.alarm, color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Clock In",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals.epiisenableprodclockin ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProdClockIn()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenableprodstartoperation,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.addchart,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Start Operation",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals
                                        .epiisenableprodstartoperation ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProdStartOperation()));
                                }
                              },
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _globals.epiisenableprodworkqueue,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            side:
                                new BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.blue[900]!))),
                                child: Icon(Icons.assignment,
                                    color: Colors.blue[900]!),
                              ),
                              title: Text(
                                "Work Queue",
                                style: TextStyle(
                                    color: Colors.blue[900]!,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: Colors.blue[900]!, size: 30.0),
                              onTap: () {
                                if (_globals.epiCompanyId == '' ||
                                    _globals.epiSiteId == '') {
                                  showAlertPopup(context, 'Warning',
                                      'Please select the Company or Site.');
                                } else if (_globals.epiisenableprodworkqueue ==
                                    false) {
                                  showAlertPopup(context, 'Warning',
                                      'You do not have permission to access.');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProdWorkQueueList()));
                                }
                              },
                            ),
                          ),
                        )),
                  ],
                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(height: 10.0),
                      ListTile(
                        title: Text('ID'),
                        subtitle: _auth.user?.epicuserid == null
                            ? null
                            : Text(
                                _auth.user?.epicuserid.toString() ?? "",
                              ),
                      ),
                      ListTile(
                        title: Text('User Name'),
                        subtitle: _auth.user?.epicusername == null
                            ? null
                            : Text(
                                _auth.user?.epicusername.toString() ?? "",
                              ),
                      ),
                      ListTile(
                        title: Text('Company'),
                        subtitle: _globals.epiCompanyId == null
                            ? null
                            : Text(
                                _globals.epiCompanyId +
                                    ' - ' +
                                    _globals.epiCompanyName,
                              ),
                      ),
                      ListTile(
                        title: Text('Site'),
                        subtitle: _globals.epiSiteId == null
                            ? null
                            : Text(
                                _globals.epiSiteId +
                                    ' - ' +
                                    _globals.epiSiteName,
                              ),
                      ),
                      ListTile(
                        title: Text('Epicor Environment'),
                        subtitle: Text(
                          _globals.epiEnvId + ' - ' + _globals.epiEnvName,
                        ),
                      ),
                      ListTile(
                        title: Text('App Version'),
                        subtitle: Text(
                          _globals.appVersion,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(children: <Widget>[
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
                                'Logout',
                                textScaleFactor: textScaleFactor,
                              ),
                              onPressed: () {
                                _globals.clearAll();
                                _auth.logout();
                              },
                            ),
                          ),
                        )
                      ])
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
