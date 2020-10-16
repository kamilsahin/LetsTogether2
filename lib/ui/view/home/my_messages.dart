import 'package:flutter/material.dart';
import 'package:letstogether/core/model/base/base_auth.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/base/drawer_page.dart';

class MyMessages extends StatefulWidget {
  final BaseAuth auth;

  const MyMessages({Key key, this.auth}) : super(key: key);
  
  @override
  _MyMessagesState createState() => _MyMessagesState();
}

class _MyMessagesState extends State<MyMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPage(title: AppLocalizations.of(context).translate('myMessages')),
      body: Container(),
      drawer: DrawerPage(auth: widget.auth, ),

    );
  }
}