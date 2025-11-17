// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/constants.dart';
import 'package:flutter_epihhinventory/data/models/auth.dart';
import 'package:flutter_epihhinventory/utils/popUp.dart';
import 'package:flutter_whatsnew/flutter_whatsnew.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../utils/globals.dart' as _globals;

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = ScopedModel.of<AuthModel>(context, rebuildOnChange: true);
    return Drawer(
      child: SafeArea(
        // color: Colors.grey[50],
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.account_circle),
              title: _auth.user?.epicuserid == null
                  ? null
                  : Text(
                      _auth.user!.epicuserid + " " + _auth.user!.epicusername,
                      textScaleFactor: textScaleFactor,
                      maxLines: 1,
                    ),
              subtitle: _auth.user?.epicuserid == null
                  ? null
                  : Text(
                      _auth.user!.epicuserid.toString(),
                      textScaleFactor: textScaleFactor,
                      maxLines: 1,
                    ),
              // onTap: () {
              //   Navigator.of(context).popAndPushNamed("/myaccount");
              // },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.description),
              title: Text(
                'Company and Site',
                textScaleFactor: textScaleFactor,
              ),
              onTap: () {
                Navigator.of(context).popAndPushNamed("/selectcompany");
              },
            ),
            Visibility(
              visible: _globals.epiisenableissuematerial,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenableissuematerial,
              child: ListTile(
                leading: Icon(Icons.launch),
                title: Text(
                  'Issue Material',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenableissuematerial == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/issuematerial");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenablereturnmaterial,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenablereturnmaterial,
              child: ListTile(
                leading: Icon(Icons.input),
                title: Text(
                  'Return Material',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenablereturnmaterial == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/returnmaterial");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenableissuemiscmaterial,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenableissuemiscmaterial,
              child: ListTile(
                leading: Icon(Icons.launch),
                title: Text(
                  'Issue Misc Material',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenableissuemiscmaterial == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/issuemiscmaterial");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenablereturnmiscmaterial,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenablereturnmiscmaterial,
              child: ListTile(
                leading: Icon(Icons.input),
                title: Text(
                  'Return Misc Material',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenablereturnmiscmaterial == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context)
                        .popAndPushNamed("/returnmiscmaterial");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenableissueassembly,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenableissueassembly,
              child: ListTile(
                leading: Icon(Icons.launch),
                title: Text(
                  'Issue Assembly',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenableissueassembly == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/issueassembly");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenablereturnassembly,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenablereturnassembly,
              child: ListTile(
                leading: Icon(Icons.input),
                title: Text(
                  'Return Assembly',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenablereturnassembly == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/returnassembly");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenablemoveinventory,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenablemoveinventory,
              child: ListTile(
                leading: Icon(Icons.compare_arrows),
                title: Text(
                  'Move Inventory',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenablemoveinventory == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/moveinventory");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenablemoveinventoryrequest,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenablemoveinventoryrequest,
              child: ListTile(
                leading: Icon(Icons.grading),
                title: Text(
                  'Move Inventory Request',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenablemoveinventoryrequest ==
                      false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context)
                        .popAndPushNamed("/moveinventoryrequest");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenableiacceptinventoryrequest,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenableiacceptinventoryrequest,
              child: ListTile(
                leading: Icon(Icons.rule),
                title: Text(
                  'Accept Inventory Request',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenableiacceptinventoryrequest ==
                      false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context)
                        .popAndPushNamed("/acceptinventoryrequest");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenablejobtoinventory,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenablejobtoinventory,
              child: ListTile(
                leading: Icon(Icons.assignment_returned),
                title: Text(
                  'Job Receipt to Inventory',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenablejobtoinventory == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/jobtoinventory");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenablejobtosalvage,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenablejobtosalvage,
              child: ListTile(
                leading: Icon(Icons.assignment_return),
                title: Text(
                  'Job Receipt to Salvage',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenablejobtosalvage == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/jobtosalvage");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenableporeceipt,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenableporeceipt,
              child: ListTile(
                leading: Icon(Icons.shopping_bag),
                title: Text(
                  'PO Receipt',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenableporeceipt == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/poreceipt");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenablesitereceipt,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenablesitereceipt,
              child: ListTile(
                leading: Icon(Icons.shopping_bag),
                title: Text(
                  'Site Receipt',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenableporeceipt == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/sitereceipt");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenablesplitmergeuom,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenablesplitmergeuom,
              child: ListTile(
                leading: Icon(Icons.vertical_split),
                title: Text(
                  'Split/Merge UOM',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenablesplitmergeuom == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/splitmergeuom");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenabledeliverytracking,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenabledeliverytracking,
              child: ListTile(
                leading: Icon(Icons.wysiwyg),
                title: Text(
                  'Delivery Tracking',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenabledeliverytracking == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/deliverytracking");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenablematerialpicking,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenablematerialpicking,
              child: ListTile(
                leading: Icon(Icons.shopping_bag),
                title: Text(
                  'Material Picking',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenablematerialpicking == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/materiallist");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenablematerialloading,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenablematerialloading,
              child: ListTile(
                leading: Icon(Icons.shopping_bag),
                title: Text(
                  'Material Loading',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenablematerialloading == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context)
                        .popAndPushNamed("/materialloadinglist");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenablereprintlabel,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenablereprintlabel,
              child: ListTile(
                leading: Icon(Icons.receipt),
                title: Text(
                  'Reprint Label',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenablereprintlabel == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/reprintlabel");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenableqtyadjustment,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenableqtyadjustment,
              child: ListTile(
                leading: Icon(Icons.exposure),
                title: Text(
                  'Quanty Adjustment',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenableqtyadjustment == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/qtyadjustment");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenableprodclockin,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenableprodclockin,
              child: ListTile(
                leading: Icon(Icons.alarm),
                title: Text(
                  'Clock In',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenableprodclockin == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/prodclockin");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenableprodstartoperation,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenableprodstartoperation,
              child: ListTile(
                leading: Icon(Icons.addchart),
                title: Text(
                  'Start Operation',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenableprodstartoperation == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context)
                        .popAndPushNamed("/prodstartoperation");
                  }
                },
              ),
            ),
            Visibility(
              visible: _globals.epiisenableprodworkqueue,
              child: Divider(),
            ),
            Visibility(
              visible: _globals.epiisenableprodworkqueue,
              child: ListTile(
                leading: Icon(Icons.assignment),
                title: Text(
                  'Work Queue',
                  textScaleFactor: textScaleFactor,
                ),
                onTap: () {
                  if (_globals.epiCompanyId == '' || _globals.epiSiteId == '') {
                    showAlertPopup(context, 'Warning',
                        'Please select the Company or Site.');
                  } else if (_globals.epiisenableprodworkqueue == false) {
                    showAlertPopup(context, 'Warning',
                        'You do not have permission to access.');
                  } else {
                    Navigator.of(context).popAndPushNamed("/prodworkqueue");
                  }
                },
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                "What's New",
                textScaleFactor: textScaleFactor,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WhatsNewPage.changelog(
                      title: Text(
                        "What's New",
                        textScaleFactor: textScaleFactor,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      buttonText: Text(
                        'Continue',
                        textScaleFactor: textScaleFactor,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Settings',
                textScaleFactor: textScaleFactor,
              ),
              onTap: () {
                Navigator.of(context).popAndPushNamed("/settings");
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text(
                'Logout',
                textScaleFactor: textScaleFactor,
              ),
              onTap: () {
                _globals.clearAll();
                _auth.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
