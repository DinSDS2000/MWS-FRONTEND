// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../constants.dart';
import '../../data/models/auth.dart';
import '../../utils/popUp.dart';

class CreateAccount extends StatefulWidget {
  CreateAccountState createState() => CreateAccountState();
}

class CreateAccountState extends State<CreateAccount> {
  late String _username, _password;

  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late TextEditingController _controllerUsername, _controllerPassword;

  @override
  initState() {
    _controllerUsername = TextEditingController();
    _controllerPassword = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = ScopedModel.of<AuthModel>(context, rebuildOnChange: true);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Create Account",
          textScaleFactor: textScaleFactor,
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          key: PageStorageKey("Divider 1"),
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (val) =>
                          val!.length < 1 ? 'Username Required' : null,
                      onSaved: (val) => _username = val ?? '',
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
                          val!.length < 1 ? 'Password Required' : null,
                      onSaved: (val) => _password = val ?? '',
                      obscureText: true,
                      controller: _controllerPassword,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                ),
                child: Text(
                  'Save',
                  textScaleFactor: textScaleFactor,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  final form = formKey.currentState;
                  if (form!.validate()) {
                    form.save();
                    
                    // Show SnackBar with loading indicator
                    final snackbar = SnackBar(
                      duration: Duration(seconds: 30),
                      content: Row(
                        children: <Widget>[
                          CircularProgressIndicator(), // Native loading indicator
                          SizedBox(width: 10),
                          Text("Signing Up...")
                        ],
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);

                    _auth
                        .login(
                      username: _username.toString().toLowerCase().trim(),
                      password: _password.toString().trim(),
                      epienv: '',
                    )
                        .then((result) async {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      if (result) {
                        // Show success SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 3),
                            content: Row(
                              children: <Widget>[
                                CircularProgressIndicator(),
                                SizedBox(width: 10),
                                Text("Signing Up..."),
                              ],
                            ),
                          ),
                        );

                        await Future.delayed(Duration(seconds: 3));
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        Navigator.pop(context, true);
                      } else {
                        showAlertPopup(context, 'Info', _auth.errorMessage);
                      }
                    });
                  }
                },
              ),

            ),
          ],
        ),
      ),
    );
  }
}
