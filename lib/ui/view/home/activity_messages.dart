import 'package:flutter/material.dart';
import 'package:letstogether/core/model/entity/activity.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';

class ActivityMessages extends StatefulWidget {
  const ActivityMessages({Key key, this.activity}) : super(key: key);

  @override
  _ActivityMessagesState createState() => _ActivityMessagesState();

  
  final Activity activity;
}

class _ActivityMessagesState extends State<ActivityMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPage(title: AppLocalizations.of(context).translate('activityMessages')),
      body: Container()
    );
  }
}