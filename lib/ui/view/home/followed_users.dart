import 'package:flutter/material.dart';
import 'package:letstogether/core/model/base/base_auth.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/base/drawer_page.dart';

class FollowedUsers extends StatefulWidget {

  
  final BaseAuth auth;

  const FollowedUsers({Key key, this.auth}) : super(key: key);
  
  @override
  _FollowedUsersState createState() => _FollowedUsersState();
}

class _FollowedUsersState extends State<FollowedUsers> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBarPage(title: AppLocalizations.of(context).translate('followedUsers')),
      drawer: DrawerPage(auth: widget.auth, ),
      body: Container()
    );
    
  }
}