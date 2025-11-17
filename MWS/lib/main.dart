import 'package:flutter/material.dart';
import 'package:flutter_epihhinventory/data/models/auth.dart';
import 'package:flutter_epihhinventory/ui/epipages/deliverytracking.dart';
import 'package:flutter_epihhinventory/ui/epipages/issueassembly.dart';
import 'package:flutter_epihhinventory/ui/epipages/issuemiscmaterial.dart';
import 'package:flutter_epihhinventory/ui/epipages/materialpickinglist.dart';
import 'package:flutter_epihhinventory/ui/epipages/materialloadinglist.dart';
import 'package:flutter_epihhinventory/ui/epipages/poreceiptlist.dart';
import 'package:flutter_epihhinventory/ui/epipages/jobtoinventory.dart';
import 'package:flutter_epihhinventory/ui/epipages/jobtosalvage.dart';
import 'package:flutter_epihhinventory/ui/epipages/moveinventory.dart';
import 'package:flutter_epihhinventory/ui/epipages/moveinventoryrequest.dart';
import 'package:flutter_epihhinventory/ui/epipages/prodclockin.dart';
import 'package:flutter_epihhinventory/ui/epipages/prodstartoperation.dart';
import 'package:flutter_epihhinventory/ui/epipages/prodworkqueuelist.dart';
import 'package:flutter_epihhinventory/ui/epipages/qtyadjustment.dart';
import 'package:flutter_epihhinventory/ui/epipages/reprintlabel.dart';
import 'package:flutter_epihhinventory/ui/epipages/returnassembly.dart';
import 'package:flutter_epihhinventory/ui/epipages/returnmaterial.dart';
import 'package:flutter_epihhinventory/ui/epipages/returnmiscmaterial.dart';
import 'package:flutter_epihhinventory/ui/epipages/selectcompany.dart';
import 'package:flutter_epihhinventory/ui/epipages/sitereceiptlist.dart';
import 'package:flutter_epihhinventory/ui/epipages/splitmergeuom.dart';
import 'package:flutter_epihhinventory/ui/epipages/systemsetting.dart';
import 'package:scoped_model/scoped_model.dart';
// import 'package:global_configuration/global_configuration.dart';

import 'ui/epipages/acceptinventoryrequestlist.dart';
import 'ui/lockedscreen/home.dart';
import 'ui/lockedscreen/settings.dart';
import 'ui/signin/newaccount.dart';
import 'ui/signin/signin.dart';
import 'ui/epipages/issuematerial.dart';
// import 'config/app_settings.config.dart';

void main() {
  //GlobalConfiguration().loadFromMap(appSettings);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthModel _auth = new AuthModel();

  @override
  void initState() {
    try {
      _auth.loadSettings();
    } catch (e) {
      print("Error Loading Settings: $e");
    }
    try {
      //_model.loadFromDisk();
    } catch (e) {
      print("Error Loading Theme: $e");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AuthModel>(
        model: _auth,
        child: new ScopedModelDescendant<AuthModel>(
          builder: (context, child, theme) => ScopedModel<AuthModel>(
            model: _auth,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: new ScopedModelDescendant<AuthModel>(
                  builder: (context, child, model) {
                if (model.user != null) return Home();
                return LoginPage(
                  username: '',
                );
              }),
              routes: <String, WidgetBuilder>{
                "/login": (BuildContext context) => LoginPage(
                      username: '',
                    ),
                "/menu": (BuildContext context) => Home(),
                "/home": (BuildContext context) => Home(),
                "/selectcompany": (BuildContext context) => SelectCompany(),
                "/issuematerial": (BuildContext context) => IssueMaterial(),
                "/issuemiscmaterial": (BuildContext context) =>
                    IssueMiscMaterial(),
                "/moveinventory": (BuildContext context) => MoveInventory(),
                "/moveinventoryrequest": (BuildContext context) =>
                    MoveInventoryRequest(),
                "/acceptinventoryrequest": (BuildContext context) =>
                    AcceptInventoryRequestList(),
                "/returnmaterial": (BuildContext context) => ReturnMaterial(),
                "/returnmiscmaterial": (BuildContext context) =>
                    ReturnMiscMaterial(),
                "/issueassembly": (BuildContext context) => IssueAssembly(),
                "/returnassembly": (BuildContext context) => ReturnAssembly(),
                "/jobtoinventory": (BuildContext context) => JobtoInventory(),
                "/jobtosalvage": (BuildContext context) => JobtoSalvage(),
                "/poreceipt": (BuildContext context) => POReceiptList(),
                "/sitereceipt": (BuildContext context) => SiteReceiptList(),
                "/splitmergeuom": (BuildContext context) => SplitMergeUOM(),
                "/deliverytracking": (BuildContext context) =>
                    DeliveryTracking(),
                "/reprintlabel": (BuildContext context) => ReprintLabel(),
                "/qtyadjustment": (BuildContext context) => QtyAdjustment(),
                "/prodclockin": (BuildContext context) => ProdClockIn(),
                "/prodstartoperation": (BuildContext context) =>
                    ProdStartOperation(),
                "/prodworkqueue": (BuildContext context) => ProdWorkQueueList(),
                "/settings": (BuildContext context) => SettingsPage(),
                "/materiallist": (BuildContext context) => MaterialList(),
                "/materialloadinglist": (BuildContext context) =>
                    Materialloadinglist(),
                // "/materialpicking": (BuildContext context) => MaterialPicking(),
                "/create": (BuildContext context) => CreateAccount(),
                "/systemsetting": (BuildContext context) => SystemSetting(),
              },
            ),
          ),
        ));
  }
}
