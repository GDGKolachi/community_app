import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pk/caches/user.dart';
import 'package:flutter_pk/contribution/contribution_dialog.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/helpers/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FullScreenProfileDialog extends StatefulWidget {
  static MaterialPageRoute get route => MaterialPageRoute(
        builder: (context) => FullScreenProfileDialog(),
        fullscreenDialog: true,
      );

  @override
  FullScreenProfileDialogState createState() {
    return new FullScreenProfileDialogState();
  }
}

class FullScreenProfileDialogState extends State<FullScreenProfileDialog> {
  User _user;
  SharedPreferencesHandler preferences;

  @override
  void initState() {
    super.initState();
    preferences = SharedPreferencesHandler();
    _setUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[
          FlatButton(
            child: Text('SIGN OUT'),
            onPressed: _signOut,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (_user != null) _buildBody(),
          ],
        ),
      ),
    );
  }

  void _signOut() async {
    try {
      await googleSignIn.signOut();
      await auth.signOut();
      preferences.clearPreferences();
      userCache.clear();
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.main,
        ModalRoute.withName(Routes.home),
      );
    } catch (ex) {
      print(ex);
      Alert(
        context: context,
        type: AlertType.error,
        title: "Oops!",
        desc: "An error has occurred",
        buttons: [
          DialogButton(
            child: Text("DISMISS",
                style: Theme.of(context).textTheme.title.copyWith(
                      color: Colors.white,
                    )),
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          )
        ],
      ).show();
    }
  }

  Widget _buildBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(_user.photoUrl),
                radius: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _user.name,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: Colors.grey),
                ),
              ),
              Text(
                _user.email,
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: Colors.black38),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              'Please show this QR code to the volunteers when they ask for it.',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: QrImage(
              data: _user.id,
              size: 300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: SizedBox(
              height: 50.0,
              child: Image(
                image: AssetImage('assets/feature.png'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Built with Flutter & Material'),
          ),
        ],
      ),
    );
  }

  Future _setUser() async {
    var user = await userCache.getUser(userCache.user.id);
    setState(() {
      _user = user;
    });
  }
}
